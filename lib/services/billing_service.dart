import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/models/billing.dart';

final billingServiceProvider = Provider<BillingService>((ref) {
  return BillingService(Supabase.instance.client);
});

final billingHistoryProvider = FutureProvider.family<List<Billing>, String>((ref, orgId) async {
  final service = ref.watch(billingServiceProvider);
  return service.getBillingHistory(orgId);
});

final activeBillingProvider = FutureProvider.family<Billing?, String>((ref, orgId) async {
  final service = ref.watch(billingServiceProvider);
  return service.getActiveBilling(orgId);
});

class BillingService {
  final SupabaseClient _client;

  BillingService(this._client);

  /// Get billing history for organization
  Future<List<Billing>> getBillingHistory(String orgId) async {
    final data = await _client
        .from('billing')
        .select()
        .eq('organization_id', orgId)
        .order('created_at', ascending: false);

    return data.map<Billing>((json) => Billing(
      id: json['id'],
      organizationId: json['organization_id'],
      plan: json['plan'],
      amountInr: json['amount_inr'],
      status: json['status'] ?? 'pending',
      paymentDate: json['payment_date'] != null ? DateTime.parse(json['payment_date']) : null,
      validUntil: json['valid_until'] != null ? DateTime.parse(json['valid_until']) : null,
    )).toList();
  }

  /// Get active billing
  Future<Billing?> getActiveBilling(String orgId) async {
    final data = await _client
        .from('billing')
        .select()
        .eq('organization_id', orgId)
        .eq('status', 'paid')
        .gte('valid_until', DateTime.now().toIso8601String())
        .order('valid_until', ascending: false)
        .limit(1)
        .maybeSingle();

    if (data != null) {
      return Billing(
        id: data['id'],
        organizationId: data['organization_id'],
        plan: data['plan'],
        amountInr: data['amount_inr'],
        status: data['status'],
        paymentDate: data['payment_date'] != null ? DateTime.parse(data['payment_date']) : null,
        validUntil: data['valid_until'] != null ? DateTime.parse(data['valid_until']) : null,
      );
    }
    return null;
  }

  /// Create billing record (called after payment)
  Future<Billing> createBilling({
    required String orgId,
    required String plan,
    required int amountInr,
  }) async {
    final validUntil = DateTime.now().add(const Duration(days: 30));

    final data = await _client.from('billing').insert({
      'organization_id': orgId,
      'plan': plan,
      'amount_inr': amountInr,
      'status': 'pending',
      'valid_until': validUntil.toIso8601String(),
    }).select().single();

    // Update organization plan
    await _client.from('organizations').update({
      'billing_plan': plan,
      'billing_status': 'pending',
    }).eq('id', orgId);

    return Billing(
      id: data['id'],
      organizationId: orgId,
      plan: plan,
      amountInr: amountInr,
      status: 'pending',
      validUntil: validUntil,
    );
  }

  /// Mark billing as paid (called by admin or webhook)
  Future<void> markAsPaid(String billingId) async {
    final data = await _client
        .from('billing')
        .update({
          'status': 'paid',
          'payment_date': DateTime.now().toIso8601String(),
        })
        .eq('id', billingId)
        .select()
        .single();

    // Update organization status
    await _client.from('organizations').update({
      'billing_status': 'active',
    }).eq('id', data['organization_id']);
  }

  /// Get plan pricing
  static Map<String, int> get planPricing => {
    'free': 0,
    'pro': 1500,
    'business': 3000,
  };

  /// Get plan features
  static Map<String, List<String>> get planFeatures => {
    'free': [
      'View all workflow templates',
      'Demo mode only',
      'No execution',
    ],
    'pro': [
      '5 active workflows',
      'WhatsApp + Email integrations',
      'Basic reports',
      'Email support',
    ],
    'business': [
      'Unlimited workflows',
      'All integrations',
      'PDF MIS reports',
      'Priority support',
      'Advanced analytics',
    ],
  };
}
