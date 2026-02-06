// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'integration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IntegrationImpl _$$IntegrationImplFromJson(Map<String, dynamic> json) =>
    _$IntegrationImpl(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String,
      type: json['type'] as String,
      status: json['status'] as String? ?? 'active',
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$IntegrationImplToJson(_$IntegrationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizationId': instance.organizationId,
      'type': instance.type,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
