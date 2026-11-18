import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'CallFilter'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navRules.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get navRules;

  /// No description provided for @navWhitelist.
  ///
  /// In en, this message translates to:
  /// **'Whitelist'**
  String get navWhitelist;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @homeFilteringOn.
  ///
  /// In en, this message translates to:
  /// **'Filtering is on'**
  String get homeFilteringOn;

  /// No description provided for @homeFilteringOff.
  ///
  /// In en, this message translates to:
  /// **'Filtering is off'**
  String get homeFilteringOff;

  /// No description provided for @homeRulesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No rules} =1{1 rule} other{{count} rules}}'**
  String homeRulesCount(int count);

  /// No description provided for @homeBlockedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No blocked calls} =1{1 blocked call} other{{count} blocked calls}}'**
  String homeBlockedCount(int count);

  /// No description provided for @homeCheckCaller.
  ///
  /// In en, this message translates to:
  /// **'Check a caller'**
  String get homeCheckCaller;

  /// No description provided for @homeCheckCallerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Test rules locally and see the decision.'**
  String get homeCheckCallerSubtitle;

  /// No description provided for @homeManageRules.
  ///
  /// In en, this message translates to:
  /// **'Manage rules'**
  String get homeManageRules;

  /// No description provided for @homeWhitelist.
  ///
  /// In en, this message translates to:
  /// **'Whitelist'**
  String get homeWhitelist;

  /// No description provided for @homeHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get homeHistory;

  /// No description provided for @homeActiveRules.
  ///
  /// In en, this message translates to:
  /// **'Active rules'**
  String get homeActiveRules;

  /// No description provided for @homeRecentBlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent blocked calls'**
  String get homeRecentBlockedTitle;

  /// No description provided for @homeViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get homeViewAll;

  /// No description provided for @homeNoRecentBlocked.
  ///
  /// In en, this message translates to:
  /// **'No recent blocked calls'**
  String get homeNoRecentBlocked;

  /// No description provided for @homeManageProtection.
  ///
  /// In en, this message translates to:
  /// **'Manage protection'**
  String get homeManageProtection;

  /// No description provided for @homeQuickCheck.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get homeQuickCheck;

  /// No description provided for @homeQuickRule.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get homeQuickRule;

  /// No description provided for @homeQuickHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get homeQuickHistory;

  /// No description provided for @homeQuickProtection.
  ///
  /// In en, this message translates to:
  /// **'Protection'**
  String get homeQuickProtection;

  /// No description provided for @homeQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get homeQuickActions;

  /// No description provided for @rulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter rules'**
  String get rulesTitle;

  /// No description provided for @rulesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No filter rules yet'**
  String get rulesEmptyTitle;

  /// No description provided for @rulesFilterActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get rulesFilterActive;

  /// No description provided for @rulesFilterDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get rulesFilterDisabled;

  /// No description provided for @rulesEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Create a rule to block callers by organization name.'**
  String get rulesEmptyBody;

  /// No description provided for @addRule.
  ///
  /// In en, this message translates to:
  /// **'Add rule'**
  String get addRule;

  /// No description provided for @searchRulesHint.
  ///
  /// In en, this message translates to:
  /// **'Search rules'**
  String get searchRulesHint;

  /// No description provided for @searchHistoryHint.
  ///
  /// In en, this message translates to:
  /// **'Search blocked calls'**
  String get searchHistoryHint;

  /// No description provided for @searchWhitelistHint.
  ///
  /// In en, this message translates to:
  /// **'Search whitelist'**
  String get searchWhitelistHint;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @moreActions.
  ///
  /// In en, this message translates to:
  /// **'More actions'**
  String get moreActions;

  /// No description provided for @searchClear.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get searchClear;

  /// No description provided for @noSearchResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing found'**
  String get noSearchResultsTitle;

  /// No description provided for @noSearchResultsBody.
  ///
  /// In en, this message translates to:
  /// **'Try a different query.'**
  String get noSearchResultsBody;

  /// No description provided for @rulePriority.
  ///
  /// In en, this message translates to:
  /// **'Priority {priority}'**
  String rulePriority(int priority);

  /// No description provided for @ruleAddTitle.
  ///
  /// In en, this message translates to:
  /// **'New rule'**
  String get ruleAddTitle;

  /// No description provided for @ruleSectionIdentity.
  ///
  /// In en, this message translates to:
  /// **'Rule details'**
  String get ruleSectionIdentity;

  /// No description provided for @ruleSectionBehavior.
  ///
  /// In en, this message translates to:
  /// **'Behavior'**
  String get ruleSectionBehavior;

  /// No description provided for @ruleEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit rule'**
  String get ruleEditTitle;

  /// No description provided for @ruleNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Rule name'**
  String get ruleNameLabel;

  /// No description provided for @rulePatternLabel.
  ///
  /// In en, this message translates to:
  /// **'Organization name pattern (RegExp)'**
  String get rulePatternLabel;

  /// No description provided for @rulePatternHelp.
  ///
  /// In en, this message translates to:
  /// **'Matching is case-insensitive and applied to the normalized caller display name.'**
  String get rulePatternHelp;

  /// No description provided for @ruleDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get ruleDescriptionLabel;

  /// No description provided for @rulePriorityLabel.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get rulePriorityLabel;

  /// No description provided for @ruleEnabledLabel.
  ///
  /// In en, this message translates to:
  /// **'Rule enabled'**
  String get ruleEnabledLabel;

  /// No description provided for @ruleSave.
  ///
  /// In en, this message translates to:
  /// **'Save rule'**
  String get ruleSave;

  /// No description provided for @editorDiscardTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get editorDiscardTitle;

  /// No description provided for @editorDiscardBody.
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes will be lost.'**
  String get editorDiscardBody;

  /// No description provided for @editorDiscardConfirm.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get editorDiscardConfirm;

  /// No description provided for @editorKeepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get editorKeepEditing;

  /// No description provided for @ruleNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a rule name.'**
  String get ruleNameRequired;

  /// No description provided for @rulePatternRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a RegExp pattern.'**
  String get rulePatternRequired;

  /// No description provided for @ruleRegexInvalidSyntax.
  ///
  /// In en, this message translates to:
  /// **'The pattern is not a valid RegExp.'**
  String get ruleRegexInvalidSyntax;

  /// No description provided for @ruleRegexEmpty.
  ///
  /// In en, this message translates to:
  /// **'Enter a RegExp pattern.'**
  String get ruleRegexEmpty;

  /// No description provided for @ruleRegexTooLong.
  ///
  /// In en, this message translates to:
  /// **'The pattern is too long (max {max} characters).'**
  String ruleRegexTooLong(int max);

  /// No description provided for @ruleRegexNestedQuantifier.
  ///
  /// In en, this message translates to:
  /// **'Nested quantifiers are not allowed because they can cause very slow matching.'**
  String get ruleRegexNestedQuantifier;

  /// No description provided for @ruleRegexRepetitionTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Repetition counts above {max} are not allowed.'**
  String ruleRegexRepetitionTooLarge(int max);

  /// No description provided for @ruleRegexControlCharacters.
  ///
  /// In en, this message translates to:
  /// **'Control characters are not allowed.'**
  String get ruleRegexControlCharacters;

  /// No description provided for @ruleSaved.
  ///
  /// In en, this message translates to:
  /// **'Rule saved.'**
  String get ruleSaved;

  /// No description provided for @ruleDeleted.
  ///
  /// In en, this message translates to:
  /// **'Rule deleted.'**
  String get ruleDeleted;

  /// No description provided for @rulePriorityInvalid.
  ///
  /// In en, this message translates to:
  /// **'Priority must be a whole number between 0 and 100.'**
  String get rulePriorityInvalid;

  /// No description provided for @ruleExampleTitle.
  ///
  /// In en, this message translates to:
  /// **'Example'**
  String get ruleExampleTitle;

  /// No description provided for @ruleExampleBody.
  ///
  /// In en, this message translates to:
  /// **'Use ^ооо\\s+работа\$ to match the organization \"ООО Работа\".'**
  String get ruleExampleBody;

  /// No description provided for @ruleDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete rule?'**
  String get ruleDeleteTitle;

  /// No description provided for @ruleDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This rule will stop blocking calls.'**
  String get ruleDeleteBody;

  /// No description provided for @whitelistTitle.
  ///
  /// In en, this message translates to:
  /// **'Whitelist'**
  String get whitelistTitle;

  /// No description provided for @whitelistEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Whitelist is empty'**
  String get whitelistEmptyTitle;

  /// No description provided for @whitelistEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Numbers on the whitelist are never blocked.'**
  String get whitelistEmptyBody;

  /// No description provided for @whitelistAdd.
  ///
  /// In en, this message translates to:
  /// **'Add number'**
  String get whitelistAdd;

  /// No description provided for @whitelistPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get whitelistPhoneLabel;

  /// No description provided for @whitelistLabelLabel.
  ///
  /// In en, this message translates to:
  /// **'Label (optional)'**
  String get whitelistLabelLabel;

  /// No description provided for @whitelistPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a phone number with at least 5 digits.'**
  String get whitelistPhoneInvalid;

  /// No description provided for @whitelistSaved.
  ///
  /// In en, this message translates to:
  /// **'Number added to the whitelist.'**
  String get whitelistSaved;

  /// No description provided for @whitelistRemoved.
  ///
  /// In en, this message translates to:
  /// **'Number removed from the whitelist.'**
  String get whitelistRemoved;

  /// No description provided for @whitelistDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove number?'**
  String get whitelistDeleteTitle;

  /// No description provided for @whitelistDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'The number will no longer be protected by the whitelist.'**
  String get whitelistDeleteBody;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Blocked calls'**
  String get historyTitle;

  /// No description provided for @historyEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No blocked calls'**
  String get historyEmptyTitle;

  /// No description provided for @historyEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Blocked calls will appear here.'**
  String get historyEmptyBody;

  /// No description provided for @historyToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get historyToday;

  /// No description provided for @historyFilterEarlier.
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get historyFilterEarlier;

  /// No description provided for @historyYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get historyYesterday;

  /// No description provided for @historyClear.
  ///
  /// In en, this message translates to:
  /// **'Clear history'**
  String get historyClear;

  /// No description provided for @historyCleared.
  ///
  /// In en, this message translates to:
  /// **'Call history cleared.'**
  String get historyCleared;

  /// No description provided for @historyClearTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear call history?'**
  String get historyClearTitle;

  /// No description provided for @historyClearBody.
  ///
  /// In en, this message translates to:
  /// **'All locally stored blocked calls will be removed.'**
  String get historyClearBody;

  /// No description provided for @historyUnknownOrganization.
  ///
  /// In en, this message translates to:
  /// **'Unknown organization'**
  String get historyUnknownOrganization;

  /// No description provided for @historyMatchedRule.
  ///
  /// In en, this message translates to:
  /// **'Matched rule: {rule}'**
  String historyMatchedRule(String rule);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAppearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearanceTitle;

  /// No description provided for @settingsThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsThemeTitle;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsFilteringTitle.
  ///
  /// In en, this message translates to:
  /// **'Call filtering'**
  String get settingsFilteringTitle;

  /// No description provided for @settingsFilteringSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Evaluate active rules for incoming calls.'**
  String get settingsFilteringSubtitle;

  /// No description provided for @settingsLogTitle.
  ///
  /// In en, this message translates to:
  /// **'Log blocked calls'**
  String get settingsLogTitle;

  /// No description provided for @settingsLogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep a local history of blocked calls.'**
  String get settingsLogSubtitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageRussian.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get settingsLanguageRussian;

  /// No description provided for @settingsPlatformTitle.
  ///
  /// In en, this message translates to:
  /// **'Platform integration'**
  String get settingsPlatformTitle;

  /// No description provided for @settingsPlatformSync.
  ///
  /// In en, this message translates to:
  /// **'Sync rules with system'**
  String get settingsPlatformSync;

  /// No description provided for @settingsPlatformSynced.
  ///
  /// In en, this message translates to:
  /// **'Filter data sent to the platform layer.'**
  String get settingsPlatformSynced;

  /// No description provided for @settingsPlatformOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open system settings'**
  String get settingsPlatformOpenSettings;

  /// No description provided for @settingsPlatformUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Native call screening is unavailable on this platform.'**
  String get settingsPlatformUnavailable;

  /// No description provided for @settingsPlatformExperimental.
  ///
  /// In en, this message translates to:
  /// **'Native integration is experimental and must be verified on a physical device. Android may not provide the caller display name; iOS can only use prepared number mappings.'**
  String get settingsPlatformExperimental;

  /// No description provided for @settingsPlatformError.
  ///
  /// In en, this message translates to:
  /// **'Native integration error: {message}'**
  String settingsPlatformError(String message);

  /// No description provided for @capabilitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Capabilities'**
  String get capabilitiesTitle;

  /// No description provided for @capabilityCallScreening.
  ///
  /// In en, this message translates to:
  /// **'Call screening service'**
  String get capabilityCallScreening;

  /// No description provided for @capabilityCallerName.
  ///
  /// In en, this message translates to:
  /// **'Caller display name'**
  String get capabilityCallerName;

  /// No description provided for @capabilityCallDirectory.
  ///
  /// In en, this message translates to:
  /// **'Call Directory extension'**
  String get capabilityCallDirectory;

  /// No description provided for @capabilityNumberBlocking.
  ///
  /// In en, this message translates to:
  /// **'Phone number blocking'**
  String get capabilityNumberBlocking;

  /// No description provided for @capabilityYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get capabilityYes;

  /// No description provided for @capabilityNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get capabilityNo;

  /// No description provided for @capabilityLimited.
  ///
  /// In en, this message translates to:
  /// **'Limited'**
  String get capabilityLimited;

  /// No description provided for @settingsAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAboutTitle;

  /// No description provided for @settingsAboutBody.
  ///
  /// In en, this message translates to:
  /// **'CallFilter reduces unwanted calls by matching the caller organization name. All settings and data stay on this device.'**
  String get settingsAboutBody;

  /// No description provided for @callerCheckTitle.
  ///
  /// In en, this message translates to:
  /// **'Check a caller'**
  String get callerCheckTitle;

  /// No description provided for @callerPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get callerPhoneLabel;

  /// No description provided for @callerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Caller display name'**
  String get callerNameLabel;

  /// No description provided for @callerPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'+7 700 000 00 00'**
  String get callerPhoneHint;

  /// No description provided for @callerNameHint.
  ///
  /// In en, this message translates to:
  /// **'ООО Работа'**
  String get callerNameHint;

  /// No description provided for @callerPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a phone number with at least 5 digits.'**
  String get callerPhoneInvalid;

  /// No description provided for @callerCheckAction.
  ///
  /// In en, this message translates to:
  /// **'Evaluate'**
  String get callerCheckAction;

  /// No description provided for @callerBlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Call would be blocked'**
  String get callerBlockedTitle;

  /// No description provided for @callerAllowedTitle.
  ///
  /// In en, this message translates to:
  /// **'Call would be allowed'**
  String get callerAllowedTitle;

  /// No description provided for @callerBlockedBody.
  ///
  /// In en, this message translates to:
  /// **'Matched rule \"{rule}\" for {organization}.'**
  String callerBlockedBody(String rule, String organization);

  /// No description provided for @callerAllowedBody.
  ///
  /// In en, this message translates to:
  /// **'Reason: {reason}.'**
  String callerAllowedBody(String reason);

  /// No description provided for @callerNoRule.
  ///
  /// In en, this message translates to:
  /// **'No matching rule.'**
  String get callerNoRule;

  /// No description provided for @callerWhitelisted.
  ///
  /// In en, this message translates to:
  /// **'The number is on the whitelist.'**
  String get callerWhitelisted;

  /// No description provided for @callerNoName.
  ///
  /// In en, this message translates to:
  /// **'The caller display name is unavailable, so name-based rules cannot be applied.'**
  String get callerNoName;

  /// No description provided for @callerFilteringDisabled.
  ///
  /// In en, this message translates to:
  /// **'Filtering is disabled in settings.'**
  String get callerFilteringDisabled;

  /// No description provided for @callerInvalidRules.
  ///
  /// In en, this message translates to:
  /// **'No safe rule could be evaluated.'**
  String get callerInvalidRules;

  /// No description provided for @callerTimeout.
  ///
  /// In en, this message translates to:
  /// **'Rule evaluation timed out.'**
  String get callerTimeout;

  /// No description provided for @callerLogged.
  ///
  /// In en, this message translates to:
  /// **'The blocked call was added to history.'**
  String get callerLogged;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get errorGeneric;

  /// No description provided for @errorDatabase.
  ///
  /// In en, this message translates to:
  /// **'Could not access the local database.'**
  String get errorDatabase;

  /// No description provided for @errorPlatformChannel.
  ///
  /// In en, this message translates to:
  /// **'The platform integration is unavailable.'**
  String get errorPlatformChannel;

  /// No description provided for @errorRuleNotFound.
  ///
  /// In en, this message translates to:
  /// **'The rule was not found.'**
  String get errorRuleNotFound;

  /// No description provided for @unsupportedPlatform.
  ///
  /// In en, this message translates to:
  /// **'Unsupported platform.'**
  String get unsupportedPlatform;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
