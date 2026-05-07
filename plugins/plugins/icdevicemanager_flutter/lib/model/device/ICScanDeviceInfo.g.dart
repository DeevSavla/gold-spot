// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ICScanDeviceInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ICScanDeviceInfo _$ICScanDeviceInfoFromJson(Map<String, dynamic> json) =>
    ICScanDeviceInfo()
      ..name = json['name'] as String?
      ..type = $enumDecodeNullable(_$ICDeviceTypeEnumMap, json['type'])
      ..subType = $enumDecodeNullable(_$ICDeviceSubTypeEnumMap, json['subType'])
      ..communicationType = $enumDecodeNullable(
          _$ICDeviceCommunicationTypeEnumMap, json['communicationType'])
      ..macAddr = json['macAddr'] as String?
      ..services =
          (json['services'] as List<dynamic>?)?.map((e) => e as String).toList()
      ..rssi = json['rssi'] as int
      ..st_no = json['st_no'] as int
      ..nodeId = json['nodeId'] as int
      ..deviceFlag = json['deviceFlag'] as int;

Map<String, dynamic> _$ICScanDeviceInfoToJson(ICScanDeviceInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': _$ICDeviceTypeEnumMap[instance.type],
      'subType': _$ICDeviceSubTypeEnumMap[instance.subType],
      'communicationType':
          _$ICDeviceCommunicationTypeEnumMap[instance.communicationType],
      'macAddr': instance.macAddr,
      'services': instance.services,
      'rssi': instance.rssi,
      'st_no': instance.st_no,
      'nodeId': instance.nodeId,
      'deviceFlag': instance.deviceFlag,
    };

const _$ICDeviceTypeEnumMap = {
  ICDeviceType.ICDeviceTypeUnKnown: 'ICDeviceTypeUnKnown',
  ICDeviceType.ICDeviceTypeWeightScale: 'ICDeviceTypeWeightScale',
  ICDeviceType.ICDeviceTypeFatScale: 'ICDeviceTypeFatScale',
  ICDeviceType.ICDeviceTypeFatScaleWithTemperature:
      'ICDeviceTypeFatScaleWithTemperature',
  ICDeviceType.ICDeviceTypeKitchenScale: 'ICDeviceTypeKitchenScale',
  ICDeviceType.ICDeviceTypeRuler: 'ICDeviceTypeRuler',
  ICDeviceType.ICDeviceTypeBalance: 'ICDeviceTypeBalance',
  ICDeviceType.ICDeviceTypeSkip: 'ICDeviceTypeSkip',
  ICDeviceType.ICDeviceTypeHR: 'ICDeviceTypeHR',
};

const _$ICDeviceSubTypeEnumMap = {
  ICDeviceSubType.ICDeviceSubTypeDefault: 'ICDeviceSubTypeDefault',
  ICDeviceSubType.ICDeviceSubTypeEightElectrode:
      'ICDeviceSubTypeEightElectrode',
  ICDeviceSubType.ICDeviceSubTypeHeight: 'ICDeviceSubTypeHeight',
  ICDeviceSubType.ICDeviceSubTypeEightElectrode2:
      'ICDeviceSubTypeEightElectrode2',
  ICDeviceSubType.ICDeviceSubTypeScaleDual: 'ICDeviceSubTypeScaleDual',
  ICDeviceSubType.ICDeviceSubTypeLightEffect: 'ICDeviceSubTypeLightEffect',
  ICDeviceSubType.ICDeviceSubTypeColor: 'ICDeviceSubTypeColor',
  ICDeviceSubType.ICDeviceSubTypeSound: 'ICDeviceSubTypeSound',
  ICDeviceSubType.ICDeviceSubTypeLightAndSound: 'ICDeviceSubTypeLightAndSound',
  ICDeviceSubType.ICDeviceSubTypeBaseSt: 'ICDeviceSubTypeBaseSt',
};

const _$ICDeviceCommunicationTypeEnumMap = {
  ICDeviceCommunicationType.ICDeviceCommunicationTypeUnknown:
      'ICDeviceCommunicationTypeUnknown',
  ICDeviceCommunicationType.ICDeviceCommunicationTypeConnect:
      'ICDeviceCommunicationTypeConnect',
  ICDeviceCommunicationType.ICDeviceCommunicationTypeBroadcast:
      'ICDeviceCommunicationTypeBroadcast',
};
