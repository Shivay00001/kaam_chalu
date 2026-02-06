import 'package:freezed_annotation/freezed_annotation.dart';

part 'workflow.freezed.dart';
part 'workflow.g.dart';

/// Workflow configuration saved by user
@freezed
class Workflow with _$Workflow {
  const factory Workflow({
    required String id,
    required String organizationId,
    required String templateId,
    required String name,
    @Default({}) Map<String, dynamic> config, // User-configured parameters
    String? schedule, // Cron expression
    @Default(true) bool isActive,
    DateTime? createdAt,
  }) = _Workflow;

  factory Workflow.fromJson(Map<String, dynamic> json) =>
      _$WorkflowFromJson(json);
}

/// Individual step in a workflow (system-defined, not user-editable)
@freezed
class WorkflowStep with _$WorkflowStep {
  const factory WorkflowStep({
    required String id,
    required String workflowId,
    required int stepOrder,
    required String actionType,
    required Map<String, dynamic> actionConfig,
    DateTime? createdAt,
  }) = _WorkflowStep;

  factory WorkflowStep.fromJson(Map<String, dynamic> json) =>
      _$WorkflowStepFromJson(json);
}

/// Execution run of a workflow
@freezed
class WorkflowRun with _$WorkflowRun {
  const factory WorkflowRun({
    required String id,
    required String workflowId,
    @Default('pending') String status, // 'pending', 'running', 'success', 'failed'
    DateTime? startedAt,
    DateTime? completedAt,
    @Default(1) int attemptCount,
    String? errorMessage,
  }) = _WorkflowRun;

  factory WorkflowRun.fromJson(Map<String, dynamic> json) =>
      _$WorkflowRunFromJson(json);
}

extension WorkflowRunX on WorkflowRun {
  bool get isSuccess => status == 'success';
  bool get isFailed => status == 'failed';
  bool get isRunning => status == 'running';
  bool get isPending => status == 'pending';
}

/// Detailed log entry for a workflow run
@freezed
class WorkflowLog with _$WorkflowLog {
  const factory WorkflowLog({
    required String id,
    required String runId,
    String? stepId,
    @Default('info') String level, // 'info', 'warn', 'error'
    required String message,
    @Default({}) Map<String, dynamic> metadata,
    DateTime? createdAt,
  }) = _WorkflowLog;

  factory WorkflowLog.fromJson(Map<String, dynamic> json) =>
      _$WorkflowLogFromJson(json);
}
