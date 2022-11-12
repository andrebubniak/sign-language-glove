import 'dart:convert';
//import 'package:location_permissions/location_permissions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:luva/src/models/device.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter_blue/flutter_blue.dart' as flutter_blue;

import 'package:permission_handler/permission_handler.dart';

class BluetoothConnectionHandler extends ChangeNotifier
{
  // device related attributes
  final Device device;
  DiscoveredDevice? _discoveredDevice;

  // device connection state attributes
  StreamSubscription<ConnectionStateUpdate>? _currentConnectionStream;
  BluetoothConnectionState _currentBluetoothConnectionState = BluetoothConnectionState.none;
  BluetoothConnectionState get currentBluetoothConnectionState => _currentBluetoothConnectionState;
  
  // flutterReactiveBle object
  final _flutterReactiveBle = FlutterReactiveBle();

  // callback for when receive data
  final void Function(String) onReceiveData;
  final int mtuSize;
  

  BluetoothConnectionHandler({required this.device, required this.onReceiveData, required this.mtuSize})
  {
    _flutterReactiveBle.logLevel = LogLevel.verbose;
  }


  // public functions

  Future<void> connect() async
  {
    await _currentConnectionStream?.cancel();
    bool isBluetoothOn = await flutter_blue.FlutterBlue.instance.isOn;
    if(!isBluetoothOn)
    {
      _currentBluetoothConnectionState = BluetoothConnectionState.bluetoothDisabled;
      notifyListeners();
      return;
    }
    bool permissionGranted = await _getPermissions();
    if(permissionGranted)
    {
      _currentBluetoothConnectionState = BluetoothConnectionState.connecting;
      notifyListeners();
      bool scanned = await _scanDevices();
      if(scanned)
      {
        await _connectToDevice();
      }
    }
  }// connect

  /*
  Future<bool> sendData(String data) async
  {
    if(_sendDataCharacteristic == null)
    {
      return false;
    }

    bool valueToReturn = true;
    await _flutterReactiveBle.writeCharacteristicWithResponse(_sendDataCharacteristic!, value: utf8.encode(data))
    .onError((error, stackTrace)
    {
      valueToReturn = false;
    });

    return valueToReturn;

  }// sendData
*/


  Future<void> disconnect() async
  {
    await _currentConnectionStream?.cancel();
    _currentBluetoothConnectionState = BluetoothConnectionState.deviceDisconnected;
    notifyListeners();
  }// disconnect



  // private functions

  Future<bool> _getPermissions() async
  {
    bool permGranted = false;
    if (Platform.isAndroid) 
    {
      final btPermission = await Permission.bluetooth.request();
      if(btPermission.isGranted)
      {
        final locationPermission = await Permission.location.request();
        if(locationPermission.isGranted)
        {
          permGranted = true;
        }
      }
    }

    else if (Platform.isIOS) 
    {
      permGranted = true;
    }
 
    if(!permGranted)
    {
      _currentBluetoothConnectionState = BluetoothConnectionState.permissionDenied;
      notifyListeners();
    }

    return permGranted;

  }// _getPermissions


  Future<bool> _scanDevices() async 
  {
    _discoveredDevice = null;
    final discoveredDevice = _flutterReactiveBle.scanForDevices(withServices: [Uuid.parse(device.serviceUUID)]).timeout(const Duration(seconds: 10), onTimeout: (event)
    {
      print("Scan Timeout");
      event.close();
    })
    .take(10)
    .firstWhere((element)
    {
      print("ACHOU ALGO");
      return element.name == device.name;
    });
    

    await discoveredDevice.then((value)
    {
      print("ACHOU ESP");
      _discoveredDevice = value;
    },
    onError: (error)
    {
      print("Error => $error");
      return;
    });

    if(_discoveredDevice != null)
    {
      print("DEVICE NOT NULL");
      //_initializeSubscriptions();
      return true;
    }
    _currentBluetoothConnectionState = BluetoothConnectionState.deviceNotFound;
    notifyListeners();
    return false;

  }// _scanDevices
  
  
  Future<void> _connectToDevice() async
  {
    _currentConnectionStream = _flutterReactiveBle.connectToAdvertisingDevice(
      id: _discoveredDevice!.id,
      prescanDuration: const Duration(seconds: 5),
      withServices: [Uuid.parse(device.serviceUUID)]
    )
    .listen((event) async
    {
      try
      {
        if(event.connectionState == DeviceConnectionState.connected)
        {
          _currentBluetoothConnectionState = BluetoothConnectionState.deviceConnected;
          await _initializeSubscription();
          notifyListeners();
        }
        else if(event.connectionState == DeviceConnectionState.disconnected || event.connectionState == DeviceConnectionState.disconnecting)
        {
          print("DESCONECTANDO");
          _currentBluetoothConnectionState = BluetoothConnectionState.deviceDisconnected;
          notifyListeners();
        }
      }
      catch (err)
      {
        print("ERRO no TRY => $err");
      }
    },
    onError: (error)
    {
      print("ERRO => $error");
      _currentBluetoothConnectionState = BluetoothConnectionState.deviceDisconnected;
      notifyListeners();
    });

  }// _connectToDevice
  
  Future<void> _initializeSubscription() async
  {
    if(_discoveredDevice == null) return;

    final currentMtu = await _flutterReactiveBle.requestMtu(deviceId: _discoveredDevice!.id, mtu: mtuSize);
    if(currentMtu < mtuSize)
    {
      _currentBluetoothConnectionState = BluetoothConnectionState.mtuDenied;
      return;
    }

    final characteristic = QualifiedCharacteristic(
      serviceId: Uuid.parse(device.serviceUUID),
      characteristicId: Uuid.parse(device.receiveDataCharacteristicUUID),
      deviceId: _discoveredDevice!.id
    );

    _flutterReactiveBle.subscribeToCharacteristic(characteristic).map((event) => utf8.decode(event)).listen(onReceiveData, onError: (err) {}, cancelOnError: false);

  }// _initializeSubscription

}


enum BluetoothConnectionState
{
  none,
  deviceNotFound,     
  deviceConnected,    
  permissionDenied,
  deviceDisconnected,
  bluetoothDisabled,
  mtuDenied,
  connecting
}