import 'package:call_filter/app/router/app_shell.dart';
import 'package:call_filter/features/call_history/presentation/call_history_screen.dart';
import 'package:call_filter/features/contacts/presentation/whitelist_screen.dart';
import 'package:call_filter/features/home/presentation/home_screen.dart';
import 'package:call_filter/features/rules/presentation/rule_editor_screen.dart';
import 'package:call_filter/features/rules/presentation/rules_screen.dart';
import 'package:call_filter/features/settings/presentation/settings_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _rulesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'rules');
final _whitelistNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'whitelist',
);
final _historyNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'history');
final _settingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'settings');

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(
            location: state.uri.path,
            navigationShell: navigationShell,
            navigatorKeys: [
              _homeNavigatorKey,
              _rulesNavigatorKey,
              _whitelistNavigatorKey,
              _historyNavigatorKey,
              _settingsNavigatorKey,
            ],
          );
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _rulesNavigatorKey,
            routes: [
              GoRoute(
                path: '/rules',
                builder: (context, state) => const RulesScreen(),
                routes: [
                  GoRoute(
                    path: 'new',
                    builder: (context, state) => const RuleEditorScreen(),
                  ),
                  GoRoute(
                    path: ':ruleId/edit',
                    builder: (context, state) => RuleEditorScreen(
                      ruleId: state.pathParameters['ruleId'],
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _whitelistNavigatorKey,
            routes: [
              GoRoute(
                path: '/whitelist',
                builder: (context, state) => const WhitelistScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _historyNavigatorKey,
            routes: [
              GoRoute(
                path: '/history',
                builder: (context, state) => const CallHistoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _settingsNavigatorKey,
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
