import 'dart:ui';

import 'package:blockchain_wallet/common/util/local_storage.dart';
import 'package:blockchain_wallet/common/util/logger.dart';
import 'package:blockchain_wallet/generated/l10n.dart';
import 'package:blockchain_wallet/global.dart';
import 'package:get/get.dart';

class AppPreferences {
  AppPreferences._();

  static const _kBackedUpMnemonic = 'BackedUpMnemonic';
  static const _kLanguageTag = 'LanguageTag';

  ///默认中文语言
  static const _defaultLocale =
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN');

  final _storage = LocalStorage('AppPreferences');

  ///是否已备份助记词
  var _isBackedUpMnemonic = false;

  ///当前使用的语言
  Locale? _locale;

  static Future<AppPreferences> create() async {
    logger.d('Get.deviceLocale:${Get.deviceLocale?.toLanguageTag()}');
    return AppPreferences._().._init();
  }

  Future<void> _init() async {
    _isBackedUpMnemonic = await _storage.getBool(_kBackedUpMnemonic) ?? false;

    var languageTag = await _storage.getString(_kLanguageTag);
    languageTag ??= Get.deviceLocale?.toLanguageTag();
    _locale = supportedLocales
        .firstWhereOrNull((element) => element.toLanguageTag() == languageTag);
    _locale ??= _defaultLocale;
  }

  Future<void> setBackedUpMnemonic(bool isBackedUp) async {
    await _storage.setBool(_kBackedUpMnemonic, isBackedUp);
    _isBackedUpMnemonic = isBackedUp;
  }

  ///是否已备份助记词
  bool get isBackedUpMnemonic => _isBackedUpMnemonic;

  ///支持的本地化语言
  List<Locale> get supportedLocales => S.delegate.supportedLocales;

  ///当前使用的语言
  Locale? get locale => _locale;

  ///更改使用的语言
  Future<void> updateLocale(Locale locale) async {
    if (_locale?.toLanguageTag() != locale.toLanguageTag()) {
      _locale = locale;
      await _storage.setString(_kLanguageTag, locale.toLanguageTag());
      await Get.updateLocale(locale);
    }
  }
}

enum AppLanguageEnum {
  zh(Locale('zh', 'CN'), '中文'),
  en(Locale('en'), 'English');

  final Locale locale;
  final String label;

  const AppLanguageEnum(this.locale, this.label);

  static AppLanguageEnum? fromLocale(Locale locale) {
    return AppLanguageEnum.values
        .firstWhereOrNull((e) => e.locale.languageCode == locale.languageCode);
  }

}
