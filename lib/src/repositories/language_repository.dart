






import 'package:luva/src/models/language.dart';

import '../database/database.dart';
import '../models/device.dart';

Future<List<Language>> getAllLanguages() async
{
  final db = await DB.instance.database;
  final maps = await db.query("language");
  return maps.map((map) => Language.fromMap(map)).toList();
}

Future<List<Language>> getAllLanguagesByDevice(Device device) async
{
  final db = await DB.instance.database;
  final maps = await db.query(
    "language",
    where: "device_id = ?",
    whereArgs: [device.id]
  );
  return maps.map((map) => Language.fromMap(map)).toList();
}

Future<bool> insertLanguage(Language data) async
{
  final db = await DB.instance.database;
  return await db.insert('language', data.toMap()) != 0;
}

Future<void> deleteLanguage(int id) async
{
  final db = await DB.instance.database;
  await db.delete(
    'language',
    where: "id = ?",
    whereArgs: [id]
  );
}

Future<void> updateLanguage(Language language) async
{
  final db = await DB.instance.database;
  await db.update(
    'language',
    language.toMap(),
    where: "id = ?",
    whereArgs: [language.id],
  );
}