import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/integration.dart';
import '../../services/organization_service.dart';
import '../../widgets/common/kaam_button.dart';
import '../../widgets/common/kaam_text_field.dart';

class IntegrationsScreen extends ConsumerWidget {
  const IntegrationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orgAsync = ref.watch(currentOrganizationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Integrations'),
      ),
      body: orgAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (org) {
          if (org == null) {
            return const Center(child: Text('No organization found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Connect Your Apps',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Apps जोड़ें - Workflows automatically काम करेंगे',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),

                // WhatsApp
                _IntegrationCard(
                  type: IntegrationType.whatsapp,
                  isConnected: false, // TODO: Check from DB
                  onConnect: () => _showConnectDialog(context, 'whatsapp'),
                ),

                // Email
                _IntegrationCard(
                  type: IntegrationType.email,
                  isConnected: false,
                  onConnect: () => _showConnectDialog(context, 'email'),
                ),

                // Google Sheets
                _IntegrationCard(
                  type: IntegrationType.googleSheets,
                  isConnected: false,
                  onConnect: () => _showConnectDialog(context, 'google_sheets'),
                ),

                const SizedBox(height: 32),

                // Info Card
                Card(
                  color: const Color(0xFFEFF6FF),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Color(0xFF2563EB)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Credentials are encrypted',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2563EB),
                                ),
                              ),
                              Text(
                                'Your API keys and tokens are encrypted at rest and never exposed to the frontend.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: const Color(0xFF2563EB).withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showConnectDialog(BuildContext context, String type) {
    final fields = IntegrationFields.fields[type] ?? [];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Connect ${_getTypeName(type)}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...fields.map((field) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: KaamTextField(
                      controller: TextEditingController(),
                      labelEn: field.label,
                      labelHi: field.labelHindi,
                      obscureText: field.type == FieldType.password,
                      maxLines: field.type == FieldType.textarea ? 4 : 1,
                      hint: field.hint,
                    ),
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Save integration
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${_getTypeName(type)} connected! ✅'),
                  backgroundColor: const Color(0xFF10B981),
                ),
              );
            },
            child: const Text('Connect'),
          ),
        ],
      ),
    );
  }

  String _getTypeName(String type) {
    switch (type) {
      case 'whatsapp':
        return 'WhatsApp Business';
      case 'email':
        return 'Email (SMTP)';
      case 'google_sheets':
        return 'Google Sheets';
      default:
        return type;
    }
  }
}

class _IntegrationCard extends StatelessWidget {
  final IntegrationType type;
  final bool isConnected;
  final VoidCallback onConnect;

  const _IntegrationCard({
    required this.type,
    required this.isConnected,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isConnected
                    ? const Color(0xFFD1FAE5)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getIcon(),
                color: isConnected
                    ? const Color(0xFF059669)
                    : Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    type.descriptionHindi,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (isConnected)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, size: 16, color: Color(0xFF059669)),
                    SizedBox(width: 4),
                    Text(
                      'Connected',
                      style: TextStyle(
                        color: Color(0xFF059669),
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )
            else
              ElevatedButton(
                onPressed: onConnect,
                child: const Text('Connect'),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (type) {
      case IntegrationType.whatsapp:
        return Icons.chat;
      case IntegrationType.email:
        return Icons.email;
      case IntegrationType.googleSheets:
        return Icons.table_chart;
    }
  }
}
