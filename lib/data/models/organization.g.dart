// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrganizationImpl _$$OrganizationImplFromJson(Map<String, dynamic> json) =>
    _$OrganizationImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      mode: json['mode'] as String? ?? 'simple',
      billingPlan: json['billingPlan'] as String? ?? 'free',
      billingStatus: json['billingStatus'] as String? ?? 'active',
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$OrganizationImplToJson(_$OrganizationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'mode': instance.mode,
      'billingPlan': instance.billingPlan,
      'billingStatus': instance.billingStatus,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
