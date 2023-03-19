import 'package:json_annotation/json_annotation.dart';

part 'cost_entity.g.dart';

@JsonSerializable()
class CostEntity {
  final String spenderUserName;
  final double cost;
  final String? description;
  final List<String> receiverUsersNames;

  CostEntity({required this.receiverUsersNames, required this.spenderUserName,
    this.description,
    required this.cost,
  });

  factory CostEntity.fromJson(Map<String, dynamic> json) => _$CostEntityFromJson(json);
  Map<String, dynamic> toJson() => _$CostEntityToJson(this);
}
