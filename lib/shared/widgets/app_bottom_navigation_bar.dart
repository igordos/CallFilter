import 'package:call_filter/app/theme/app_spacing.dart';
import 'package:call_filter/app/theme/app_theme_context.dart';
import 'package:material_ui/material_ui.dart';

class AppNavigationDestination {
  const AppNavigationDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.key,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Key? key;
}

/// Material 3-styled bottom navigation with full labels.
///
/// Flutter's stock NavigationBar wraps a long single label such as the Russian
/// "Белый список" onto two lines while other labels stay on one. This small
/// bar keeps every label on one line, scales only the label that needs it and
/// exposes a single selected semantic node per destination.
class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.showLabels = true,
    super.key,
  });

  final List<AppNavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : AppMotion.normal;
    return DecoratedBox(
      decoration: BoxDecoration(color: colors.surfaceContainer),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: showLabels
              ? AppSizes.navBarHeight
              : AppSizes.navBarIconOnlyHeight,
          child: Row(
            children: [
              for (var index = 0; index < destinations.length; index++)
                Expanded(
                  child: _DestinationItem(
                    destination: destinations[index],
                    selected: index == selectedIndex,
                    duration: duration,
                    showLabel: showLabels,
                    onTap: () => onDestinationSelected(index),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DestinationItem extends StatelessWidget {
  const _DestinationItem({
    required this.destination,
    required this.selected,
    required this.duration,
    required this.showLabel,
    required this.onTap,
  });

  final AppNavigationDestination destination;
  final bool selected;
  final Duration duration;
  final bool showLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final labelColor = selected ? colors.onSurface : colors.onSurfaceVariant;
    return Semantics(
      key: destination.key,
      button: true,
      selected: selected,
      label: destination.label,
      onTap: onTap,
      child: ExcludeSemantics(
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.large,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.sm,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: duration,
                  curve: AppMotion.state,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? colors.secondaryContainer
                        : Colors.transparent,
                    borderRadius: AppRadius.full,
                  ),
                  child: Tooltip(
                    message: destination.label,
                    excludeFromSemantics: true,
                    child: Icon(
                      selected ? destination.selectedIcon : destination.icon,
                      size: AppSizes.iconLarge,
                      color: selected
                          ? colors.onSecondaryContainer
                          : colors.onSurfaceVariant,
                    ),
                  ),
                ),
                if (showLabel) ...[
                  const SizedBox(height: AppSpacing.xs),
                  SizedBox(
                    height: 15,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        destination.label,
                        maxLines: 1,
                        softWrap: false,
                        style: context.labelMediumStyle.copyWith(
                          color: labelColor,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
