import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/organization_service.dart';
import '../../services/billing_service.dart';
import '../../widgets/common/kaam_button.dart';

class BillingScreen extends ConsumerWidget {
  const BillingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orgAsync = ref.watch(currentOrganizationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Billing & Plans'),
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
                // Current Plan
                Text(
                  'Current Plan',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                _CurrentPlanCard(org: org),

                const SizedBox(height: 32),

                // Available Plans
                Text(
                  'Available Plans',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Choose the best plan for your business',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),

                // Free Plan
                _PlanCard(
                  name: 'Free',
                  nameHi: 'Free (Demo)',
                  price: 0,
                  features: BillingService.planFeatures['free']!,
                  isCurrentPlan: org.billingPlan == 'free',
                  onSelect: null, // Already free
                ),

                // Pro Plan
                _PlanCard(
                  name: 'Pro',
                  nameHi: 'Pro',
                  price: 1500,
                  features: BillingService.planFeatures['pro']!,
                  isCurrentPlan: org.billingPlan == 'pro',
                  isRecommended: true,
                  onSelect: org.billingPlan == 'pro'
                      ? null
                      : () => _showPaymentDialog(context, ref, org.id, 'pro', 1500),
                ),

                // Business Plan
                _PlanCard(
                  name: 'Business',
                  nameHi: 'Business',
                  price: 3000,
                  features: BillingService.planFeatures['business']!,
                  isCurrentPlan: org.billingPlan == 'business',
                  onSelect: org.billingPlan == 'business'
                      ? null
                      : () => _showPaymentDialog(context, ref, org.id, 'business', 3000),
                ),

                const SizedBox(height: 32),

                // Payment Info
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
                                'Payment via UPI/Bank Transfer',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFD97706),
                                ),
                              ),
                              Text(
                                'After selecting a plan, you\'ll receive payment details. Your account will be activated within 24 hours of payment confirmation.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: const Color(0xFFD97706).withOpacity(0.8),
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

  void _showPaymentDialog(
    BuildContext context,
    WidgetRef ref,
    String orgId,
    String plan,
    int amount,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Upgrade to ${plan.toUpperCase()}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Amount: ₹$amount/month',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Payment Details:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('UPI: kaamchalu@upi'),
                  SizedBox(height: 4),
                  Text('Bank: HDFC Bank'),
                  Text('A/C: 50200012345678'),
                  Text('IFSC: HDFC0001234'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'After payment, send screenshot to:\nWhatsApp: +91-9876543210',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Create pending billing record
              final billingService = ref.read(billingServiceProvider);
              await billingService.createBilling(
                orgId: orgId,
                plan: plan,
                amountInr: amount,
              );

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Billing request created! Please complete payment and share screenshot.'),
                  backgroundColor: Color(0xFF2563EB),
                ),
              );
            },
            child: const Text('I\'ll Pay Now'),
          ),
        ],
      ),
    );
  }
}

class _CurrentPlanCard extends StatelessWidget {
  final dynamic org;

  const _CurrentPlanCard({required this.org});

  @override
  Widget build(BuildContext context) {
    final isFreePlan = org.billingPlan == 'free';

    return Card(
      color: isFreePlan ? const Color(0xFFFEF3C7) : const Color(0xFFD1FAE5),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isFreePlan ? Icons.free_breakfast : Icons.diamond,
                color: isFreePlan
                    ? const Color(0xFFD97706)
                    : const Color(0xFF059669),
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    org.billingPlan.toUpperCase(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isFreePlan
                          ? const Color(0xFFD97706)
                          : const Color(0xFF059669),
                    ),
                  ),
                  Text(
                    isFreePlan
                        ? 'Demo mode - Workflows won\'t execute'
                        : 'All features active ✅',
                    style: TextStyle(
                      color: isFreePlan
                          ? const Color(0xFFD97706).withOpacity(0.8)
                          : const Color(0xFF059669).withOpacity(0.8),
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
}

class _PlanCard extends StatelessWidget {
  final String name;
  final String nameHi;
  final int price;
  final List<String> features;
  final bool isCurrentPlan;
  final bool isRecommended;
  final VoidCallback? onSelect;

  const _PlanCard({
    required this.name,
    required this.nameHi,
    required this.price,
    required this.features,
    this.isCurrentPlan = false,
    this.isRecommended = false,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isRecommended
            ? const BorderSide(color: Color(0xFF2563EB), width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isRecommended) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'RECOMMENDED',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                if (isCurrentPlan) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'CURRENT',
                      style: TextStyle(
                        color: Color(0xFF059669),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: price == 0 ? 'Free' : '₹$price',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (price > 0)
                    TextSpan(
                      text: '/month',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 18,
                        color: price == 0 ? Colors.grey : const Color(0xFF10B981),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(feature)),
                    ],
                  ),
                )),
            if (!isCurrentPlan && onSelect != null) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: KaamButton(
                  onPressed: onSelect,
                  labelEn: 'Select $name',
                  labelHi: '$name चुनें',
                  isOutlined: price == 0,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
