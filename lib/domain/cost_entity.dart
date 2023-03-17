import 'package:json_annotation/json_annotation.dart';

part 'cost_entity.g.dart';

@JsonSerializable()
class CostEntity {
  final double value;
  final String? description;
  final List<String> receivers;
  final String spender;

  CostEntity({required this.receivers, required this.spender,
    this.description,
    required this.value,
  });

  factory CostEntity.fromMap(Map<String, dynamic> json) => CostEntity(
      value: json["value"],
      description: json["description"],
      receivers: json["receivers"].map((e) => e).toList(),
      spender: json["spender"],
  );

  Map<String, dynamic> toMap() {
    return {
      "value": value,
      "description": description,
      "receivers": receivers,
      "spender": spender,
    };
  }
}
