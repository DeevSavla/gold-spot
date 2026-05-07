// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ICSkipData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ICSkipData _$ICSkipDataFromJson(Map<String, dynamic> json) => ICSkipData()
  ..isStabilized = json['isStabilized'] as bool
  ..nodeId = json['nodeId'] as int
  ..battery = json['battery'] as int
  ..nodeInfo = json['nodeInfo'] as int
  ..time = json['time'] as int
  ..mode = $enumDecode(_$ICSkipModeEnumMap, json['mode'])
  ..setting = json['setting'] as int
  ..elapsed_time = json['elapsed_time'] as int
  ..actual_time = json['actual_time'] as int
  ..skip_count = json['skip_count'] as int
  ..avg_freq = json['avg_freq'] as int
  ..fastest_freq = json['fastest_freq'] as int
  ..freq_count = json['freq_count'] as int
  ..most_jump = json['most_jump'] as int
  ..calories_burned = (json['calories_burned'] as num).toDouble()
  ..fat_burn_efficiency = (json['fat_burn_efficiency'] as num).toDouble()
  ..freqs = _$JsonConverterFromJson<String, List<ICSkipFreqData>?>(
      json['freqs'], const ICSkipFreqDataConverter().fromJson);

Map<String, dynamic> _$ICSkipDataToJson(ICSkipData instance) =>
    <String, dynamic>{
      'isStabilized': instance.isStabilized,
      'nodeId': instance.nodeId,
      'battery': instance.battery,
      'nodeInfo': instance.nodeInfo,
      'time': instance.time,
      'mode': _$ICSkipModeEnumMap[instance.mode]!,
      'setting': instance.setting,
      'elapsed_time': instance.elapsed_time,
      'actual_time': instance.actual_time,
      'skip_count': instance.skip_count,
      'avg_freq': instance.avg_freq,
      'fastest_freq': instance.fastest_freq,
      'freq_count': instance.freq_count,
      'most_jump': instance.most_jump,
      'calories_burned': instance.calories_burned,
      'fat_burn_efficiency': instance.fat_burn_efficiency,
      'freqs': const ICSkipFreqDataConverter().toJson(instance.freqs),
    };

const _$ICSkipModeEnumMap = {
  ICSkipMode.ICSkipModeFreedom: 'ICSkipModeFreedom',
  ICSkipMode.ICSkipModeTiming: 'ICSkipModeTiming',
  ICSkipMode.ICSkipModeCount: 'ICSkipModeCount',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);
