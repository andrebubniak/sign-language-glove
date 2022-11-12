
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
}
