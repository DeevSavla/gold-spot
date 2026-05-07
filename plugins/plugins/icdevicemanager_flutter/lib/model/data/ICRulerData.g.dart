// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ICRulerData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ICRulerData _$ICRulerDataFromJson(Map<String, dynamic> json) => ICRulerData()
  ..isStabilized = json['isStabilized'] as bool
  ..distance = json['distance'] as int
  ..distance_in = (json['distance_in'] as num).toDouble()
  ..distance_ft = json['distance_ft'] as int
  ..distance_ft_in = (json['distance_ft_in'] as num).toDouble()
  ..distance_cm = (json['distance_cm'] as num).toDouble()
  ..precision_in = json['precision_in'] as int
  ..precision_cm = json['precision_cm'] as int
  ..unit = $enumDecode(_$ICRulerUnitEnumMap, json['unit'])
  ..mode = $enumDecode(_$ICRulerMeasureModeEnumMap, json['mode'])
  ..time = json['time'] as int
  ..partsType = $enumDecode(_$ICRulerBodyPartsTypeEnumMap, json['partsType']);

Map<String, dynamic> _$ICRulerDataToJson(ICRulerData instance) =>
    <String, dynamic>{
      'isStabilized': instance.isStabilized,
      'distance': instance.distance,
      'distance_in': instance.distance_in,
      'distance_ft': instance.distance_ft,
      'distance_ft_in': instance.distance_ft_in,
      'distance_cm': instance.distance_cm,
      'precision_in': instance.precision_in,
      'precision_cm': instance.precision_cm,
      'unit': _$ICRulerUnitEnumMap[instance.unit]!,
      'mode': _$ICRulerMeasureModeEnumMap[instance.mode]!,
      'time': instance.time,
      'partsType': _$ICRulerBodyPartsTypeEnumMap[instance.partsType]!,
    };

const _$ICRulerUnitEnumMap = {
  ICRulerUnit.ICRulerUnitCM: 'ICRulerUnitCM',
  ICRulerUnit.ICRulerUnitInch: 'ICRulerUnitInch',
  ICRulerUnit.ICRulerUnitFtInch: 'ICRulerUnitFtInch',
};

const _$ICRulerMeasureModeEnumMap = {
  ICRulerMeasureMode.ICRulerMeasureModeLength: 'ICRulerMeasureModeLength',
  ICRulerMeasureMode.ICRulerMeasureModeGirth: 'ICRulerMeasureModeGirth',
};

const _$ICRulerBodyPartsTypeEnumMap = {
  ICRulerBodyPartsType.ICRulerPartsTypeShoulder: 'ICRulerPartsTypeShoulder',
  ICRulerBodyPartsType.ICRulerPartsTypeBicep: 'ICRulerPartsTypeBicep',
  ICRulerBodyPartsType.ICRulerPartsTypeChest: 'ICRulerPartsTypeChest',
  ICRulerBodyPartsType.ICRulerPartsTypeWaist: 'ICRulerPartsTypeWaist',
  ICRulerBodyPartsType.ICRulerPartsTypeHip: 'ICRulerPartsTypeHip',
  ICRulerBodyPartsType.ICRulerPartsTypeThigh: 'ICRulerPartsTypeThigh',
  ICRulerBodyPartsType.ICRulerPartsTypeCalf: 'ICRulerPartsTypeCalf',
};
