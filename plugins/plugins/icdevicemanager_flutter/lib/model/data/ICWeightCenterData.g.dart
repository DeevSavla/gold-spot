// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ICWeightCenterData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ICWeightCenterData _$ICWeightCenterDataFromJson(Map<String, dynamic> json) =>
    ICWeightCenterData()
      ..isStabilized = json['isStabilized'] as bool
      ..time = json['time'] as int
      ..precision_kg = json['precision_kg'] as int
      ..precision_lb = json['precision_lb'] as int
      ..precision_st_lb = json['precision_st_lb'] as int
      ..kg_scale_division = json['kg_scale_division'] as int
      ..lb_scale_division = json['lb_scale_division'] as int
      ..leftPercent = (json['leftPercent'] as num).toDouble()
      ..rightPercent = (json['rightPercent'] as num).toDouble()
      ..left_weight_g = json['left_weight_g'] as int
      ..right_weight_g = json['right_weight_g'] as int
      ..left_weight_kg = (json['left_weight_kg'] as num).toDouble()
      ..right_weight_kg = (json['right_weight_kg'] as num).toDouble()
      ..left_weight_lb = (json['left_weight_lb'] as num).toDouble()
      ..right_weight_lb = (json['right_weight_lb'] as num).toDouble()
      ..left_weight_st = json['left_weight_st'] as int
      ..right_weight_st = json['right_weight_st'] as int
      ..left_weight_st_lb = (json['left_weight_st_lb'] as num).toDouble()
      ..right_weight_st_lb = (json['right_weight_st_lb'] as num).toDouble();

Map<String, dynamic> _$ICWeightCenterDataToJson(ICWeightCenterData instance) =>
    <String, dynamic>{
      'isStabilized': instance.isStabilized,
      'time': instance.time,
      'precision_kg': instance.precision_kg,
      'precision_lb': instance.precision_lb,
      'precision_st_lb': instance.precision_st_lb,
      'kg_scale_division': instance.kg_scale_division,
      'lb_scale_division': instance.lb_scale_division,
      'leftPercent': instance.leftPercent,
      'rightPercent': instance.rightPercent,
      'left_weight_g': instance.left_weight_g,
      'right_weight_g': instance.right_weight_g,
      'left_weight_kg': instance.left_weight_kg,
      'right_weight_kg': instance.right_weight_kg,
      'left_weight_lb': instance.left_weight_lb,
      'right_weight_lb': instance.right_weight_lb,
      'left_weight_st': instance.left_weight_st,
      'right_weight_st': instance.right_weight_st,
      'left_weight_st_lb': instance.left_weight_st_lb,
      'right_weight_st_lb': instance.right_weight_st_lb,
    };
