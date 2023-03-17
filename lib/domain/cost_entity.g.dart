// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cost_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CostEntity _$CostEntityFromJson(Map<String, dynamic> json) => CostEntity(
      receivers:
          (json['receivers'] as List<dynamic>).map((e) => e as String).toList(),
      spender: json['spender'] as String,
      description: json['description'] as String?,
      value: (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$CostEntityToJson(CostEntity instance) =>
    <String, dynamic>{
      'value': instance.value,
      'description': instance.description,
      'receivers': instance.receivers,
      'spender': instance.spender,
    };
