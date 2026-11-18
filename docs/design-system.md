# Design system

CallFilter uses a **Material 3 Expressive** design system with its own
“Cobalt Signal” identity. It is built on `material_ui` and the existing
`App*` components; it is not a second UI framework and it is not the default
Flutter Material palette.

The product feeling: calm, premium, friendly and trustworthy. Hierarchy comes
from tonal surfaces, expressive type and shape, not from heavy shadows or a
card around every row.

## Visual direction

- Cobalt is the primary action/protection accent; teal is the tertiary signal
  accent; warm containers carry success/warning/error status.
- Surfaces use the Material 3 tonal scale. Elevation is represented primarily
  by `surfaceContainerLow`, `surfaceContainer`, `surfaceContainerHigh` and
  `surfaceContainerHighest`, with fine outlines.
- Type is expressive: large dashboard numbers, confident titles, compact
  metadata. Not every text uses the same size or weight.
- Shapes are varied by role: 16 px controls, 24 px cards, 28 px dialogs/sheets,
  full pills for primary/destructive actions and status labels.
- Motion is short, intentional and respects Reduce Motion. No decorative bounce
  or looping animation.
- Lists stay compact. Cards group related content; they do not wrap individual
  call-history or rule rows.

## Color system

Tokens live in [`lib/app/theme/app_colors.dart`](../lib/app/theme/app_colors.dart)
as an `AppColors` `ThemeExtension`. The `ColorScheme` in
[`app_theme.dart`](../lib/app/theme/app_theme.dart) is built from the same roles.

### Light

| Role | Value |
| --- | --- |
| Background / surface | `#F8F9FF` |
| Surface container lowest / low | `#FFFFFF` / `#F2F3FA` |
| Surface container / high / highest | `#ECEEF5` / `#E6E8EF` / `#E0E2E9` |
| On surface / on surface variant | `#191C20` / `#44474F` |
| Outline / outline variant | `#74777F` / `#C4C6D0` |
| Primary / on primary | `#2956D9` / `#FFFFFF` |
| Primary container / on container | `#DCE1FF` / `#00174B` |
| Secondary / container | `#5A5D72` / `#DFE1F9` |
| Tertiary / container | `#00696E` / `#B0ECEE` |
| Error / container | `#BA1A1A` / `#FFDAD6` |
| Success / container | `#146C43` / `#C8F0D8` |
| Warning / container | `#8A5A00` / `#FFDEA6` |
| Info / container | `#315DAF` / `#D8E2FF` |

### Dark

| Role | Value |
| --- | --- |
| Background / surface | `#111318` |
| Surface container lowest / low | `#0C0E13` / `#191C20` |
| Surface container / high / highest | `#1D2024` / `#282A2F` / `#33353A` |
| On surface / on surface variant | `#E2E2E9` / `#C4C6D0` |
| Outline / outline variant | `#8E9099` / `#44474F` |
| Primary / on primary | `#B4C5FF` / `#002E6A` |
| Primary container / on container | `#1B459F` / `#DCE1FF` |
| Secondary / container | `#C3C5DD` / `#434659` |
| Tertiary / container | `#82D5D7` / `#005053` |
| Error / container | `#FFB4AB` / `#93000A` |
| Success / container | `#7DDBA6` / `#00522F` |
| Warning / container | `#F5BD52` / `#624000` |
| Info / container | `#ADC6FF` / `#16478F` |

Legacy short names used by existing widgets remain aliases:
`foreground` → `onSurface`, `foregroundSecondary` → `onSurfaceVariant`,
`foregroundMuted` → `outline`, `surfaceSecondary` → `surfaceContainer`,
`border` → `outlineVariant`, `primarySurface` → `primaryContainer`, and so on.
New code should prefer the Material role names.

Do not use `Color(0x...)` or `Colors.*` in feature screens. `Colors.transparent`
is acceptable for layout transparency, not as a semantic colour.

## Typography

[`app_typography.dart`](../lib/app/theme/app_typography.dart) defines the
Material 3 scale. The platform font is intentional; no custom font asset is
bundled.

