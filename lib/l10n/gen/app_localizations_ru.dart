// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'CallFilter';

  @override
  String get navHome => 'Главная';

  @override
  String get navRules => 'Правила';

  @override
  String get navWhitelist => 'Белый список';

  @override
  String get navHistory => 'Журнал';

  @override
  String get navSettings => 'Настройки';

  @override
  String get loading => 'Загрузка';

  @override
  String get retry => 'Повторить';

  @override
  String get cancel => 'Отмена';

  @override
  String get save => 'Сохранить';

  @override
  String get delete => 'Удалить';

  @override
  String get edit => 'Изменить';

  @override
  String get add => 'Добавить';

  @override
  String get close => 'Закрыть';

  @override
  String get enabled => 'Включено';

  @override
  String get disabled => 'Выключено';

  @override
  String get clear => 'Очистить';

  @override
  String get homeFilteringOn => 'Фильтрация включена';

  @override
  String get homeFilteringOff => 'Фильтрация выключена';

  @override
  String homeRulesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count правила',
      many: '$count правил',
      few: '$count правила',
      one: '1 правило',
      zero: 'Нет правил',
    );
    return '$_temp0';
  }

  @override
  String homeBlockedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count заблокированного звонка',
      many: '$count заблокированных звонков',
      few: '$count заблокированных звонка',
      one: '1 заблокированный звонок',
      zero: 'Нет заблокированных звонков',
    );
    return '$_temp0';
  }

  @override
  String get homeCheckCaller => 'Проверить звонок';

  @override
  String get homeCheckCallerSubtitle =>
      'Проверьте правило локально и посмотрите решение.';

  @override
  String get homeManageRules => 'Управление правилами';

  @override
  String get homeWhitelist => 'Белый список';

  @override
  String get homeHistory => 'Журнал';

  @override
  String get homeActiveRules => 'Активные правила';

  @override
  String get homeRecentBlockedTitle => 'Последние блокировки';

  @override
  String get homeViewAll => 'Все';

  @override
  String get homeNoRecentBlocked => 'Недавних блокировок нет';

  @override
  String get homeManageProtection => 'Управление защитой';

  @override
  String get homeQuickCheck => 'Проверить';

  @override
  String get homeQuickRule => 'Добавить';

  @override
  String get homeQuickHistory => 'Журнал';

  @override
  String get homeQuickProtection => 'Защита';

  @override
  String get homeQuickActions => 'Быстрые действия';

  @override
  String get rulesTitle => 'Правила фильтрации';

  @override
  String get rulesEmptyTitle => 'Правил пока нет';

  @override
  String get rulesFilterActive => 'Активные';

  @override
  String get rulesFilterDisabled => 'Выключенные';

  @override
  String get rulesEmptyBody =>
      'Создайте правило, чтобы блокировать звонки по названию организации.';

  @override
  String get addRule => 'Добавить правило';

  @override
  String get searchRulesHint => 'Поиск правил';

  @override
  String get searchHistoryHint => 'Поиск в журнале';

  @override
  String get searchWhitelistHint => 'Поиск в белом списке';

  @override
  String get filterAll => 'Все';

  @override
  String get moreActions => 'Действия';

  @override
  String get searchClear => 'Очистить поиск';

  @override
  String get noSearchResultsTitle => 'Ничего не найдено';

  @override
  String get noSearchResultsBody => 'Попробуйте изменить запрос.';

  @override
  String rulePriority(int priority) {
    return 'Приоритет $priority';
  }

  @override
  String get ruleAddTitle => 'Новое правило';

  @override
  String get ruleSectionIdentity => 'Данные правила';

  @override
  String get ruleSectionBehavior => 'Поведение';

  @override
  String get ruleEditTitle => 'Редактирование правила';

  @override
  String get ruleNameLabel => 'Название правила';

  @override
  String get rulePatternLabel => 'Шаблон названия организации (RegExp)';

  @override
  String get rulePatternHelp =>
      'Сопоставление без учёта регистра применяется к нормализованному отображаемому имени звонящего.';

  @override
  String get ruleDescriptionLabel => 'Описание (необязательно)';

  @override
  String get rulePriorityLabel => 'Приоритет';

  @override
  String get ruleEnabledLabel => 'Правило включено';

  @override
  String get ruleSave => 'Сохранить правило';

  @override
  String get editorDiscardTitle => 'Отменить изменения?';

  @override
  String get editorDiscardBody => 'Несохранённые изменения будут потеряны.';

  @override
  String get editorDiscardConfirm => 'Отменить';

  @override
  String get editorKeepEditing => 'Продолжить редактирование';

  @override
  String get ruleNameRequired => 'Введите название правила.';

  @override
  String get rulePatternRequired => 'Введите RegExp-шаблон.';

  @override
  String get ruleRegexInvalidSyntax => 'Шаблон не является корректным RegExp.';

  @override
  String get ruleRegexEmpty => 'Введите RegExp-шаблон.';

  @override
  String ruleRegexTooLong(int max) {
    return 'Шаблон слишком длинный (не более $max символов).';
  }

  @override
  String get ruleRegexNestedQuantifier =>
      'Вложенные квантификаторы запрещены, так как могут привести к очень медленной проверке.';

  @override
  String ruleRegexRepetitionTooLarge(int max) {
    return 'Повторы больше $max запрещены.';
  }

  @override
  String get ruleRegexControlCharacters => 'Управляющие символы запрещены.';

  @override
  String get ruleSaved => 'Правило сохранено.';

  @override
  String get ruleDeleted => 'Правило удалено.';

  @override
  String get rulePriorityInvalid =>
      'Приоритет должен быть целым числом от 0 до 100.';

  @override
  String get ruleExampleTitle => 'Пример';

  @override
  String get ruleExampleBody =>
      'Используйте ^ооо\\s+работа\$, чтобы найти организацию «ООО Работа».';

  @override
  String get ruleDeleteTitle => 'Удалить правило?';

  @override
  String get ruleDeleteBody => 'Это правило перестанет блокировать звонки.';

  @override
  String get whitelistTitle => 'Белый список';

  @override
  String get whitelistEmptyTitle => 'Белый список пуст';

  @override
  String get whitelistEmptyBody => 'Номера из белого списка не блокируются.';

  @override
  String get whitelistAdd => 'Добавить номер';

  @override
  String get whitelistPhoneLabel => 'Номер телефона';

  @override
  String get whitelistLabelLabel => 'Метка (необязательно)';

  @override
  String get whitelistPhoneInvalid =>
      'Введите номер телефона, содержащий минимум 5 цифр.';

  @override
  String get whitelistSaved => 'Номер добавлен в белый список.';

  @override
  String get whitelistRemoved => 'Номер удалён из белого списка.';

  @override
  String get whitelistDeleteTitle => 'Удалить номер?';

  @override
  String get whitelistDeleteBody =>
      'Номер больше не будет защищён белым списком.';

  @override
  String get historyTitle => 'Заблокированные звонки';

  @override
  String get historyEmptyTitle => 'Заблокированных звонков нет';

  @override
  String get historyEmptyBody => 'Здесь появится история блокировок.';

  @override
  String get historyToday => 'Сегодня';

  @override
  String get historyFilterEarlier => 'Ранее';

  @override
  String get historyYesterday => 'Вчера';

  @override
  String get historyClear => 'Очистить журнал';

  @override
  String get historyCleared => 'Журнал очищен.';

  @override
  String get historyClearTitle => 'Очистить журнал?';

  @override
  String get historyClearBody =>
      'Все локально сохранённые заблокированные звонки будут удалены.';

  @override
  String get historyUnknownOrganization => 'Неизвестная организация';

  @override
  String historyMatchedRule(String rule) {
    return 'Совпало правило: $rule';
  }

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsAppearanceTitle => 'Внешний вид';

  @override
  String get settingsThemeTitle => 'Тема';

  @override
  String get settingsThemeSystem => 'Системная';

  @override
  String get settingsThemeLight => 'Светлая';

  @override
  String get settingsThemeDark => 'Тёмная';

  @override
  String get settingsFilteringTitle => 'Фильтрация звонков';

  @override
  String get settingsFilteringSubtitle =>
      'Проверять активные правила для входящих звонков.';

  @override
  String get settingsLogTitle => 'Записывать блокировки';

  @override
  String get settingsLogSubtitle =>
      'Хранить локальную историю заблокированных звонков.';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsLanguageSystem => 'Системный';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageRussian => 'Русский';

  @override
  String get settingsPlatformTitle => 'Платформенная интеграция';

  @override
  String get settingsPlatformSync => 'Синхронизировать правила с системой';

  @override
  String get settingsPlatformSynced =>
      'Данные фильтрации переданы платформенному слою.';

  @override
  String get settingsPlatformOpenSettings => 'Открыть системные настройки';

  @override
  String get settingsPlatformUnavailable =>
      'Нативная фильтрация звонков недоступна на этой платформе.';

  @override
  String get settingsPlatformExperimental =>
      'Нативная интеграция экспериментальна и требует проверки на реальном устройстве. Android может не передавать имя звонящего; iOS использует только заранее подготовленные соответствия номеров.';

  @override
  String settingsPlatformError(String message) {
    return 'Ошибка нативной интеграции: $message';
  }

  @override
  String get capabilitiesTitle => 'Возможности';

  @override
  String get capabilityCallScreening => 'Служба фильтрации звонков';

  @override
  String get capabilityCallerName => 'Имя звонящего';

  @override
  String get capabilityCallDirectory => 'Расширение Call Directory';

  @override
  String get capabilityNumberBlocking => 'Блокировка номеров';

  @override
  String get capabilityYes => 'Да';

  @override
  String get capabilityNo => 'Нет';

  @override
  String get capabilityLimited => 'Ограничено';

  @override
  String get settingsAboutTitle => 'О приложении';

  @override
  String get settingsAboutBody =>
      'CallFilter помогает фильтровать нежелательные звонки по названию организации. Настройки и данные хранятся только на этом устройстве.';

  @override
  String get callerCheckTitle => 'Проверка звонящего';

  @override
  String get callerPhoneLabel => 'Номер телефона';

  @override
  String get callerNameLabel => 'Имя звонящего';

  @override
  String get callerPhoneHint => '+7 700 000 00 00';

  @override
  String get callerNameHint => 'ООО Работа';

  @override
  String get callerPhoneInvalid =>
      'Введите номер телефона, содержащий минимум 5 цифр.';

  @override
  String get callerCheckAction => 'Проверить';

  @override
  String get callerBlockedTitle => 'Звонок будет заблокирован';

  @override
  String get callerAllowedTitle => 'Звонок будет разрешён';

  @override
  String callerBlockedBody(String rule, String organization) {
    return 'Совпало правило «$rule» для $organization.';
  }

  @override
  String callerAllowedBody(String reason) {
    return 'Причина: $reason.';
  }

  @override
  String get callerNoRule => 'Совпадений нет.';

  @override
  String get callerWhitelisted => 'Номер находится в белом списке.';

  @override
  String get callerNoName =>
      'Имя звонящего недоступно, поэтому правила по названию нельзя применить.';

  @override
  String get callerFilteringDisabled => 'Фильтрация выключена в настройках.';

  @override
  String get callerInvalidRules =>
      'Не удалось проверить ни одно безопасное правило.';

  @override
  String get callerTimeout => 'Время проверки правил истекло.';

  @override
  String get callerLogged => 'Заблокированный звонок добавлен в журнал.';

  @override
  String get errorGeneric => 'Что-то пошло не так.';

  @override
  String get errorDatabase =>
      'Не удалось получить доступ к локальной базе данных.';

  @override
  String get errorPlatformChannel => 'Платформенная интеграция недоступна.';

  @override
  String get errorRuleNotFound => 'Правило не найдено.';

  @override
  String get unsupportedPlatform => 'Платформа не поддерживается.';
}
