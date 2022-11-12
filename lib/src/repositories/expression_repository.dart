import 'package:luva/src/models/language.dart';

import '../database/database.dart';
import '../models/expression.dart';

Future<List<Expression>> getAllExpressions() async
{
  final db = await DB.instance.database;
  final maps = await db.query("expression");
  return maps.map((map) => Expression.fromMap(map)).toList();
}

Future<List<Expression>> getAllExpressionsByLanguage(Language language) async
{
  final db = await DB.instance.database;
  final maps = await db.query(
    "expression",
    where: "language_id = ?",
    whereArgs: [language.id]
  );
  return maps.map((map) => Expression.fromMap(map)).toList();
}

Future<bool> insertExpression(Expression data) async
{
  final db = await DB.instance.database;
  return await db.insert('expression', data.toMap()) != 0;
}

Future<void> deleteExpression(int id) async
{
  final db = await DB.instance.database;
  await db.delete(
    'expression',
    where: "id = ?",
    whereArgs: [id]
  );
}

Future<void> updateExpression(Expression expression) async
{
  final db = await DB.instance.database;
  await db.update(
    'expression',
    expression.toMap(),
    where: "id = ?",
    whereArgs: [expression.id],
  );
}