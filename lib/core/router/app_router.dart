import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/dashboard/home_screen.dart';
import '../../screens/dashboard/settings_screen.dart';
import '../../screens/workflows/workflow_list_screen.dart';
import '../../screens/workflows/workflow_config_screen.dart';
import '../../screens/workflows/workflow_runs_screen.dart';
import '../../screens/integrations/integrations_screen.dart';
import '../../screens/billing/billing_screen.dart';
import '../../screens/shell/app_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final session = Supabase.instance.client.auth.currentSession;
      final isLoggedIn = session != null;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!isLoggedIn && !isAuthRoute) {
        return '/login';
      }
      if (isLoggedIn && isAuthRoute) {
        return '/';
      }
      return null;
    },
    routes: [
      // Auth Routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Main App Shell
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/workflows',
            name: 'workflows',
            builder: (context, state) => const WorkflowListScreen(),
            routes: [
              GoRoute(
                path: 'configure/:templateId',
                name: 'workflow-config',
                builder: (context, state) => WorkflowConfigScreen(
                  templateId: state.pathParameters['templateId']!,
                ),
              ),
              GoRoute(
                path: 'runs/:workflowId',
                name: 'workflow-runs',
                builder: (context, state) => WorkflowRunsScreen(
                  workflowId: state.pathParameters['workflowId']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/integrations',
            name: 'integrations',
            builder: (context, state) => const IntegrationsScreen(),
          ),
          GoRoute(
            path: '/billing',
            name: 'billing',
            builder: (context, state) => const BillingScreen(),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
});
