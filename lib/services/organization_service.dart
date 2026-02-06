import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/models/organization.dart';
import 'auth_service.dart';

final organizationServiceProvider = Provider<OrganizationService>((ref) {
  return OrganizationService(Supabase.instance.client);
});

final currentOrganizationProvider = FutureProvider<Organization?>((ref) async {
  final authService = ref.watch(authServiceProvider);
  final orgData = await authService.getCurrentOrganization();
  if (orgData != null) {
    return Organization(
      id: orgData['id'],
      name: orgData['name'],
      slug: orgData['slug'],
      mode: orgData['mode'] ?? 'simple',
      billingPlan: orgData['billing_plan'] ?? 'free',
      billingStatus: orgData['billing_status'] ?? 'active',
    );
  }
  return null;
});

class OrganizationService {
  final SupabaseClient _client;

  OrganizationService(this._client);

  /// Get organization by ID
  Future<Organization?> getOrganization(String id) async {
    final data = await _client
        .from('organizations')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (data != null) {
      return Organization(
        id: data['id'],
        name: data['name'],
        slug: data['slug'],
        mode: data['mode'] ?? 'simple',
        billingPlan: data['billing_plan'] ?? 'free',
        billingStatus: data['billing_status'] ?? 'active',
      );
    }
    return null;
  }

  /// Update organization mode (simple/advanced)
  Future<void> updateMode(String orgId, String mode) async {
    await _client
        .from('organizations')
        .update({'mode': mode})
        .eq('id', orgId);
  }

  /// Check if organization can execute workflows
  Future<bool> canExecuteWorkflows(String orgId) async {
    final org = await getOrganization(orgId);
    if (org == null) return false;

    // Free plan cannot execute
    if (org.isFreePlan) return false;

    // Check billing status
    if (org.billingStatus != 'active') return false;

    // Check if billing is valid
    final billing = await _client
        .from('billing')
        .select()
        .eq('organization_id', orgId)
        .eq('status', 'paid')
        .gte('valid_until', DateTime.now().toIso8601String())
        .maybeSingle();

    return billing != null;
  }

  /// Get organization members
  Future<List<Map<String, dynamic>>> getMembers(String orgId) async {
    final data = await _client
        .from('members')
        .select('*, users(*)')
        .eq('organization_id', orgId);

    return List<Map<String, dynamic>>.from(data);
  }

  /// Invite member
  Future<void> inviteMember(String orgId, String email, String role) async {
    // In real implementation, send invite email
    // For now, just create a placeholder
    throw UnimplementedError('Member invitation not yet implemented');
  }
}
