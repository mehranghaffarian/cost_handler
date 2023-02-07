part 'cost_entity.g.dart';

class CostEntity {
  final double value;
  final String? description;
  final String? destinationUserName;

  CostEntity({
    this.description,
    required this.value,
    this.destinationUserName,
  });

  factory CostEntity.fromMap(Map<String, dynamic> json) => CostEntity(
      value: json["value"],
      description: json["description"],
      destinationUserName: json["destinationUserName"]);

  Map<String, dynamic> toMap() {
    return {
      "value": value,
      "description": description,
      "destinationUserName": destinationUserName,
    };
  }
}
