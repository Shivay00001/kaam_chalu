import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth_service.dart';
import '../../services/organization_service.dart';

/// App shell with navigation for authenticated users
class AppShell extends ConsumerWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orgAsync = ref.watch(currentOrganizationProvider);
    final currentPath = GoRouterState.of(context).matchedLocation;

    return Scaffold(
      body: Row(
        children: [
          // Side Navigation (for web/desktop)
          if (MediaQuery.of(context).size.width > 768)
            NavigationRail(
              selectedIndex: _getSelectedIndex(currentPath),
              onDestinationSelected: (index) => _onNavTap(context, index),
              labelType: NavigationRailLabelType.all,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: Color(0xFF2563EB),
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    orgAsync.when(
                      data: (org) => Text(
                        org?.name ?? 'KaamChalu',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () => _logout(context, ref),
                      tooltip: 'Logout',
                    ),
                  ),
                ),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.play_circle_outline),
                  selectedIcon: Icon(Icons.play_circle),
                  label: Text('Workflows'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.link_outlined),
                  selectedIcon: Icon(Icons.link),
                  label: Text('Connect'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.payments_outlined),
                  selectedIcon: Icon(Icons.payments),
                  label: Text('Billing'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: Text('Settings'),
                ),
              ],
            ),

          // Main content
          Expanded(child: child),
        ],
      ),

      // Bottom Navigation (for mobile)
      bottomNavigationBar: MediaQuery.of(context).size.width <= 768
          ? NavigationBar(
              selectedIndex: _getSelectedIndex(currentPath),
              onDestinationSelected: (index) => _onNavTap(context, index),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.play_circle_outline),
                  selectedIcon: Icon(Icons.play_circle),
                  label: 'Workflows',
                ),
                NavigationDestination(
                  icon: Icon(Icons.link_outlined),
                  selectedIcon: Icon(Icons.link),
                  label: 'Connect',
                ),
                NavigationDestination(
                  icon: Icon(Icons.payments_outlined),
                  selectedIcon: Icon(Icons.payments),
                  label: 'Billing',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            )
          : null,
    );
  }

  int _getSelectedIndex(String path) {
    if (path == '/') return 0;
    if (path.startsWith('/workflows')) return 1;
    if (path.startsWith('/integrations')) return 2;
    if (path.startsWith('/billing')) return 3;
    if (path.startsWith('/settings')) return 4;
    return 0;
  }

  void _onNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/workflows');
        break;
      case 2:
        context.go('/integrations');
        break;
      case 3:
        context.go('/billing');
        break;
      case 4:
        context.go('/settings');
        break;
    }
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final authService = ref.read(authServiceProvider);
    await authService.signOut();
    if (context.mounted) {
      context.go('/login');
    }
  }
}
