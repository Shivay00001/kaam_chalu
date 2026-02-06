import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/organization.dart';
import '../../services/organization_service.dart';
import '../../services/workflow_service.dart';
import '../../services/billing_service.dart';
import '../../widgets/common/kaam_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orgAsync = ref.watch(currentOrganizationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          // Mode indicator
          orgAsync.when(
            data: (org) => org != null
                ? Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: org.isAdvancedMode
                          ? const Color(0xFF2563EB).withOpacity(0.1)
                          : const Color(0xFF10B981).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      org.isAdvancedMode ? 'Advanced' : 'Simple',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: org.isAdvancedMode
                            ? const Color(0xFF2563EB)
                            : const Color(0xFF10B981),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: orgAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (org) {
          if (org == null) {
            return const Center(child: Text('No organization found'));
          }

          return _buildDashboard(context, ref, org);
        },
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, WidgetRef ref, dynamic org) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          _buildWelcomeCard(context, org),
          const SizedBox(height: 24),

          // Billing Status
          _buildBillingCard(context, ref, org),
          const SizedBox(height: 24),

          // Quick Actions
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          _buildQuickActions(context),
          const SizedBox(height: 24),

          // Recent Runs
          Text(
            'Recent Activity',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          _buildRecentActivity(context, ref, org),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context, dynamic org) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Color(0xFF2563EB),
                size: 32,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to ${org.name}!',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    org.isSimpleMode
                        ? 'System banda ban gaya ✨'
                        : 'Lightweight MIS Automation Ready',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingCard(BuildContext context, WidgetRef ref, dynamic org) {
    return Card(
      color: org.isFreePlan
          ? const Color(0xFFFEF3C7)
          : const Color(0xFFD1FAE5),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              org.isFreePlan ? Icons.info_outline : Icons.check_circle,
              color: org.isFreePlan
                  ? const Color(0xFFD97706)
                  : const Color(0xFF059669),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    org.isFreePlan
                        ? 'You are on Free Plan (Demo Mode)'
                        : 'Plan: ${org.billingPlan.toUpperCase()}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: org.isFreePlan
                          ? const Color(0xFFD97706)
                          : const Color(0xFF059669),
                    ),
                  ),
                  if (org.isFreePlan)
                    Text(
                      'Upgrade to run workflows automatically',
                      style: TextStyle(
                        fontSize: 12,
                        color: org.isFreePlan
                            ? const Color(0xFFD97706).withOpacity(0.8)
                            : const Color(0xFF059669).withOpacity(0.8),
                      ),
                    ),
                ],
              ),
            ),
            if (org.isFreePlan)
              ElevatedButton(
                onPressed: () => context.go('/billing'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD97706),
                ),
                child: const Text('Upgrade'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _QuickActionCard(
          icon: Icons.add_circle_outline,
          label: 'New Workflow',
          labelHi: 'नया Workflow',
          onTap: () => context.go('/workflows'),
        ),
        _QuickActionCard(
          icon: Icons.link,
          label: 'Connect Apps',
          labelHi: 'Apps जोड़ें',
          onTap: () => context.go('/integrations'),
        ),
        _QuickActionCard(
          icon: Icons.history,
          label: 'View Runs',
          labelHi: 'Runs देखें',
          onTap: () => context.go('/workflows'),
        ),
        _QuickActionCard(
          icon: Icons.help_outline,
          label: 'Help',
          labelHi: 'मदद',
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Need Help?'),
                content: const Text(
                  'Contact us:\n\nEmail: support@kaamchalu.com\nWhatsApp: +91-9876543210',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentActivity(BuildContext context, WidgetRef ref, dynamic org) {
    // For now, show placeholder
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 12),
              Text(
                'No recent activity',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.go('/workflows'),
                child: const Text('Set up your first workflow →'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String labelHi;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.labelHi,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: const Color(0xFF2563EB)),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
