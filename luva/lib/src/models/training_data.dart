import '../database/database.dart';
import 'models.dart';

class TrainingData
{
  final int? id;
  final int? expressionId;

  final int flex1;
  final int flex2;
  final int flex3;
  final int flex4;
  final int flex5;

  final double mpuAccX;
  final double mpuAccY;
  final double mpuAccZ;

  TrainingData({
    this.id,
    this.expressionId,
    required this.flex1,
    required this.flex2,
    required this.flex3,
    required this.flex4,
    required this.flex5,
    required this.mpuAccX,
    required this.mpuAccY,
    required this.mpuAccZ,
  });

  factory TrainingData.fromMap(Map map) => TrainingData(
    id: map["id"],
    expressionId: map["expression_id"],
    flex1: map["flex1_value"],
    flex2: map["flex2_value"],
    flex3: map["flex3_value"],
    flex4: map["flex4_value"],
    flex5: map["flex5_value"],
    mpuAccX: map["mpu_ax_value"],
    mpuAccY: map["mpu_ay_value"],
    mpuAccZ: map["mpu_az_value"],
  );

  Map<String, Object?> toMap() => 
  {
    "id": id,
    "expression_id": expressionId,
    "flex1_value": flex1,
    "flex2_value": flex2,
    "flex3_value": flex3,
    "flex4_value": flex4,
    "flex5_value": flex5,
    "mpu_ax_value": mpuAccX,
    "mpu_ay_value": mpuAccY,
    "mpu_az_value": mpuAccZ,
  };

  @override
  String toString()
  {
    return "flex1: $flex1 | flex2: $flex2 | flex3: $flex3 | flex4: $flex4 | flex5: $flex5 | accX: $mpuAccX | accY: $mpuAccY | accZ: $mpuAccZ";
  }


  // #region db related functions

  static Future<List<TrainingData>> getAllByExpression(Expression expression) async
  {
    final db = await DB.instance.database;
    final maps = await db.query(
      "training_data",
      where: "expression_id = ?",
      whereArgs: [expression.id]
    );
    return maps.map((map) => TrainingData.fromMap(map)).toList();
  }


  static Future<void> insertList(List<TrainingData> data) async
  {
    final db = await DB.instance.database;
    final batch = db.batch();
    
    for(var trainingData in data)
    {
      batch.insert('training_data', trainingData.toMap());
    }

    await batch.commit();
  }

  // #endregion



}
