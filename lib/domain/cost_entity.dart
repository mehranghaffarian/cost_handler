import 'package:hive/hive.dart';
part 'cost_entity.g.dart';

@HiveType(typeId: 0)
class CostEntity {
  @HiveField(0)
  final double value;
  @HiveField(1)
  final String? description;
  @HiveField(2)
  final int sourceUserId;
  @HiveField(3)
  final int? destinationUserId;

  CostEntity({
    this.description,
    required this.value,
    required this.sourceUserId,
    this.destinationUserId,
  });
}