| Style | Size / line height | Weight | Use |
| --- | --- | --- | --- |
| display large / medium / small | 45 / 36 / 30 | 700 | hero numbers, rare display |
| headline large / medium / small | 28 / 24 / 22 | 600–700 | screen/hero titles |
| title large / medium / small | 20 / 16 / 14 | 600 | sections, list emphasis |
| body large / medium / small | 16 / 14 / 13 | 400 | content and metadata |
| label large / medium / small | 14 / 12 / 11 | 500–600 | buttons, chips, captions |

Semantic getters are in
[`app_theme_context.dart`](../lib/app/theme/app_theme_context.dart):
`displayStyle`, `displayLargeStyle`, `titleStyle`, `titleMediumStyle`,
`headlineStyle`, `headlineLargeStyle`, `bodyStyle`, `bodyMediumStyle`,
`bodySmallStyle`, `labelStyle`, `labelMediumStyle`, `captionStyle`.
Do not set arbitrary `fontSize` in a screen.

## Shape

[`app_spacing.dart`](../lib/app/theme/app_spacing.dart) defines one shape scale:

| Token | Radius | Use |
| --- | --- | --- |
| `AppRadius.small` / `sm` | 10 | badges, tiny tonal tiles |
| `AppRadius.medium` / `md` | 12 | compact inner surfaces |
| `AppRadius.large` / `control` | 16 | text fields, list ink, secondary buttons |
| `AppRadius.extraLarge` / `card` | 24 | cards, dashboard surfaces |
| `AppRadius.dialog` | 28 | dialogs |
| `AppRadius.sheet` | 28 top | bottom sheets |
| `AppRadius.full` / `pill` | full | primary/destructive buttons, chips, badges |

Primary and destructive buttons use a StadiumBorder. Secondary/tonal buttons
use the control radius. Sheets are extra-large, not the same shape as fields.

## Spacing

`AppSpacing` goes from 4 px (`xs`) through 8, 12, 16, 20, 24, 32, 40 and 48.
`AppSpacing.page` (20) is the screen gutter. Use 16 px card padding, 12 px
surface gaps, 20–24 px section gaps and 32 px page bottom padding. Do not
hardcode random padding in feature code.

## Elevation and surfaces

Use tone rather than shadow:

- page → `surface` / `background`;
- grouped card → `surfaceContainerLow`;
- secondary group / metric strip → `surfaceContainer`;
- elevated/info surface → `surfaceContainerHigh`;
- active protection hero → `primaryContainer`;
- success/error result → `successContainer` / `errorContainer`.

Cards have a fine `outlineVariant` border. No global drop shadow; dialogs and
sheets use tonal surfaces and a scrim. Do not add gradients or glow effects.

## Motion

`AppMotion` defines:

- `fast` 120 ms — press/selection feedback;
- `normal` 220 ms — status changes, chips, switches;
- `slow` 360 ms — larger surface transitions;
- `emphasized` 480 ms and `emphasizedCurve` — reserved for the protection hero;
- enter `easeOutCubic`, exit `easeInCubic`, state `easeInOutCubic`.

`AppStatusIndicator` animates its tonal surface and title. All non-essential
animation checks `MediaQuery.disableAnimationsOf(context)`. Flutter's page
transitions use `FadeForwardsPageTransitionsBuilder`. Avoid bounce/looping
motion.

## Themes

[`AppTheme.light()` / `AppTheme.dark()`](../lib/app/theme/app_theme.dart) build
the `ColorScheme`, text theme, and themes for app bar, navigation, inputs,
buttons, switches, chips, cards, snackbars, dialogs, sheets, popups, tooltips,
lists and dividers.

Theme mode is part of existing Drift settings:

- `AppThemeMode { system, light, dark }`;
- `app_settings.theme_mode`, default `system`;
- schema version **2**, v1→v2 migration adds the column;
- persisted through `SettingsController` / `SettingsRepository`.

Do not add `shared_preferences` or a second preferences store. `MaterialApp`
animates mode changes without restart.

## Components

Shared widgets are in [`lib/shared/widgets/`](../lib/shared/widgets/).

