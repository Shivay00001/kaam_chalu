import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants/app_constants.dart';
import '../core/constants/workflow_templates.dart';
import '../data/models/workflow.dart';
import 'organization_service.dart';

final workflowServiceProvider = Provider<WorkflowService>((ref) {
  return WorkflowService(Supabase.instance.client, ref);
});

final workflowsProvider = FutureProvider.family<List<Workflow>, String>((ref, orgId) async {
  final service = ref.watch(workflowServiceProvider);
  return service.getWorkflows(orgId);
});

final workflowRunsProvider = FutureProvider.family<List<WorkflowRun>, String>((ref, workflowId) async {
  final service = ref.watch(workflowServiceProvider);
  return service.getWorkflowRuns(workflowId);
});

class WorkflowService {
  final SupabaseClient _client;
  final Ref _ref;

  WorkflowService(this._client, this._ref);

  /// Get all workflows for an organization
  Future<List<Workflow>> getWorkflows(String orgId) async {
    final data = await _client
        .from('workflows')
        .select()
        .eq('organization_id', orgId)
        .order('created_at', ascending: false);

    return data.map<Workflow>((json) => Workflow(
      id: json['id'],
      organizationId: json['organization_id'],
      templateId: json['template_id'],
      name: json['name'],
      config: Map<String, dynamic>.from(json['config'] ?? {}),
      schedule: json['schedule'],
      isActive: json['is_active'] ?? true,
    )).toList();
  }

  /// Create a new workflow from template
  Future<Workflow> createWorkflow({
    required String orgId,
    required String templateId,
    required String name,
    required Map<String, dynamic> config,
    String? schedule,
  }) async {
    final template = WorkflowTemplates.getById(templateId);
    if (template == null) {
      throw Exception('Unknown workflow template: $templateId');
    }

    // Insert workflow
    final workflowData = await _client.from('workflows').insert({
      'organization_id': orgId,
      'template_id': templateId,
      'name': name,
      'config': config,
      'schedule': schedule,
      'is_active': true,
    }).select().single();

    final workflowId = workflowData['id'];

    // Create workflow steps from template
    for (final step in template.steps) {
      await _client.from('workflow_steps').insert({
        'workflow_id': workflowId,
        'step_order': step.order,
        'action_type': step.action,
        'action_config': {
          'description': step.description,
          'conditional': step.conditional,
        },
      });
    }

    return Workflow(
      id: workflowId,
      organizationId: orgId,
      templateId: templateId,
      name: name,
      config: config,
      schedule: schedule,
      isActive: true,
    );
  }

  /// Update workflow config
  Future<void> updateWorkflow({
    required String workflowId,
    Map<String, dynamic>? config,
    String? schedule,
    bool? isActive,
  }) async {
    final updates = <String, dynamic>{};
    if (config != null) updates['config'] = config;
    if (schedule != null) updates['schedule'] = schedule;
    if (isActive != null) updates['is_active'] = isActive;

    if (updates.isNotEmpty) {
      await _client.from('workflows').update(updates).eq('id', workflowId);
    }
  }

  /// Delete workflow
  Future<void> deleteWorkflow(String workflowId) async {
    await _client.from('workflows').delete().eq('id', workflowId);
  }

  /// Execute workflow manually
  Future<WorkflowRun> executeWorkflow(String workflowId) async {
    // Get workflow
    final workflowData = await _client
        .from('workflows')
        .select()
        .eq('id', workflowId)
        .single();

    final orgId = workflowData['organization_id'];

    // Check billing
    final orgService = _ref.read(organizationServiceProvider);
    final canExecute = await orgService.canExecuteWorkflows(orgId);

    if (!canExecute) {
      // Create failed run
      final runData = await _client.from('workflow_runs').insert({
        'workflow_id': workflowId,
        'status': 'failed',
        'started_at': DateTime.now().toIso8601String(),
        'completed_at': DateTime.now().toIso8601String(),
        'error_message': 'Billing not active. Please upgrade to Pro or Business plan.',
      }).select().single();

      return WorkflowRun(
        id: runData['id'],
        workflowId: workflowId,
        status: 'failed',
        errorMessage: 'Billing not active',
      );
    }

    // Create pending run
    final runData = await _client.from('workflow_runs').insert({
      'workflow_id': workflowId,
      'status': 'pending',
      'started_at': DateTime.now().toIso8601String(),
    }).select().single();

    // Trigger Edge Function for execution
    await _triggerExecution(runData['id']);

    return WorkflowRun(
      id: runData['id'],
      workflowId: workflowId,
      status: 'pending',
    );
  }

  Future<void> _triggerExecution(String runId) async {
    try {
      await _client.functions.invoke(
        'execute-workflow',
        body: {'run_id': runId},
      );
    } catch (e) {
      // Log error but don't fail - Edge Function will handle
      await _logError(runId, 'Failed to trigger execution: $e');
    }
  }

  Future<void> _logError(String runId, String message) async {
    await _client.from('workflow_logs').insert({
      'run_id': runId,
      'level': 'error',
      'message': message,
    });
  }

  /// Get workflow runs
  Future<List<WorkflowRun>> getWorkflowRuns(String workflowId) async {
    final data = await _client
        .from('workflow_runs')
        .select()
        .eq('workflow_id', workflowId)
        .order('started_at', ascending: false)
        .limit(50);

    return data.map<WorkflowRun>((json) => WorkflowRun(
      id: json['id'],
      workflowId: json['workflow_id'],
      status: json['status'] ?? 'pending',
      startedAt: json['started_at'] != null ? DateTime.parse(json['started_at']) : null,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at']) : null,
      attemptCount: json['attempt_count'] ?? 1,
      errorMessage: json['error_message'],
    )).toList();
  }

  /// Get logs for a run
  Future<List<WorkflowLog>> getRunLogs(String runId) async {
    final data = await _client
        .from('workflow_logs')
        .select()
        .eq('run_id', runId)
        .order('created_at', ascending: true);

    return data.map<WorkflowLog>((json) => WorkflowLog(
      id: json['id'],
      runId: json['run_id'],
      stepId: json['step_id'],
      level: json['level'] ?? 'info',
      message: json['message'],
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    )).toList();
  }

  /// Get available templates for organization mode
  List<WorkflowTemplate> getAvailableTemplates(String mode) {
    if (mode == AppConstants.modeAdvanced) {
      return WorkflowTemplates.forAdvancedMode();
    }
    return WorkflowTemplates.forSimpleMode();
  }
}
