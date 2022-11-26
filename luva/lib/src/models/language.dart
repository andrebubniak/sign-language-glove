import '../database/database.dart';
import 'device.dart';

class Language {
  final int? id;
  final String name;
  final String? machineLearningModel;
  final int? deviceId;

  Language({this.id, required this.name, this.machineLearningModel, this.deviceId});

  factory Language.fromMap(Map map) =>
      Language(id: map["id"], name: map["name"], machineLearningModel: map["machine_learning_model"], deviceId: map["device_id"]);

  Map<String, Object?> toMap() => {"id": id, "name": name, "machine_learning_model": machineLearningModel, "device_id": deviceId};





  // #region db related functions

  static Future<List<Language>> getAllByDevice(Device device) async 
  {
    final db = await DB.instance.database;
    final maps = await db.query("language", where: "device_id = ?", whereArgs: [device.id]);
    return maps.map((map) => Language.fromMap(map)).toList();
  }

  static Future<Language> get(int id) async 
  {
    final db = await DB.instance.database;
    final maps = await db.query("language", where: "id = ?", whereArgs: [id]);

    return maps.map((value) => Language.fromMap(value)).toList().first;
  }

  static Future<bool> insert(Language data) async 
  {
    final db = await DB.instance.database;
    return await db.insert('language', data.toMap()) != 0;
  }

  static Future<void> delete(int id) async 
  {
    final db = await DB.instance.database;
    await db.delete('language', where: "id = ?", whereArgs: [id]);
  }

  static Future<void> update(Language language) async 
  {
    final db = await DB.instance.database;
    await db.update(
      'language',
      language.toMap(),
      where: "id = ?",
      whereArgs: [language.id],
    );
  }

  // #endregion

}
