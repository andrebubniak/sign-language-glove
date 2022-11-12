import 'package:luva/src/models/language.dart';
import 'package:luva/src/models/training_data.dart';

import '../database/database.dart';
import '../models/expression.dart';


Future<List<TrainingData>> getAllTrainingDataByExpression(Expression expression) async
{
  final db = await DB.instance.database;
  final maps = await db.query(
    "training_data",
    where: "expression_id = ?",
    whereArgs: [expression.id]
  );
  return maps.map((map) => TrainingData.fromMap(map)).toList();
}

Future<bool> insertTrainingData(TrainingData data) async
{
  final db = await DB.instance.database;
  return await db.insert('training_data', data.toMap()) != 0;
}


Future<void> deleteTrainingDataByExpression(Expression expression) async
{
  final db = await DB.instance.database;
  await db.delete(
    'training_data',
    where: "expression_id = ?",
    whereArgs: [expression.id]
  );
}
