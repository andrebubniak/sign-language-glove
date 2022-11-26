import '../database/database.dart';

// template for adding a new device with qr code
// {"name": "ESP32_LUVA", "service_uuid": "f6467fe0-3af7-4bdb-b5a5-4c9a5dec1568", "receive_data_characteristic_uuid": "6623079c-f1e4-433a-8bb6-d78c713eb51c"}

class Device {
  final int? id;
  final String name;
  final String serviceUUID;
  final String receiveDataCharacteristicUUID;

  Device({
    this.id,
    required this.name,
    required this.serviceUUID,
    required this.receiveDataCharacteristicUUID,
  });

  factory Device.fromMap(Map map) => Device(
      id: map["id"], name: map["name"], serviceUUID: map["service_uuid"], receiveDataCharacteristicUUID: map["receive_data_characteristic_uuid"]);

  Map<String, Object?> toMap() =>
      {"id": id, "name": name, "service_uuid": serviceUUID, "receive_data_characteristic_uuid": receiveDataCharacteristicUUID};

  @override
  bool operator ==(Object other) {
    if (other is Device) {
      return name == other.name && serviceUUID == other.serviceUUID && receiveDataCharacteristicUUID == other.receiveDataCharacteristicUUID;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(id, name, serviceUUID, receiveDataCharacteristicUUID);



  // #region db related functions

  static Future<List<Device>> getAll() async {
    final db = await DB.instance.database;
    final maps = await db.query("device");
    return maps.map((map) => Device.fromMap(map)).toList();
  }

  static Future<bool> insert(Device data) async {
    final db = await DB.instance.database;
    return await db.insert('device', data.toMap()) != 0;
  }

  static Future<void> delete(int id) async {
    final db = await DB.instance.database;
    await db.delete('device');
  }

  // #endregion

}
