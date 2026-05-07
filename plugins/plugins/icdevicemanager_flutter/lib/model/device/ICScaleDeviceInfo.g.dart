// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ICScaleDeviceInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ICScaleDeviceInfo _$ICScaleDeviceInfoFromJson(Map<String, dynamic> json) =>
    ICScaleDeviceInfo()
      ..mac = json['mac'] as String
      ..model = json['model'] as String
      ..sn = json['sn'] as String
      ..firmwareVer = json['firmwareVer'] as String
      ..softwareVer = json['softwareVer'] as String
      ..hardwareVer = json['hardwareVer'] as String
      ..manufactureName = json['manufactureName'] as String
      ..extInfo = _$JsonConverterFromJson<String, ICDeviceInfoExt>(
          json['extInfo'], const ICDeviceInfoExtConverter().fromJson)
      ..kg_scale_division = json['kg_scale_division'] as int
      ..lb_scale_division = json['lb_scale_division'] as int
      ..isSupportHr = json['isSupportHr'] as bool
      ..isSupportGravity = json['isSupportGravity'] as bool
      ..isSupportBalance = json['isSupportBalance'] as bool
      ..isSupportOTA = json['isSupportOTA'] as bool
      ..isSupportOffline = json['isSupportOffline'] as bool
      ..bfDataCalcType = json['bfDataCalcType'] as int
      ..isSupportUserInfo = json['isSupportUserInfo'] as bool
      ..maxUserCount = json['maxUserCount'] as int
      ..batteryType = json['batteryType'] as int
      ..bfaType = $enumDecode(_$ICBFATypeEnumMap, json['bfaType'])
      ..bfaType2 = $enumDecode(_$ICBFATypeEnumMap, json['bfaType2'])
      ..isSupportUnitKg = json['isSupportUnitKg'] as bool
      ..isSupportUnitLb = json['isSupportUnitLb'] as bool
      ..isSupportUnitStLb = json['isSupportUnitStLb'] as bool
      ..isSupportUnitJin = json['isSupportUnitJin'] as bool
      ..isSupportChangePole = json['isSupportChangePole'] as bool
      ..pole = json['pole'] as int
      ..impendenceType = json['impendenceType'] as int
      ..impendenceCount = json['impendenceCount'] as int
      ..impendencePrecision = json['impendencePrecision'] as int
      ..impendenceProperty = json['impendenceProperty'] as int
      ..enableMeasureImpendence = json['enableMeasureImpendence'] as bool
      ..enableMeasureHr = json['enableMeasureHr'] as bool
      ..enableMeasureBalance = json['enableMeasureBalance'] as bool
      ..enableMeasureGravity = json['enableMeasureGravity'] as bool;

Map<String, dynamic> _$ICScaleDeviceInfoToJson(ICScaleDeviceInfo instance) =>
    <String, dynamic>{
      'mac': instance.mac,
      'model': instance.model,
      'sn': instance.sn,
      'firmwareVer': instance.firmwareVer,
      'softwareVer': instance.softwareVer,
      'hardwareVer': instance.hardwareVer,
      'manufactureName': instance.manufactureName,
      'extInfo': _$JsonConverterToJson<String, ICDeviceInfoExt>(
          instance.extInfo, const ICDeviceInfoExtConverter().toJson),
      'kg_scale_division': instance.kg_scale_division,
      'lb_scale_division': instance.lb_scale_division,
      'isSupportHr': instance.isSupportHr,
      'isSupportGravity': instance.isSupportGravity,
      'isSupportBalance': instance.isSupportBalance,
      'isSupportOTA': instance.isSupportOTA,
      'isSupportOffline': instance.isSupportOffline,
      'bfDataCalcType': instance.bfDataCalcType,
      'isSupportUserInfo': instance.isSupportUserInfo,
      'maxUserCount': instance.maxUserCount,
      'batteryType': instance.batteryType,
      'bfaType': _$ICBFATypeEnumMap[instance.bfaType]!,
      'bfaType2': _$ICBFATypeEnumMap[instance.bfaType2]!,
      'isSupportUnitKg': instance.isSupportUnitKg,
      'isSupportUnitLb': instance.isSupportUnitLb,
      'isSupportUnitStLb': instance.isSupportUnitStLb,
      'isSupportUnitJin': instance.isSupportUnitJin,
      'isSupportChangePole': instance.isSupportChangePole,
      'pole': instance.pole,
      'impendenceType': instance.impendenceType,
      'impendenceCount': instance.impendenceCount,
      'impendencePrecision': instance.impendencePrecision,
      'impendenceProperty': instance.impendenceProperty,
      'enableMeasureImpendence': instance.enableMeasureImpendence,
      'enableMeasureHr': instance.enableMeasureHr,
      'enableMeasureBalance': instance.enableMeasureBalance,
      'enableMeasureGravity': instance.enableMeasureGravity,
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
