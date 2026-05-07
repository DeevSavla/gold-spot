// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ICWeightHistoryData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ICWeightHistoryData _$ICWeightHistoryDataFromJson(Map<String, dynamic> json) =>
    ICWeightHistoryData()
      ..userId = json['userId'] as int
      ..weight_g = json['weight_g'] as int
      ..weight_kg = (json['weight_kg'] as num).toDouble()
      ..weight_lb = (json['weight_lb'] as num).toDouble()
      ..weight_st = json['weight_st'] as int
      ..weight_st_lb = (json['weight_st_lb'] as num).toDouble()
      ..precision_kg = json['precision_kg'] as int
      ..precision_lb = json['precision_lb'] as int
      ..precision_st_lb = json['precision_st_lb'] as int
      ..kg_scale_division = json['kg_scale_division'] as int
      ..lb_scale_division = json['lb_scale_division'] as int
      ..time = json['time'] as int
      ..hr = json['hr'] as int
      ..electrode = json['electrode'] as int
      ..imp = (json['imp'] as num).toDouble()
      ..imp2 = (json['imp2'] as num).toDouble()
      ..imp3 = (json['imp3'] as num).toDouble()
      ..imp4 = (json['imp4'] as num).toDouble()
      ..imp5 = (json['imp5'] as num).toDouble()
      ..centerData = _$JsonConverterFromJson<String, ICWeightCenterData>(
          json['centerData'], const ICWeightCenterDataConverter().fromJson)
      ..data_calc_type = json['data_calc_type'] as int
      ..bfa_type = $enumDecode(_$ICBFATypeEnumMap, json['bfa_type'])
      ..impendenceType = json['impendenceType'] as int
      ..impendenceProperty = json['impendenceProperty'] as int
      ..impendences = (json['impendences'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList();

Map<String, dynamic> _$ICWeightHistoryDataToJson(
        ICWeightHistoryData instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'weight_g': instance.weight_g,
      'weight_kg': instance.weight_kg,
      'weight_lb': instance.weight_lb,
      'weight_st': instance.weight_st,
      'weight_st_lb': instance.weight_st_lb,
      'precision_kg': instance.precision_kg,
      'precision_lb': instance.precision_lb,
      'precision_st_lb': instance.precision_st_lb,
      'kg_scale_division': instance.kg_scale_division,
      'lb_scale_division': instance.lb_scale_division,
      'time': instance.time,
      'hr': instance.hr,
      'electrode': instance.electrode,
      'imp': instance.imp,
      'imp2': instance.imp2,
      'imp3': instance.imp3,
      'imp4': instance.imp4,
      'imp5': instance.imp5,
      'centerData': _$JsonConverterToJson<String, ICWeightCenterData>(
          instance.centerData, const ICWeightCenterDataConverter().toJson),
      'data_calc_type': instance.data_calc_type,
      'bfa_type': _$ICBFATypeEnumMap[instance.bfa_type]!,
      'impendenceType': instance.impendenceType,
      'impendenceProperty': instance.impendenceProperty,
      'impendences': instance.impendences,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

const _$ICBFATypeEnumMap = {
  ICBFAType.ICBFATypeWLA01: 'ICBFATypeWLA01',
  ICBFAType.ICBFATypeWLA02: 'ICBFATypeWLA02',
  ICBFAType.ICBFATypeWLA03: 'ICBFATypeWLA03',
  ICBFAType.ICBFATypeWLA04: 'ICBFATypeWLA04',
  ICBFAType.ICBFATypeWLA05: 'ICBFATypeWLA05',
  ICBFAType.ICBFATypeWLA06: 'ICBFATypeWLA06',
  ICBFAType.ICBFATypeWLA07: 'ICBFATypeWLA07',
  ICBFAType.ICBFATypeWLA08: 'ICBFATypeWLA08',
  ICBFAType.ICBFATypeWLA09: 'ICBFATypeWLA09',
  ICBFAType.ICBFATypeWLA10: 'ICBFATypeWLA10',
  ICBFAType.ICBFATypeWLA11: 'ICBFATypeWLA11',
  ICBFAType.ICBFATypeWLA12: 'ICBFATypeWLA12',
  ICBFAType.ICBFATypeWLA13: 'ICBFATypeWLA13',
  ICBFAType.ICBFATypeWLA14: 'ICBFATypeWLA14',
  ICBFAType.ICBFATypeWLA15: 'ICBFATypeWLA15',
  ICBFAType.ICBFATypeWLA16: 'ICBFATypeWLA16',
  ICBFAType.ICBFATypeWLA17: 'ICBFATypeWLA17',
  ICBFAType.ICBFATypeWLA18: 'ICBFATypeWLA18',
  ICBFAType.ICBFATypeWLA19: 'ICBFATypeWLA19',
  ICBFAType.ICBFATypeWLA20: 'ICBFATypeWLA20',
  ICBFAType.ICBFATypeWLA22: 'ICBFATypeWLA22',
  ICBFAType.ICBFATypeWLA23: 'ICBFATypeWLA23',
  ICBFAType.ICBFATypeWLA24: 'ICBFATypeWLA24',
  ICBFAType.ICBFATypeWLA25: 'ICBFATypeWLA25',
  ICBFAType.ICBFATypeWLA26: 'ICBFATypeWLA26',
  ICBFAType.ICBFATypeWLA27: 'ICBFATypeWLA27',
  ICBFAType.ICBFATypeWLA28: 'ICBFATypeWLA28',
  ICBFAType.ICBFATypeWLA29: 'ICBFATypeWLA29',
  ICBFAType.ICBFATypeUnknown: 'ICBFATypeUnknown',
  ICBFAType.ICBFATypeRev: 'ICBFATypeRev',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