| Component | Purpose |
| --- | --- |
| `AppScaffold` | background, app bar, safe area, optional bottom action bar |
| `AppButton` | primary pill, tonal secondary, text tertiary, destructive; loading/disabled |
| `AppIconButton` | circular tonal icon action; destructive variant; tooltip required |
| `AppCard` | surface/secondary/elevated/primary/success/danger tonal surface |
| `AppStatusIndicator` | expressive status hero with tonal container, icon and live region |
| `AppChip` | selectable filter chip with tonal selected state and check icon |
| `AppSegmentedControl` | single-choice M3 segmented filter control with full labels |
| `AppBottomNavigationBar` | compact M3-styled bottom navigation; optional labels, icon-only mode with tooltips and semantics |
| `AppListTile` | compact M3 list row with min 48 px target |
| `AppBadge` | neutral/primary/tertiary/success/warning/error/info status pill |
| `AppTextField` / `AppSearchField` | filled tonal inputs; search uses a full pill |
| `AppSwitch` | accessible adaptive switch |
| `AppSelectTile` | settings row with bottom-sheet selection |
| `AppDialog` | 28 px dialog with tonal surface |
| `showAppBottomSheet` / `AppSheetSurface` / `AppSheetHeader` | keyboard-safe extra-large sheet |
| `AppEmptyState` / `AppErrorState` / `AppLoadingState` | consistent UI states; loading uses a calm skeleton |
| `AppAsyncValueView` | maps `AsyncValue` to loading/error/data |
| `AppSectionHeader` | section label with optional trailing action |
| `AppDivider` | fine outline divider |
| snackbar helpers | success/error feedback |

Do not create a parallel component for a local visual variation. Extend the
nearest shared component or add a focused component when the pattern repeats.

## Screen patterns

### Dashboard

`HomeScreen` uses:

1. protection hero (`AppStatusIndicator`) with switch and explanation;
2. one tonal metrics surface with blocked calls, active rules and whitelist
   entries — real repository data only;
3. one compact tonal quick-action module with four short icon+label actions
   (caller check, add rule, history, protection settings), separated from the
   recent-activity section;
4. recent blocked calls as compact list rows with time and result badge.

Reading order is protection → metrics → actions → recent activity. Empty data
shows an informative empty row, not fabricated statistics.

### Rules

`RulesScreen` has a pill search field, All/Active/Disabled
`AppSegmentedControl`, and grouped Active/Disabled sections. Each section is one
tonal card with compact rows: toned leading icon, name, RegExp, optional
description, priority badge, switch and menu. Status is carried by the section
and switch, not a second badge. Empty and no-search states are explicit.

### Rule editor

The form is split into section cards: rule details, behavior and an example
surface. The primary Save and Cancel actions live in a sticky bottom bar inside
a safe area, so they remain reachable with large text and the keyboard open.
Validation is inline; discard confirmation protects dirty input.

### History

`CallHistoryScreen` has search, an All/Today/Earlier `AppSegmentedControl`,
date-grouped sections, compact blocked-call rows and a destructive clear action.
Each row has a tonal status icon, organization/number/rule metadata and time.
The section title supplies the blocked context, avoiding a redundant badge on
every row. No call row is a large card.

### Whitelist

`WhitelistScreen` uses search, compact rows, a tonal avatar, delete action and an
add-number dialog. Empty and search-empty states are explicit.

### Settings

`SettingsScreen` opens with a primary tonal app hero, then Appearance,
Filtering, Platform integration and About sections. Appearance uses
`AppSelectTile` for System/Light/Dark and language. Platform capability badges
are informational; they do not claim blocking success.

### Navigation

`AppShell` keeps GoRouter paths and keys. Phones use `AppBottomNavigationBar`
in icon-only mode (68 px, secondaryContainer indicator). Each destination keeps
its accessible name through Semantics and a tooltip; there are no visible labels.
Widths ≥600 use `NavigationRail` in icon-only mode with the same destinations,
semantic labels and tooltips. Do not
create a second navigation model.

## Responsive behavior

