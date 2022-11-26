import '../database/database.dart';
import 'language.dart';

class Expression {
  final int? id;
  final String name;
  final int? languageId;

  Expression({
    this.id,
    required this.name,
    this.languageId,
  });

  factory Expression.fromMap(Map map) => Expression(
        id: map["id"],
        name: map["name"],
        languageId: map["language_id"],
      );

  Map<String, Object?> toMap() => {
        "id": id,
        "name": name,
        "language_id": languageId,
      };



  // #region db related functions

  static Future<List<Expression>> getAll() async 
  {
    final db = await DB.instance.database;
    final maps = await db.query("expression");
    return maps.map((map) => Expression.fromMap(map)).toList();
  }

  static Future<List<Expression>> getAllByLanguage(Language? language) async 
  {
    if (language == null) return [];
    final db = await DB.instance.database;
    final maps = await db.query("expression", where: "language_id = ?", whereArgs: [language.id]);
    return maps.map((map) => Expression.fromMap(map)).toList();
  }

  static Future<int> insert(Expression data) async 
  {
    final db = await DB.instance.database;
    return await db.insert('expression', data.toMap());
  }

  static Future<Expression?> get(int id) async 
  {
    final db = await DB.instance.database;
    final query = await db.query('expression', where: 'id = ?', whereArgs: [id]);

    final list = query.map((map) => Expression.fromMap(map)).toList();

    return (list.isEmpty) ? null : list.first;
  }

  static Future<void> delete(int id) async 
  {
    final db = await DB.instance.database;
    await db.delete('expression', where: "id = ?", whereArgs: [id]);
  }

  // #endregion

}
