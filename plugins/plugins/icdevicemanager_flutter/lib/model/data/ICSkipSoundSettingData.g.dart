// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ICSkipSoundSettingData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ICSkipSoundSettingData _$ICSkipSoundSettingDataFromJson(
        Map<String, dynamic> json) =>
    ICSkipSoundSettingData()
      ..soundOn = json['soundOn'] as bool
      ..soundType = $enumDecode(_$ICSkipSoundTypeEnumMap, json['soundType'])
      ..soundVolume = json['soundVolume'] as int
      ..fullScoreOn = json['fullScoreOn'] as bool
      ..fullScoreBPM = json['fullScoreBPM'] as int
      ..soundMode = $enumDecode(_$ICSkipSoundModeEnumMap, json['soundMode'])
      ..modeParam = json['modeParam'] as int
      ..isAutoStop = json['isAutoStop'] as bool;

Map<String, dynamic> _$ICSkipSoundSettingDataToJson(
        ICSkipSoundSettingData instance) =>
    <String, dynamic>{
      'soundOn': instance.soundOn,
      'soundType': _$ICSkipSoundTypeEnumMap[instance.soundType]!,
      'soundVolume': instance.soundVolume,
      'fullScoreOn': instance.fullScoreOn,
      'fullScoreBPM': instance.fullScoreBPM,
      'soundMode': _$ICSkipSoundModeEnumMap[instance.soundMode]!,
      'modeParam': instance.modeParam,
      'isAutoStop': instance.isAutoStop,
    };

const _$ICSkipSoundTypeEnumMap = {
  ICSkipSoundType.ICSkipSoundTypeNone: 'ICSkipSoundTypeNone',
  ICSkipSoundType.ICSkipSoundTypeFemale: 'ICSkipSoundTypeFemale',
  ICSkipSoundType.ICSkipSoundTypeMale: 'ICSkipSoundTypeMale',
};

const _$ICSkipSoundModeEnumMap = {
  ICSkipSoundMode.ICSkipSoundModeNone: 'ICSkipSoundModeNone',
  ICSkipSoundMode.ICSkipSoundModeTime: 'ICSkipSoundModeTime',
  ICSkipSoundMode.ICSkipSoundModeCount: 'ICSkipSoundModeCount',
};
