import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth_service.dart';
import '../../services/organization_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orgAsync = ref.watch(currentOrganizationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
                // Mode Toggle
                Text(
                  'Display Mode',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Choose based on your preference',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),

                Card(
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        value: 'simple',
                        groupValue: org.mode,
                        onChanged: (value) => _updateMode(ref, org.id, value!),
                        title: const Text('Simple Mode (Noida Style)'),
                        subtitle: const Text(
                          'Hindi + English labels, no charts\n"Kaam ho gaya" indicators',
                        ),
                        secondary: const Text('🏪', style: TextStyle(fontSize: 28)),
                      ),
                      const Divider(height: 1),
                      RadioListTile<String>(
                        value: 'advanced',
                        groupValue: org.mode,
                        onChanged: (value) => _updateMode(ref, org.id, value!),
                        title: const Text('Advanced Mode (Mumbai Style)'),
                        subtitle: const Text(
                          'MIS reports, PDFs, charts\nPerformance comparisons',
                        ),
                        secondary: const Text('📊', style: TextStyle(fontSize: 28)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Language
                Text(
                  'Language',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Text('🇮🇳', style: TextStyle(fontSize: 24)),
                        title: const Text('Hindi + English'),
                        subtitle: const Text('Default'),
                        trailing: const Icon(Icons.check, color: Color(0xFF10B981)),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Organization Info
                Text(
                  'Organization',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InfoRow(label: 'Name', value: org.name),
                        const Divider(),
                        _InfoRow(label: 'Plan', value: org.billingPlan.toUpperCase()),
                        const Divider(),
                        _InfoRow(label: 'Status', value: org.billingStatus),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Support
                Text(
                  'Support',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.email_outlined),
                        title: const Text('Email Support'),
                        subtitle: const Text('support@kaamchalu.com'),
                        onTap: () {},
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.chat_outlined),
                        title: const Text('WhatsApp Support'),
                        subtitle: const Text('+91-9876543210'),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Version
                Center(
                  child: Text(
                    'KaamChalu v1.0.0',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _updateMode(WidgetRef ref, String orgId, String mode) async {
    final orgService = ref.read(organizationServiceProvider);
    await orgService.updateMode(orgId, mode);
    ref.invalidate(currentOrganizationProvider);
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
