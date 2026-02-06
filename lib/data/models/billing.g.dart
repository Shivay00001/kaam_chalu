// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BillingImpl _$$BillingImplFromJson(Map<String, dynamic> json) =>
    _$BillingImpl(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String,
      plan: json['plan'] as String,
      amountInr: (json['amountInr'] as num).toInt(),
      status: json['status'] as String? ?? 'pending',
      paymentDate: json['paymentDate'] == null
          ? null
          : DateTime.parse(json['paymentDate'] as String),
      validUntil: json['validUntil'] == null
          ? null
          : DateTime.parse(json['validUntil'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$BillingImplToJson(_$BillingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizationId': instance.organizationId,
      'plan': instance.plan,
      'amountInr': instance.amountInr,
      'status': instance.status,
      'paymentDate': instance.paymentDate?.toIso8601String(),
      'validUntil': instance.validUntil?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };
