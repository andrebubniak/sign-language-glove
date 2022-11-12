

import 'package:luva/src/models/device.dart';
import 'package:sqflite/sqflite.dart';

import '../database/database.dart';

//class DeviceRepository


Future<List<Device>> getAllDevices() async
{
  final db = await DB.instance.database;
  final maps = await db.query("device");
  return maps.map((map) => Device.fromMap(map)).toList();
}

Future<bool> insertDevice(Device data) async
{
  final db = await DB.instance.database;
  return await db.insert('device', data.toMap()) != 0;
}

Future<void> deleteDevice(int id) async
{
  final db = await DB.instance.database;
  await db.delete('device');
}




