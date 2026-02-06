import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/workflow_templates.dart';
import '../../data/models/organization.dart';
import '../../services/organization_service.dart';
import '../../services/workflow_service.dart';
import '../../widgets/common/kaam_text_field.dart';
import '../../widgets/common/kaam_button.dart';

class WorkflowConfigScreen extends ConsumerStatefulWidget {
  final String templateId;

  const WorkflowConfigScreen({super.key, required this.templateId});

  @override
  ConsumerState<WorkflowConfigScreen> createState() => _WorkflowConfigScreenState();
}

class _WorkflowConfigScreenState extends ConsumerState<WorkflowConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, dynamic> _values = {};
  bool _isLoading = false;
  String? _errorMessage;

  late WorkflowTemplate? template;

  @override
  void initState() {
    super.initState();
    template = WorkflowTemplates.getById(widget.templateId);

    if (template != null) {
      for (final field in template!.configFields) {
        if (field.type == 'toggle') {
          _values[field.key] = field.defaultValue ?? false;
        } else if (field.type == 'select') {
          _values[field.key] = field.defaultValue ?? field.options?.first;
        } else {
          _controllers[field.key] = TextEditingController(
            text: field.defaultValue?.toString() ?? '',
          );
        }
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveWorkflow() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final org = await ref.read(currentOrganizationProvider.future);
      if (org == null) throw Exception('No organization found');

      // Build config from controllers and values
      final config = <String, dynamic>{};
      for (final field in template!.configFields) {
        if (field.type == 'toggle' || field.type == 'select') {
          config[field.key] = _values[field.key];
        } else {
          config[field.key] = _controllers[field.key]?.text;
        }
      }

      // Create workflow
      final workflowService = ref.read(workflowServiceProvider);
      await workflowService.createWorkflow(
        orgId: org.id,
        templateId: widget.templateId,
        name: template!.nameEn,
        config: config,
        schedule: null, // Can be configured later
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${template!.nameEn} workflow created! ✅'),
            backgroundColor: const Color(0xFF10B981),
          ),
        );
        context.go('/workflows');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to create workflow: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final orgAsync = ref.watch(currentOrganizationProvider);

    if (template == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Not Found')),
        body: const Center(child: Text('Workflow template not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Setup: ${template!.nameEn}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/workflows'),
        ),
      ),
      body: orgAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (org) {
          if (org == null) {
            return const Center(child: Text('No organization found'));
          }

          final isSimpleMode = org.isSimpleMode;
          final lang = isSimpleMode ? 'hi' : 'en';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Text(template!.icon, style: const TextStyle(fontSize: 48)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              template!.name(lang),
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              template!.description(lang),
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Error message
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.red.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Required Integrations Check
                  Card(
                    color: const Color(0xFFFEF3C7),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: Color(0xFFD97706)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Required Connections',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFD97706),
                                  ),
                                ),
                                Text(
                                  template!.requiredIntegrations.join(', '),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: const Color(0xFFD97706).withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.go('/integrations'),
                            child: const Text('Connect →'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Configuration Fields
                  Text(
                    isSimpleMode ? 'Settings / सेटिंग्स' : 'Configuration',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),

                  ...template!.configFields.map((field) => _buildField(field, lang)),

                  const SizedBox(height: 32),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: KaamButton(
                      onPressed: _isLoading ? null : _saveWorkflow,
                      isLoading: _isLoading,
                      labelEn: 'Save & Activate Workflow',
                      labelHi: 'Workflow Start करें',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildField(ConfigField field, String lang) {
    switch (field.type) {
      case 'toggle':
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SwitchListTile(
            value: _values[field.key] ?? false,
            onChanged: (value) {
              setState(() {
                _values[field.key] = value;
              });
            },
            title: Text(field.label(lang)),
            contentPadding: EdgeInsets.zero,
          ),
        );

      case 'select':
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(field.label(lang)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _values[field.key],
                items: field.options?.map((option) => DropdownMenuItem(
                  value: option,
                  child: Text(option),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    _values[field.key] = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        );

      case 'textarea':
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: KaamTextField(
            controller: _controllers[field.key]!,
            labelEn: field.labelEn,
            labelHi: field.labelHi,
            maxLines: 4,
            hint: field.hint,
            validator: field.required
                ? (value) => value?.isEmpty == true ? 'Required' : null
                : null,
          ),
        );

      case 'number':
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: KaamTextField(
            controller: _controllers[field.key]!,
            labelEn: field.labelEn,
            labelHi: field.labelHi,
            keyboardType: TextInputType.number,
            validator: field.required
                ? (value) => value?.isEmpty == true ? 'Required' : null
                : null,
          ),
        );

      default:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: KaamTextField(
            controller: _controllers[field.key]!,
            labelEn: field.labelEn,
            labelHi: field.labelHi,
            keyboardType: _getKeyboardType(field.type),
            validator: field.required
                ? (value) => value?.isEmpty == true ? 'Required' : null
                : null,
          ),
        );
    }
  }

  TextInputType? _getKeyboardType(String type) {
    switch (type) {
      case 'email':
        return TextInputType.emailAddress;
      case 'phone':
        return TextInputType.phone;
      case 'url':
        return TextInputType.url;
      default:
        return TextInputType.text;
    }
  }
}