- Screen gutters are `AppSpacing.page` (20).
- No fixed content heights; text can wrap and surfaces grow.
- The rule editor actions stay in a safe-area bottom bar.
- Keyboard insets are respected by `Scaffold`/`showModalBottomSheet`.
- Tests cover 360×740 with 1.35 text scaling across all tabs.
- Lists and chips scroll horizontally where needed; cards never force a
  multi-column layout that becomes too narrow.
- Navigation rail appears at 600 logical pixels; both rail and compact bottom
  navigation are icon-only, with semantic labels and tooltips. This follows the M3 medium window class more closely than the old 720
  breakpoint.
- `AppScaffold` centers body content at `AppSizes.pageMaxWidth` (720); wide
  windows must not stretch phone content edge to edge.
- Text fields use the tonal fill plus an `outline` boundary; labels and helper
  text use `onSurfaceVariant`/primary, keeping forms distinguishable from their
  cards.
- Bottom sheets are capped at `AppSizes.sheetMaxWidth` (640) and centered.

## Accessibility

- Minimum interactive target 48 px (`AppSizes.minTapTarget`).
- Icon-only controls require tooltips; selects/switches have semantic labels.
- Compact dashboard actions keep full action names in tooltip/semantics while
  showing short visible labels.
- `AppStatusIndicator` is a live region and includes the status text, not just
  colour.
- Caption and hint text use `onSurfaceVariant`, not `outline`; `outline` is a
  non-text role and fails the 4.5:1 target on the light input surface.
- Selected `AppChip` includes a check icon; state is not conveyed by colour
  alone.
- Status/badges pair colour with a text label.
- Text scaling is supported; avoid fixed heights and ellipsis where a label is
  essential.
- Dialogs/sheets remain usable with the software keyboard and safe areas.
- Reduced Motion disables non-essential transitions.

## Testing UI

- `test/shared/design_system_test.dart` covers themes, button variants,
  loading/disabled, inline validation and large text.
- `test/shared/responsive_accessibility_test.dart` covers 360×740 and 1.35 text
  scaling across all tabs.
- `test/features/home/home_dashboard_test.dart` covers real dashboard metrics,
  filtering toggle persistence and quick actions.
- `test/features/rules/rules_filter_test.dart` and
  `test/features/call_history/history_filter_test.dart` cover the new search and
  filter controls.
- Settings tests cover theme/language switching and card gutters.
- Local macOS goldens are grouped by purpose:
  - Component: `design_system_buttons_light.png`,
    `expressive_components_light.png`, `expressive_components_dark.png`;
  - Screen: `screen_home_*`, `screen_rules_*`, `screen_rule_editor_*`,
    `screen_whitelist_*`, `screen_history_*`, `screen_settings_*`,
    `screen_caller_check_*`;
  - State: `screen_rules_empty_light.png`, `screen_history_empty_light.png`;
  - Theme: light/dark screen variants;
  - Responsive: `screen_home_wide_light.png`,
    `screen_home_compact_light.png`.
- Golden fonts are loaded from the local Flutter SDK Roboto/MaterialIcons
  artifacts in `test/helpers/test_fonts.dart`; no app font dependency or asset
  was added.
- `test/shared/adaptive_layout_test.dart` verifies rail at 600/900/1200, bottom
  nav below it, bounded content and bounded sheets.
- `test/shared/long_content_test.dart` covers 2.0 text scale, compact empty and
  populated screens, long Russian names, the editor and the caller sheet.
- Goldens are not a cross-platform CI gate because host font rendering differs.
- Preserve stable keys used by tests: `nav_*`, `home_filtering_switch`,
  `check_caller_tile`, `add_rule_button`, `save_rule_button`, `theme_selector`,
  `language_dropdown`, `clear_history_button`, `history_search_field`,
  `rules_search_field`.

## Adding UI

1. Reuse an existing component or extend its documented API.
2. Use `context.appColors` and semantic text styles; never local colours or
   arbitrary font sizes.
3. Use the shape scale: controls 16, cards 24, sheets/dialogs 28, pills full.
4. Use tonal surfaces before shadows.
5. Add all states: loading, loaded, empty, error, disabled, saving, validation.
6. Add both ARB strings and check English/Russian length, large text, keyboard
   and safe area.
7. Add widget/integration tests and update this document when a reusable pattern
   changes.
