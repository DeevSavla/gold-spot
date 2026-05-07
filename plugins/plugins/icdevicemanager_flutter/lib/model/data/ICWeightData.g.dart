// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ICWeightData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ICWeightData _$ICWeightDataFromJson(Map<String, dynamic> json) => ICWeightData()
  ..userId = json['userId'] as int?
  ..isStabilized = json['isStabilized'] as bool
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
  ..temperature = (json['temperature'] as num).toDouble()
  ..isSupportHR = json['isSupportHR'] as bool
  ..hr = json['hr'] as int
  ..time = json['time'] as int
  ..bmi = (json['bmi'] as num).toDouble()
  ..bodyFatPercent = (json['bodyFatPercent'] as num).toDouble()
  ..subcutaneousFatPercent = (json['subcutaneousFatPercent'] as num).toDouble()
  ..visceralFat = (json['visceralFat'] as num).toDouble()
  ..musclePercent = (json['musclePercent'] as num).toDouble()
  ..bmr = json['bmr'] as int
  ..boneMass = (json['boneMass'] as num).toDouble()
  ..moisturePercent = (json['moisturePercent'] as num).toDouble()
  ..physicalAge = (json['physicalAge'] as num).toDouble()
  ..proteinPercent = (json['proteinPercent'] as num).toDouble()
  ..smPercent = (json['smPercent'] as num).toDouble()
  ..electrode = json['electrode'] as int
  ..bodyScore = (json['bodyScore'] as num).toDouble()
  ..bodyType = json['bodyType'] as int
  ..targetWeight = (json['targetWeight'] as num).toDouble()
  ..bfmControl = (json['bfmControl'] as num).toDouble()
  ..ffmControl = (json['ffmControl'] as num).toDouble()
  ..weightControl = (json['weightControl'] as num).toDouble()
  ..weightStandard = (json['weightStandard'] as num).toDouble()
  ..bfmStandard = (json['bfmStandard'] as num).toDouble()
  ..bmiStandard = (json['bmiStandard'] as num).toDouble()
  ..smmStandard = (json['smmStandard'] as num).toDouble()
  ..ffmStandard = (json['ffmStandard'] as num).toDouble()
  ..bfpStandard = (json['bfpStandard'] as num).toDouble()
  ..bmrStandard = json['bmrStandard'] as int
  ..bmiMax = (json['bmiMax'] as num).toDouble()
  ..bmiMin = (json['bmiMin'] as num).toDouble()
  ..bfmMax = (json['bfmMax'] as num).toDouble()
  ..bfmMin = (json['bfmMin'] as num).toDouble()
  ..bfpMax = (json['bfpMax'] as num).toDouble()
  ..bfpMin = (json['bfpMin'] as num).toDouble()
  ..weightMax = (json['weightMax'] as num).toDouble()
  ..weightMin = (json['weightMin'] as num).toDouble()
  ..smmMax = (json['smmMax'] as num).toDouble()
  ..smmMin = (json['smmMin'] as num).toDouble()
  ..boneMax = (json['boneMax'] as num).toDouble()
  ..boneMin = (json['boneMin'] as num).toDouble()
  ..bmrMax = json['bmrMax'] as int
  ..bmrMin = json['bmrMin'] as int
  ..waterMassMax = (json['waterMassMax'] as num).toDouble()
  ..waterMassMin = (json['waterMassMin'] as num).toDouble()
  ..proteinMassMax = (json['proteinMassMax'] as num).toDouble()
  ..proteinMassMin = (json['proteinMassMin'] as num).toDouble()
  ..muscleMassMax = (json['muscleMassMax'] as num).toDouble()
  ..muscleMassMin = (json['muscleMassMin'] as num).toDouble()
  ..smi = (json['smi'] as num).toDouble()
  ..obesityDegree = json['obesityDegree'] as int
  ..state = json['state'] as int
  ..imp = (json['imp'] as num).toDouble()
  ..imp2 = (json['imp2'] as num).toDouble()
  ..imp3 = (json['imp3'] as num).toDouble()
  ..imp4 = (json['imp4'] as num).toDouble()
  ..imp5 = (json['imp5'] as num).toDouble()
  ..extData = json['extData'] == null
      ? null
      : ICWeightExtData.fromJson(json['extData'] as Map<String, dynamic>)
  ..data_calc_type = json['data_calc_type'] as int
  ..bfa_type = $enumDecodeNullable(_$ICBFATypeEnumMap, json['bfa_type'])
  ..impendenceType = json['impendenceType'] as int
  ..impendenceProperty = json['impendenceProperty'] as int
  ..impendences = (json['impendences'] as List<dynamic>?)
      ?.map((e) => (e as num).toDouble())
      .toList();

Map<String, dynamic> _$ICWeightDataToJson(ICWeightData instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'isStabilized': instance.isStabilized,
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
      'temperature': instance.temperature,
      'isSupportHR': instance.isSupportHR,
      'hr': instance.hr,
      'time': instance.time,
      'bmi': instance.bmi,
      'bodyFatPercent': instance.bodyFatPercent,
      'subcutaneousFatPercent': instance.subcutaneousFatPercent,
      'visceralFat': instance.visceralFat,
      'musclePercent': instance.musclePercent,
      'bmr': instance.bmr,
      'boneMass': instance.boneMass,
      'moisturePercent': instance.moisturePercent,
      'physicalAge': instance.physicalAge,
      'proteinPercent': instance.proteinPercent,
      'smPercent': instance.smPercent,
      'electrode': instance.electrode,
      'bodyScore': instance.bodyScore,
      'bodyType': instance.bodyType,
      'targetWeight': instance.targetWeight,
      'bfmControl': instance.bfmControl,
      'ffmControl': instance.ffmControl,
      'weightControl': instance.weightControl,
      'weightStandard': instance.weightStandard,
      'bfmStandard': instance.bfmStandard,
      'bmiStandard': instance.bmiStandard,
      'smmStandard': instance.smmStandard,
      'ffmStandard': instance.ffmStandard,
      'bfpStandard': instance.bfpStandard,
      'bmrStandard': instance.bmrStandard,
      'bmiMax': instance.bmiMax,
      'bmiMin': instance.bmiMin,
      'bfmMax': instance.bfmMax,
      'bfmMin': instance.bfmMin,
      'bfpMax': instance.bfpMax,
      'bfpMin': instance.bfpMin,
      'weightMax': instance.weightMax,
      'weightMin': instance.weightMin,
      'smmMax': instance.smmMax,
      'smmMin': instance.smmMin,
      'boneMax': instance.boneMax,
      'boneMin': instance.boneMin,
      'bmrMax': instance.bmrMax,
      'bmrMin': instance.bmrMin,
      'waterMassMax': instance.waterMassMax,
      'waterMassMin': instance.waterMassMin,
      'proteinMassMax': instance.proteinMassMax,
      'proteinMassMin': instance.proteinMassMin,
      'muscleMassMax': instance.muscleMassMax,
      'muscleMassMin': instance.muscleMassMin,
      'smi': instance.smi,
      'obesityDegree': instance.obesityDegree,
      'state': instance.state,
      'imp': instance.imp,
      'imp2': instance.imp2,
      'imp3': instance.imp3,
      'imp4': instance.imp4,
      'imp5': instance.imp5,
      'extData': instance.extData,
      'data_calc_type': instance.data_calc_type,
      'bfa_type': _$ICBFATypeEnumMap[instance.bfa_type],
      'impendenceType': instance.impendenceType,
      'impendenceProperty': instance.impendenceProperty,
      'impendences': instance.impendences,
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
