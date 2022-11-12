
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:luva/src/models/language.dart';

import '../../bluetooth.dart';
import 'device.dart';

class SensorData extends ChangeNotifier
{
  late final BluetoothConnectionHandler _btHandler;
  BluetoothConnectionState get currentBluetoothConnectionState => _btHandler.currentBluetoothConnectionState;

  final Device device;
  Language? _currentLanguage;
  Language? get currentLanguage => _currentLanguage;
  set currentLanguage(Language? newLanguage)
  {
    _currentLanguage = newLanguage;
    notifyListeners();
  }

  int _flex1 = 0;
  int _flex2 = 0;
  int _flex3 = 0;
  int _flex4 = 0;
  int _flex5 = 0;
  double _mpuAccX = 0;
  double _mpuAccY = 0;
  double _mpuAccZ = 0;

  int get flex1 => _flex1;
  int get flex2 => _flex2;
  int get flex3 => _flex3;
  int get flex4 => _flex4;
  int get flex5 => _flex5;
  double get mpuAccX => _mpuAccX;
  double get mpuAccY => _mpuAccY;
  double get mpuAccZ => _mpuAccZ;


  late final StreamController<String> _translationStreamController;
  Stream<String> get translationStream => _translationStreamController.stream;

  SensorData({required this.device})
  {
    _translationStreamController = StreamController<String>.broadcast();
    _btHandler = BluetoothConnectionHandler(device: device, onReceiveData: sensorDataCallback, mtuSize: 135);
    _btHandler.addListener(() => notifyListeners());
    _btHandler.connect();
  }


  void reconnectBluetooth()
  {
    _btHandler.connect();
  }

  void disconnectBluetooth()
  {
    _btHandler.disconnect();
  }


  sensorDataCallback(String value)
  {
    try
    {
      final map = jsonDecode(value);

      final flexList = map["flex"];
      final accList = map["aceleracao"];

      _flex1 = int.tryParse(flexList[0]) ?? 0;
      _flex2 = int.tryParse(flexList[1]) ?? 0;
      _flex3 = int.tryParse(flexList[2]) ?? 0;
      _flex4 = int.tryParse(flexList[4]) ?? 0;
      _flex5 = int.tryParse(flexList[5]) ?? 0;

      _mpuAccX = double.tryParse(accList[0]) ?? 0;
      _mpuAccY = double.tryParse(accList[1]) ?? 0;
      _mpuAccZ = double.tryParse(accList[2]) ?? 0;  
    }
    catch(_) {}
  }
}