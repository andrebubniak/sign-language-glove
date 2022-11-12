

class Expression
{
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

  Map<String, Object?> toMap() => 
  {
    "id": id,
    "name": name,
    "language_id": languageId,
  };
}













