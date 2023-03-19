// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cost_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CostEntity _$CostEntityFromJson(Map<String, dynamic> json) => CostEntity(
      receiverUsersNames: (json['receiverUsersNames'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      spenderUserName: json['spenderUserName'] as String,
      description: json['description'] as String?,
      cost: (json['cost'] as num).toDouble(),
    );

Map<String, dynamic> _$CostEntityToJson(CostEntity instance) =>
    <String, dynamic>{
      'spenderUserName': instance.spenderUserName,
      'cost': instance.cost,
      'description': instance.description,
      'receiverUsersNames': instance.receiverUsersNames,
    };
