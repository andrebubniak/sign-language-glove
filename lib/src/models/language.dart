

class Language
{
  final int? id;
  final String name;
  final String? machineLearningModel;
  final int? deviceId;

  Language({this.id, required this.name, this.machineLearningModel, this.deviceId});

  factory Language.fromMap(Map map) => Language(
    id: map["id"],
    name: map["name"],
    machineLearningModel: map["machine_learning_model"],
    deviceId: map["device_id"]
  );

  Map<String, Object?> toMap() => 
  {
    "id": id,
    "name": name,
    "machine_learning_model": machineLearningModel,
    "device_id": deviceId
  };
}