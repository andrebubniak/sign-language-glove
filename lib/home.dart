
import 'package:flutter/material.dart';
import 'package:luva/bluetooth.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

/*
class Home extends StatelessWidget 
{
  late final BluetoothConnectionHandler btHandler;
  Home({Key? key}) : super(key: key)
  {
    const String deviceName = "ESP32_LUVA";
    const String serviceUUID = "f6467fe0-3af7-4bdb-b5a5-4c9a5dec1568";
    const String sendDataUUID = "081ab48e-0a33-11ed-861d-0242ac120002"; 
    const String receiveDataUUID = "6623079c-f1e4-433a-8bb6-d78c713eb51c";

    btHandler = BluetoothConnectionHandler(deviceName, serviceUUID, sendDataUUID, receiveDataUUID);
  }


  
  
  Future<void> connectBluetooth() async
  {
    //final path = await sqflite.getDatabasesPath();
    //print("path => $path");
    BluetoothConnectionState state = await btHandler.connectDevice();
    if(state == BluetoothConnectionState.deviceConnected)
    {
      print("Conectou");
      btHandler.dataStream.listen((data)
      {
        print("Data => $data");
      });
    }
    else print("NAO CONECTOU = $state");
  }


  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      body: Center(
        child: OutlinedButton(
          onPressed: connectBluetooth,
          child: const Text("BLUETOOTH")
        ),
      ),
    ) ; 
  }
}


*/