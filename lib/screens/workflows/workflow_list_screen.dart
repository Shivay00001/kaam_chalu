import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/workflow_templates.dart';
import '../../data/models/organization.dart';
import '../../services/organization_service.dart';
import '../../services/workflow_service.dart';

class WorkflowListScreen extends ConsumerWidget {
  const WorkflowListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orgAsync = ref.watch(currentOrganizationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workflows'),
      ),
      body: orgAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (org) {
          if (org == null) {
            return const Center(child: Text('No organization found'));
          }

          final workflowsAsync = ref.watch(workflowsProvider(org.id));
          final templates = ref.read(workflowServiceProvider).getAvailableTemplates(org.mode);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Your Active Workflows
                Text(
                  'Your Active Workflows',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'आपके चालू Workflows',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 16),

                workflowsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Text('Error loading workflows: $error'),
                  data: (workflows) {
                    if (workflows.isEmpty) {
                      return _buildEmptyState(context);
                    }

                    return Column(
                      children: workflows.map((workflow) {
                        final template = WorkflowTemplates.getById(workflow.templateId);
                        return _WorkflowCard(
                          workflow: workflow,
                          template: template,
                          onTap: () => context.go('/workflows/runs/${workflow.id}'),
                        );
                      }).toList(),
                    );
                  },
                ),

                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 24),

                // Available Templates
                Text(
                  'Available Workflow Templates',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  org.isSimpleMode
                      ? 'Simple mode में ${templates.length} workflows available'
                      : 'All ${templates.length} workflows available',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 16),

                ...templates.map((template) => _TemplateCard(
                      template: template,
                      isSimpleMode: org.isSimpleMode,
                      onSetup: () => context.go('/workflows/configure/${template.id}'),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.play_circle_outline,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No workflows set up yet',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Choose a template below to get started',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkflowCard extends StatelessWidget {
  final dynamic workflow;
  final WorkflowTemplate? template;
  final VoidCallback onTap;

  const _WorkflowCard({
    required this.workflow,
    required this.template,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  template?.icon ?? '⚙️',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workflow.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: workflow.isActive
                                ? const Color(0xFFD1FAE5)
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            workflow.isActive ? 'Active' : 'Paused',
                            style: TextStyle(
                              fontSize: 12,
                              color: workflow.isActive
                                  ? const Color(0xFF059669)
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                        if (workflow.schedule != null) ...[
                          const SizedBox(width: 8),
                          Icon(Icons.schedule, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            workflow.schedule!,
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final WorkflowTemplate template;
  final bool isSimpleMode;
  final VoidCallback onSetup;

  const _TemplateCard({
    required this.template,
    required this.isSimpleMode,
    required this.onSetup,
  });

  @override
  Widget build(BuildContext context) {
    final lang = isSimpleMode ? 'hi' : 'en';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  template.icon,
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        template.name(lang),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        template.description(lang),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // Required integrations
                ...template.requiredIntegrations.map((integration) => Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getIntegrationLabel(integration),
                        style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                      ),
                    )),
                const Spacer(),
                ElevatedButton(
                  onPressed: onSetup,
                  child: Text(isSimpleMode ? 'Set Up करें' : 'Set Up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getIntegrationLabel(String integration) {
    switch (integration) {
      case 'whatsapp':
        return 'WhatsApp';
      case 'email':
        return 'Email';
      case 'google_sheets':
        return 'Sheets';
      default:
        return integration;
    }
  }
}
