import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/workflow.dart';
import '../../services/workflow_service.dart';
import '../../widgets/common/kaam_button.dart';

class WorkflowRunsScreen extends ConsumerWidget {
  final String workflowId;

  const WorkflowRunsScreen({super.key, required this.workflowId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final runsAsync = ref.watch(workflowRunsProvider(workflowId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workflow Runs'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/workflows'),
        ),
        actions: [
          // Manual Run Button
          IconButton(
            icon: const Icon(Icons.play_arrow),
            tooltip: 'Run Now',
            onPressed: () => _triggerManualRun(context, ref),
          ),
        ],
      ),
      body: runsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (runs) {
          if (runs.isEmpty) {
            return _buildEmptyState(context, ref);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: runs.length,
            itemBuilder: (context, index) {
              final run = runs[index];
              return _RunCard(run: run, onViewLogs: () => _showLogs(context, ref, run.id));
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No runs yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Run this workflow manually or wait for scheduled execution',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            KaamButton(
              onPressed: () => _triggerManualRun(context, ref),
              labelEn: 'Run Now',
              labelHi: 'अभी Run करें',
              icon: Icons.play_arrow,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _triggerManualRun(BuildContext context, WidgetRef ref) async {
    try {
      final workflowService = ref.read(workflowServiceProvider);
      final run = await workflowService.executeWorkflow(workflowId);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              run.isFailed
                  ? 'Workflow failed: ${run.errorMessage}'
                  : 'Workflow started! ✅',
            ),
            backgroundColor: run.isFailed ? Colors.red : const Color(0xFF10B981),
          ),
        );
        // Refresh runs
        ref.invalidate(workflowRunsProvider(workflowId));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to run workflow: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showLogs(BuildContext context, WidgetRef ref, String runId) async {
    final workflowService = ref.read(workflowServiceProvider);
    final logs = await workflowService.getRunLogs(runId);

    if (context.mounted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) => Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Text(
                      'Execution Logs',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: logs.isEmpty
                    ? const Center(child: Text('No logs available'))
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: logs.length,
                        itemBuilder: (context, index) {
                          final log = logs[index];
                          return ListTile(
                            leading: Icon(
                              log.level == 'error'
                                  ? Icons.error
                                  : log.level == 'warn'
                                      ? Icons.warning
                                      : Icons.info_outline,
                              color: log.level == 'error'
                                  ? Colors.red
                                  : log.level == 'warn'
                                      ? Colors.orange
                                      : Colors.blue,
                            ),
                            title: Text(log.message),
                            subtitle: log.createdAt != null
                                ? Text(DateFormat('HH:mm:ss').format(log.createdAt!))
                                : null,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class _RunCard extends StatelessWidget {
  final dynamic run;
  final VoidCallback onViewLogs;

  const _RunCard({required this.run, required this.onViewLogs});

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(run.status);
    final statusIcon = _getStatusIcon(run.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(statusIcon, color: statusColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getStatusLabel(run.status),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                      if (run.startedAt != null)
                        Text(
                          DateFormat('MMM d, y HH:mm').format(run.startedAt!),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
                if (run.attemptCount > 1)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Attempt ${run.attemptCount}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ),
              ],
            ),
            if (run.errorMessage != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade700, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        run.errorMessage!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onViewLogs,
                  icon: const Icon(Icons.list_alt, size: 16),
                  label: const Text('View Logs'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'success':
        return const Color(0xFF10B981);
      case 'failed':
        return const Color(0xFFEF4444);
      case 'running':
        return const Color(0xFF2563EB);
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'success':
        return Icons.check_circle;
      case 'failed':
        return Icons.cancel;
      case 'running':
        return Icons.sync;
      default:
        return Icons.schedule;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'success':
        return 'Kaam ho gaya ✅';
      case 'failed':
        return 'Failed ❌';
      case 'running':
        return 'Running...';
      default:
        return 'Pending';
    }
  }
}
