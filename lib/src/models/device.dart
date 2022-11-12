

class Device
{
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
    id: map["id"],
    name: map["name"],
    serviceUUID: map["service_uuid"],
    receiveDataCharacteristicUUID: map["receive_data_characteristic_uuid"]
  );

  Map<String, Object?> toMap() =>
  {
    "id": id,
    "name": name,
    "service_uuid": serviceUUID,
    "receive_data_characteristic_uuid": receiveDataCharacteristicUUID
  };

  @override
  bool operator ==(Object other)
  {
    if(other is Device)
    {
      return name == other.name &&
        serviceUUID == other.serviceUUID &&
        receiveDataCharacteristicUUID == other.receiveDataCharacteristicUUID;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    serviceUUID,
    receiveDataCharacteristicUUID
  );

  

}


//{"name": "ESP32_LUVA", "service_uuid": "f6467fe0-3af7-4bdb-b5a5-4c9a5dec1568", "send_data_uuid": "081ab48e-0a33-11ed-861d-0242ac120002", "flex1_uuid": "9e7ea8e3-c41b-4e40-9837-f9cdd6c5cb9d", "flex2_uuid": "eb02d864-0af9-11ed-861d-0242ac120002", "mpu_x_uuid": "4e96bfb0-6a0b-46e8-9af6-af016920d1e4", "mpu_y_uuid": "0d3a7e90-0a33-11ed-861d-0242ac120002", "mpu_z_uuid": "b3d1aa30-3f09-47fc-b040-0172b2e0b367"}

//{"name": "ESP32_LUVA", "service_uuid": "f6467fe0-3af7-4bdb-b5a5-4c9a5dec1568", "receive_data_characteristic_uuid": "6623079c-f1e4-433a-8bb6-d78c713eb51c"}