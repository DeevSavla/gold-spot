// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ICUserInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ICUserInfo _$ICUserInfoFromJson(Map<String, dynamic> json) => ICUserInfo()
  ..userIndex = json['userIndex'] as int
  ..userId = json['userId'] as int
  ..nickName = json['nickName'] as String
  ..height = json['height'] as int
  ..weight = (json['weight'] as num).toDouble()
  ..targetWeight = (json['targetWeight'] as num).toDouble()
  ..age = json['age'] as int
  ..weightDirection = json['weightDirection'] as int
  ..bfaType = $enumDecode(_$ICBFATypeEnumMap, json['bfaType'])
  ..peopleType = $enumDecode(_$ICPeopleTypeEnumMap, json['peopleType'])
  ..sex = $enumDecode(_$ICSexTypeEnumMap, json['sex'])
  ..weightUnit = $enumDecode(_$ICWeightUnitEnumMap, json['weightUnit'])
  ..rulerUnit = $enumDecode(_$ICRulerUnitEnumMap, json['rulerUnit'])
  ..rulerMode = $enumDecode(_$ICRulerMeasureModeEnumMap, json['rulerMode'])
  ..kitchenUnit = $enumDecode(_$ICKitchenScaleUnitEnumMap, json['kitchenUnit'])
  ..enableMeasureImpendence = json['enableMeasureImpendence'] as bool
  ..enableMeasureHr = json['enableMeasureHr'] as bool
  ..enableMeasureBalance = json['enableMeasureBalance'] as bool
  ..enableMeasureGravity = json['enableMeasureGravity'] as bool
  ..lastImp = json['lastImp'] as int;

Map<String, dynamic> _$ICUserInfoToJson(ICUserInfo instance) =>
    <String, dynamic>{
      'userIndex': instance.userIndex,
      'userId': instance.userId,
      'nickName': instance.nickName,
      'height': instance.height,
      'weight': instance.weight,
      'targetWeight': instance.targetWeight,
      'age': instance.age,
      'weightDirection': instance.weightDirection,
      'bfaType': _$ICBFATypeEnumMap[instance.bfaType]!,
      'peopleType': _$ICPeopleTypeEnumMap[instance.peopleType]!,
      'sex': _$ICSexTypeEnumMap[instance.sex]!,
      'weightUnit': _$ICWeightUnitEnumMap[instance.weightUnit]!,
      'rulerUnit': _$ICRulerUnitEnumMap[instance.rulerUnit]!,
      'rulerMode': _$ICRulerMeasureModeEnumMap[instance.rulerMode]!,
      'kitchenUnit': _$ICKitchenScaleUnitEnumMap[instance.kitchenUnit]!,
      'enableMeasureImpendence': instance.enableMeasureImpendence,
      'enableMeasureHr': instance.enableMeasureHr,
      'enableMeasureBalance': instance.enableMeasureBalance,
      'enableMeasureGravity': instance.enableMeasureGravity,
      'lastImp': instance.lastImp,
    };

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

const _$ICPeopleTypeEnumMap = {
  ICPeopleType.ICPeopleTypeNormal: 'ICPeopleTypeNormal',
  ICPeopleType.ICPeopleTypeSportman: 'ICPeopleTypeSportman',
};

const _$ICSexTypeEnumMap = {
  ICSexType.ICSexTypeUnknown: 'ICSexTypeUnknown',
  ICSexType.ICSexTypeMale: 'ICSexTypeMale',
  ICSexType.ICSexTypeFemale: 'ICSexTypeFemal',
};

const _$ICWeightUnitEnumMap = {
  ICWeightUnit.ICWeightUnitKg: 'ICWeightUnitKg',
  ICWeightUnit.ICWeightUnitLb: 'ICWeightUnitLb',
  ICWeightUnit.ICWeightUnitSt: 'ICWeightUnitSt',
  ICWeightUnit.ICWeightUnitJin: 'ICWeightUnitJin',
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

const _$ICKitchenScaleUnitEnumMap = {
  ICKitchenScaleUnit.ICKitchenScaleUnitG: 'ICKitchenScaleUnitG',
  ICKitchenScaleUnit.ICKitchenScaleUnitMl: 'ICKitchenScaleUnitMl',
  ICKitchenScaleUnit.ICKitchenScaleUnitLb: 'ICKitchenScaleUnitLb',
  ICKitchenScaleUnit.ICKitchenScaleUnitOz: 'ICKitchenScaleUnitOz',
  ICKitchenScaleUnit.ICKitchenScaleUnitMg: 'ICKitchenScaleUnitMg',
  ICKitchenScaleUnit.ICKitchenScaleUnitMlMilk: 'ICKitchenScaleUnitMlMilk',
  ICKitchenScaleUnit.ICKitchenScaleUnitFlOzWater: 'ICKitchenScaleUnitFlOzWater',
  ICKitchenScaleUnit.ICKitchenScaleUnitFlOzMilk: 'ICKitchenScaleUnitFlOzMilk',
};
