// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workflow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkflowImpl _$$WorkflowImplFromJson(Map<String, dynamic> json) =>
    _$WorkflowImpl(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String,
      templateId: json['templateId'] as String,
      name: json['name'] as String,
      config: json['config'] as Map<String, dynamic>? ?? const {},
      schedule: json['schedule'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$WorkflowImplToJson(_$WorkflowImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizationId': instance.organizationId,
      'templateId': instance.templateId,
      'name': instance.name,
      'config': instance.config,
      'schedule': instance.schedule,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$WorkflowStepImpl _$$WorkflowStepImplFromJson(Map<String, dynamic> json) =>
    _$WorkflowStepImpl(
      id: json['id'] as String,
      workflowId: json['workflowId'] as String,
      stepOrder: (json['stepOrder'] as num).toInt(),
      actionType: json['actionType'] as String,
      actionConfig: json['actionConfig'] as Map<String, dynamic>,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$WorkflowStepImplToJson(_$WorkflowStepImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workflowId': instance.workflowId,
      'stepOrder': instance.stepOrder,
      'actionType': instance.actionType,
      'actionConfig': instance.actionConfig,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$WorkflowRunImpl _$$WorkflowRunImplFromJson(Map<String, dynamic> json) =>
    _$WorkflowRunImpl(
      id: json['id'] as String,
      workflowId: json['workflowId'] as String,
      status: json['status'] as String? ?? 'pending',
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      attemptCount: (json['attemptCount'] as num?)?.toInt() ?? 1,
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$$WorkflowRunImplToJson(_$WorkflowRunImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workflowId': instance.workflowId,
      'status': instance.status,
      'startedAt': instance.startedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'attemptCount': instance.attemptCount,
      'errorMessage': instance.errorMessage,
    };

_$WorkflowLogImpl _$$WorkflowLogImplFromJson(Map<String, dynamic> json) =>
    _$WorkflowLogImpl(
      id: json['id'] as String,
      runId: json['runId'] as String,
      stepId: json['stepId'] as String?,
      level: json['level'] as String? ?? 'info',
      message: json['message'] as String,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$WorkflowLogImplToJson(_$WorkflowLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'runId': instance.runId,
      'stepId': instance.stepId,
      'level': instance.level,
      'message': instance.message,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
