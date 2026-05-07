// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ICKitchenScaleData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ICKitchenScaleData _$ICKitchenScaleDataFromJson(Map<String, dynamic> json) =>
    ICKitchenScaleData()
      ..isStabilized = json['isStabilized'] as bool
      ..value_mg = json['value_mg'] as int
      ..value_g = (json['value_g'] as num).toDouble()
      ..value_ml = (json['value_ml'] as num).toDouble()
      ..value_ml_milk = (json['value_ml_milk'] as num).toDouble()
      ..value_oz = (json['value_oz'] as num).toDouble()
      ..value_lb = json['value_lb'] as int
      ..value_lb_oz = (json['value_lb_oz'] as num).toDouble()
      ..value_fl_oz = (json['value_fl_oz'] as num).toDouble()
      ..value_fl_oz_uk = (json['value_fl_oz_uk'] as num).toDouble()
      ..value_fl_oz_milk = (json['value_fl_oz_milk'] as num).toDouble()
      ..value_fl_oz_milk_uk = (json['value_fl_oz_milk_uk'] as num).toDouble()
      ..time = json['time'] as int
      ..precision = json['precision'] as int
      ..precision_g = json['precision_g'] as int
      ..precision_ml = json['precision_ml'] as int
      ..precision_lboz = json['precision_lboz'] as int
      ..precision_oz = json['precision_oz'] as int
      ..precision_ml_milk = json['precision_ml_milk'] as int
      ..precision_floz_us = json['precision_floz_us'] as int
      ..precision_floz_uk = json['precision_floz_uk'] as int
      ..precision_floz_milk_us = json['precision_floz_milk_us'] as int
      ..precision_floz_milk_uk = json['precision_floz_milk_uk'] as int
      ..unitType = json['unitType'] as int
      ..isNegative = json['isNegative'] as bool?
      ..isTare = json['isTare'] as bool?
      ..unit = $enumDecode(_$ICKitchenScaleUnitEnumMap, json['unit']);

Map<String, dynamic> _$ICKitchenScaleDataToJson(ICKitchenScaleData instance) =>
    <String, dynamic>{
      'isStabilized': instance.isStabilized,
      'value_mg': instance.value_mg,
      'value_g': instance.value_g,
      'value_ml': instance.value_ml,
      'value_ml_milk': instance.value_ml_milk,
      'value_oz': instance.value_oz,
      'value_lb': instance.value_lb,
      'value_lb_oz': instance.value_lb_oz,
      'value_fl_oz': instance.value_fl_oz,
      'value_fl_oz_uk': instance.value_fl_oz_uk,
      'value_fl_oz_milk': instance.value_fl_oz_milk,
      'value_fl_oz_milk_uk': instance.value_fl_oz_milk_uk,
      'time': instance.time,
      'precision': instance.precision,
      'precision_g': instance.precision_g,
      'precision_ml': instance.precision_ml,
      'precision_lboz': instance.precision_lboz,
      'precision_oz': instance.precision_oz,
      'precision_ml_milk': instance.precision_ml_milk,
      'precision_floz_us': instance.precision_floz_us,
      'precision_floz_uk': instance.precision_floz_uk,
      'precision_floz_milk_us': instance.precision_floz_milk_us,
      'precision_floz_milk_uk': instance.precision_floz_milk_uk,
      'unitType': instance.unitType,
      'isNegative': instance.isNegative,
      'isTare': instance.isTare,
      'unit': _$ICKitchenScaleUnitEnumMap[instance.unit]!,
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
