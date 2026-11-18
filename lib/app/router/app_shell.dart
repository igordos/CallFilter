import 'package:call_filter/app/theme/app_colors.dart';
import 'package:call_filter/app/theme/app_theme_context.dart';
import 'package:call_filter/l10n/gen/app_localizations.dart';
import 'package:call_filter/shared/widgets/app_bottom_navigation_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    required this.location,
    required this.navigationShell,
    required this.navigatorKeys,
    super.key,
  });

  final String location;
  final StatefulNavigationShell navigationShell;
  final List<GlobalKey<NavigatorState>> navigatorKeys;

  static const List<String> _paths = [
    '/',
    '/rules',
    '/whitelist',
    '/history',
    '/settings',
  ];

  int get _selectedIndex => navigationShell.currentIndex;

  bool get _isBranchRoot => location == _paths[_selectedIndex];

  bool get _isHomeRoot => _selectedIndex == 0 && _isBranchRoot;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final destinations = [
      AppNavigationDestination(
        key: const ValueKey('nav_home'),
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        label: l10n.navHome,
      ),
      AppNavigationDestination(
        key: const ValueKey('nav_rules'),
        icon: Icons.filter_alt_outlined,
        selectedIcon: Icons.filter_alt,
        label: l10n.navRules,
      ),
      AppNavigationDestination(
        key: const ValueKey('nav_whitelist'),
        icon: Icons.contacts_outlined,
        selectedIcon: Icons.contacts,
        label: l10n.navWhitelist,
      ),
      AppNavigationDestination(
        key: const ValueKey('nav_history'),
        icon: Icons.history_outlined,
        selectedIcon: Icons.history,
        label: l10n.navHistory,
      ),
      AppNavigationDestination(
        key: const ValueKey('nav_settings'),
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings,
        label: l10n.navSettings,
      ),
    ];

    final branchNavigator = navigatorKeys[_selectedIndex].currentState;
    final canPopBranch = !_isBranchRoot;
    final canLeaveApp = _isHomeRoot || canPopBranch;

    return PopScope(
      canPop: canLeaveApp,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        if (canPopBranch) {
          branchNavigator?.pop();
          return;
        }
        if (!_isHomeRoot) {
          navigationShell.goBranch(0);
        }
      },
      child: _buildShell(context, colors, destinations),
    );
  }

  Widget _buildShell(
    BuildContext context,
    AppColors colors,
    List<AppNavigationDestination> destinations,
  ) {
    if (!_isBranchRoot) {
      return Scaffold(
        backgroundColor: colors.background,
        body: navigationShell,
      );
    }

    final width = MediaQuery.sizeOf(context).width;
    if (width >= 600) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              backgroundColor: colors.surfaceContainerLow,
              selectedIndex: _selectedIndex,
              onDestinationSelected: _selectBranch,
              labelType: NavigationRailLabelType.none,
              destinations: [
                for (final destination in destinations)
                  NavigationRailDestination(
                    icon: KeyedSubtree(
                      key: destination.key,
                      child: Tooltip(
                        message: destination.label,
                        excludeFromSemantics: true,
                        child: Icon(destination.icon),
                      ),
                    ),
                    selectedIcon: Tooltip(
                      message: destination.label,
                      excludeFromSemantics: true,
                      child: Icon(destination.selectedIcon),
                    ),
                    label: Text(destination.label),
                  ),
              ],
            ),
            VerticalDivider(width: 1, color: colors.borderSubtle),
            Expanded(child: navigationShell),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: colors.background,
      body: navigationShell,
      bottomNavigationBar: AppBottomNavigationBar(
        showLabels: false,
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectBranch,
        destinations: destinations,
      ),
    );
  }

  void _selectBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
