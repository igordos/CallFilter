// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'CallFilter';

  @override
  String get navHome => 'Home';

  @override
  String get navRules => 'Rules';

  @override
  String get navWhitelist => 'Whitelist';

  @override
  String get navHistory => 'History';

  @override
  String get navSettings => 'Settings';

  @override
  String get loading => 'Loading';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get close => 'Close';

  @override
  String get enabled => 'Enabled';

  @override
  String get disabled => 'Disabled';

  @override
  String get clear => 'Clear';

  @override
  String get homeFilteringOn => 'Filtering is on';

  @override
  String get homeFilteringOff => 'Filtering is off';

  @override
  String homeRulesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rules',
      one: '1 rule',
      zero: 'No rules',
    );
    return '$_temp0';
  }

  @override
  String homeBlockedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count blocked calls',
      one: '1 blocked call',
      zero: 'No blocked calls',
    );
    return '$_temp0';
  }

  @override
  String get homeCheckCaller => 'Check a caller';

  @override
  String get homeCheckCallerSubtitle =>
      'Test rules locally and see the decision.';

  @override
  String get homeManageRules => 'Manage rules';

  @override
  String get homeWhitelist => 'Whitelist';

  @override
  String get homeHistory => 'History';

  @override
  String get homeActiveRules => 'Active rules';

  @override
  String get homeRecentBlockedTitle => 'Recent blocked calls';

  @override
  String get homeViewAll => 'View all';

  @override
  String get homeNoRecentBlocked => 'No recent blocked calls';

  @override
  String get homeManageProtection => 'Manage protection';

  @override
  String get homeQuickCheck => 'Check';

  @override
  String get homeQuickRule => 'Add';

  @override
  String get homeQuickHistory => 'History';

  @override
  String get homeQuickProtection => 'Protection';

  @override
  String get homeQuickActions => 'Quick actions';

  @override
  String get rulesTitle => 'Filter rules';

  @override
  String get rulesEmptyTitle => 'No filter rules yet';

  @override
  String get rulesFilterActive => 'Active';

  @override
  String get rulesFilterDisabled => 'Disabled';

  @override
  String get rulesEmptyBody =>
      'Create a rule to block callers by organization name.';

  @override
  String get addRule => 'Add rule';

  @override
  String get searchRulesHint => 'Search rules';

  @override
  String get searchHistoryHint => 'Search blocked calls';

  @override
  String get searchWhitelistHint => 'Search whitelist';

  @override
  String get filterAll => 'All';

  @override
  String get moreActions => 'More actions';

  @override
  String get searchClear => 'Clear search';

  @override
  String get noSearchResultsTitle => 'Nothing found';

  @override
  String get noSearchResultsBody => 'Try a different query.';

  @override
  String rulePriority(int priority) {
    return 'Priority $priority';
  }

  @override
  String get ruleAddTitle => 'New rule';

  @override
  String get ruleSectionIdentity => 'Rule details';

  @override
  String get ruleSectionBehavior => 'Behavior';

  @override
  String get ruleEditTitle => 'Edit rule';

  @override
  String get ruleNameLabel => 'Rule name';

  @override
  String get rulePatternLabel => 'Organization name pattern (RegExp)';

  @override
  String get rulePatternHelp =>
      'Matching is case-insensitive and applied to the normalized caller display name.';

  @override
  String get ruleDescriptionLabel => 'Description (optional)';

  @override
  String get rulePriorityLabel => 'Priority';

  @override
  String get ruleEnabledLabel => 'Rule enabled';

  @override
  String get ruleSave => 'Save rule';

  @override
  String get editorDiscardTitle => 'Discard changes?';

  @override
  String get editorDiscardBody => 'Unsaved changes will be lost.';

  @override
  String get editorDiscardConfirm => 'Discard';

  @override
  String get editorKeepEditing => 'Keep editing';

  @override
  String get ruleNameRequired => 'Enter a rule name.';

  @override
  String get rulePatternRequired => 'Enter a RegExp pattern.';

  @override
  String get ruleRegexInvalidSyntax => 'The pattern is not a valid RegExp.';

  @override
  String get ruleRegexEmpty => 'Enter a RegExp pattern.';

  @override
  String ruleRegexTooLong(int max) {
    return 'The pattern is too long (max $max characters).';
  }

  @override
  String get ruleRegexNestedQuantifier =>
      'Nested quantifiers are not allowed because they can cause very slow matching.';

  @override
  String ruleRegexRepetitionTooLarge(int max) {
    return 'Repetition counts above $max are not allowed.';
  }

  @override
  String get ruleRegexControlCharacters =>
      'Control characters are not allowed.';

  @override
  String get ruleSaved => 'Rule saved.';

  @override
  String get ruleDeleted => 'Rule deleted.';

  @override
  String get rulePriorityInvalid =>
      'Priority must be a whole number between 0 and 100.';

  @override
  String get ruleExampleTitle => 'Example';

  @override
  String get ruleExampleBody =>
      'Use ^ооо\\s+работа\$ to match the organization \"ООО Работа\".';

  @override
  String get ruleDeleteTitle => 'Delete rule?';

  @override
  String get ruleDeleteBody => 'This rule will stop blocking calls.';

  @override
  String get whitelistTitle => 'Whitelist';

  @override
  String get whitelistEmptyTitle => 'Whitelist is empty';

  @override
  String get whitelistEmptyBody =>
      'Numbers on the whitelist are never blocked.';

  @override
  String get whitelistAdd => 'Add number';

  @override
  String get whitelistPhoneLabel => 'Phone number';

  @override
  String get whitelistLabelLabel => 'Label (optional)';

  @override
  String get whitelistPhoneInvalid =>
      'Enter a phone number with at least 5 digits.';

  @override
  String get whitelistSaved => 'Number added to the whitelist.';

  @override
  String get whitelistRemoved => 'Number removed from the whitelist.';

  @override
  String get whitelistDeleteTitle => 'Remove number?';

  @override
  String get whitelistDeleteBody =>
      'The number will no longer be protected by the whitelist.';

  @override
  String get historyTitle => 'Blocked calls';

  @override
  String get historyEmptyTitle => 'No blocked calls';

  @override
  String get historyEmptyBody => 'Blocked calls will appear here.';

  @override
  String get historyToday => 'Today';

  @override
  String get historyFilterEarlier => 'Earlier';

  @override
  String get historyYesterday => 'Yesterday';

  @override
  String get historyClear => 'Clear history';

  @override
  String get historyCleared => 'Call history cleared.';

  @override
  String get historyClearTitle => 'Clear call history?';

  @override
  String get historyClearBody =>
      'All locally stored blocked calls will be removed.';

  @override
  String get historyUnknownOrganization => 'Unknown organization';

  @override
  String historyMatchedRule(String rule) {
    return 'Matched rule: $rule';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearanceTitle => 'Appearance';

  @override
  String get settingsThemeTitle => 'Theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsFilteringTitle => 'Call filtering';

  @override
  String get settingsFilteringSubtitle =>
      'Evaluate active rules for incoming calls.';

  @override
  String get settingsLogTitle => 'Log blocked calls';

  @override
  String get settingsLogSubtitle => 'Keep a local history of blocked calls.';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageRussian => 'Русский';

  @override
  String get settingsPlatformTitle => 'Platform integration';

  @override
  String get settingsPlatformSync => 'Sync rules with system';

  @override
  String get settingsPlatformSynced =>
      'Filter data sent to the platform layer.';

  @override
  String get settingsPlatformOpenSettings => 'Open system settings';

  @override
  String get settingsPlatformUnavailable =>
      'Native call screening is unavailable on this platform.';

  @override
  String get settingsPlatformExperimental =>
      'Native integration is experimental and must be verified on a physical device. Android may not provide the caller display name; iOS can only use prepared number mappings.';

  @override
  String settingsPlatformError(String message) {
    return 'Native integration error: $message';
  }

  @override
  String get capabilitiesTitle => 'Capabilities';

  @override
  String get capabilityCallScreening => 'Call screening service';

  @override
  String get capabilityCallerName => 'Caller display name';

  @override
  String get capabilityCallDirectory => 'Call Directory extension';

  @override
  String get capabilityNumberBlocking => 'Phone number blocking';

  @override
  String get capabilityYes => 'Yes';

  @override
  String get capabilityNo => 'No';

  @override
  String get capabilityLimited => 'Limited';

  @override
  String get settingsAboutTitle => 'About';

  @override
  String get settingsAboutBody =>
      'CallFilter reduces unwanted calls by matching the caller organization name. All settings and data stay on this device.';

  @override
  String get callerCheckTitle => 'Check a caller';

  @override
  String get callerPhoneLabel => 'Phone number';

  @override
  String get callerNameLabel => 'Caller display name';

  @override
  String get callerPhoneHint => '+7 700 000 00 00';

  @override
  String get callerNameHint => 'ООО Работа';

  @override
  String get callerPhoneInvalid =>
      'Enter a phone number with at least 5 digits.';

  @override
  String get callerCheckAction => 'Evaluate';

  @override
  String get callerBlockedTitle => 'Call would be blocked';

  @override
  String get callerAllowedTitle => 'Call would be allowed';

  @override
  String callerBlockedBody(String rule, String organization) {
    return 'Matched rule \"$rule\" for $organization.';
  }

  @override
  String callerAllowedBody(String reason) {
    return 'Reason: $reason.';
  }

  @override
  String get callerNoRule => 'No matching rule.';

  @override
  String get callerWhitelisted => 'The number is on the whitelist.';

  @override
  String get callerNoName =>
      'The caller display name is unavailable, so name-based rules cannot be applied.';

  @override
  String get callerFilteringDisabled => 'Filtering is disabled in settings.';

  @override
  String get callerInvalidRules => 'No safe rule could be evaluated.';

  @override
  String get callerTimeout => 'Rule evaluation timed out.';

  @override
  String get callerLogged => 'The blocked call was added to history.';

  @override
  String get errorGeneric => 'Something went wrong.';

  @override
  String get errorDatabase => 'Could not access the local database.';

  @override
  String get errorPlatformChannel => 'The platform integration is unavailable.';

  @override
  String get errorRuleNotFound => 'The rule was not found.';

  @override
  String get unsupportedPlatform => 'Unsupported platform.';
}
