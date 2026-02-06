import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(Supabase.instance.client);
});

final currentUserProvider = StreamProvider<User?>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange.map((event) => event.session?.user);
});

class AuthService {
  final SupabaseClient _client;

  AuthService(this._client);

  User? get currentUser => _client.auth.currentUser;
  Session? get currentSession => _client.auth.currentSession;

  /// Sign in with email and password
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Sign up with email and create organization
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String businessName,
  }) async {
    // Create auth user
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'phone': phone,
        'business_name': businessName,
      },
    );

    if (response.user != null) {
      // Create organization and link user
      await _createOrganizationForUser(
        userId: response.user!.id,
        businessName: businessName,
        email: email,
        fullName: fullName,
        phone: phone,
      );
    }

    return response;
  }

  Future<void> _createOrganizationForUser({
    required String userId,
    required String businessName,
    required String email,
    required String fullName,
    required String phone,
  }) async {
    // Create organization
    final slug = businessName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');

    final orgResponse = await _client.from('organizations').insert({
      'name': businessName,
      'slug': '${slug}_${DateTime.now().millisecondsSinceEpoch}',
      'mode': 'simple',
      'billing_plan': 'free',
      'billing_status': 'active',
    }).select().single();

    final orgId = orgResponse['id'];

    // Create user profile
    await _client.from('users').insert({
      'id': userId,
      'email': email,
      'full_name': fullName,
      'phone': phone,
      'language': 'en',
    });

    // Create membership as owner
    await _client.from('members').insert({
      'organization_id': orgId,
      'user_id': userId,
      'role': 'owner',
    });
  }

  /// Sign out
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Check if user is logged in
  bool get isLoggedIn => currentUser != null;

  /// Get current organization for user
  Future<Map<String, dynamic>?> getCurrentOrganization() async {
    if (currentUser == null) return null;

    final membership = await _client
        .from('members')
        .select('organization_id, role, organizations(*)')
        .eq('user_id', currentUser!.id)
        .limit(1)
        .maybeSingle();

    if (membership != null) {
      return membership['organizations'] as Map<String, dynamic>;
    }
    return null;
  }
}
