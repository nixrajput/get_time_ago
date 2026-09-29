import 'package:get_time_ago/src/locales/registry.dart';
import 'package:get_time_ago/src/messages/time_ago_locale.dart';
import 'package:get_time_ago/src/time_unit.dart';
import 'package:test/test.dart';

void main() {
  test('22 built-in locales, canonically spelled', () {
    expect(localeCodes(), [
      'ar', 'de', 'en', 'es', 'fa', 'fr', 'hi', 'hr', 'id', 'it', 'ja', //
      'ko', 'ne', 'nl', 'oc', 'pt', 'ro', 'tr', 'ur', 'vi', 'zh', 'zh_TW',
    ]);
  });

  group('lookupMessages', () {
    test('is loose about case and separators', () {
      expect(lookupMessages('zh-tw'), same(TimeAgoLocales.zhTW));
      expect(lookupMessages('ZH_TW'), same(TimeAgoLocales.zhTW));
    });

    test('keeps the 2.x keys as aliases (4.4)', () {
      expect(lookupMessages('br'), same(TimeAgoLocales.pt));
      expect(lookupMessages('zh_tr'), same(TimeAgoLocales.zhTW));
    });

    test('falls back from region and script to the language', () {
      expect(lookupMessages('en_US'), same(TimeAgoLocales.en));
      expect(lookupMessages('pt-PT'), same(TimeAgoLocales.pt));
      expect(lookupMessages('pt_BR'), same(TimeAgoLocales.pt));
      expect(lookupMessages('zh_Hans_CN'), same(TimeAgoLocales.zh));
    });

    test(
      'puts Hong Kong and Macau in Traditional script (CLDR likely subtags)',
      () {
        expect(lookupMessages('zh_HK'), same(TimeAgoLocales.zhTW));
        expect(lookupMessages('zh-Hant-HK'), same(TimeAgoLocales.zhTW));
        expect(lookupMessages('zh_MO'), same(TimeAgoLocales.zhTW));
      },
    );

    test('returns null for codes it cannot place', () {
      expect(lookupMessages('sr_Latn'), isNull);
      expect(lookupMessages(''), isNull);
      expect(lookupMessages('_'), isNull);
    });
  });

  test('registerMessages adds and overrides, matched loosely', () {
    const custom = TimeAgoLocale(
      intlLocale: 'en',
      long: TimeAgoPatterns(justNow: 'now-ish', units: {}),
    );
    registerMessages('EN-gb', custom);
    expect(lookupMessages('en_GB'), same(custom));
    expect(lookupMessages('en'), same(TimeAgoLocales.en));
    expect(localeCodes(), contains('EN-gb'));
    expect(custom.justNow(TimeAgoStyle.long), 'now-ish');
  });

  test(
    'registering under an alias code overrides what the alias resolves to',
    () {
      const breton = TimeAgoLocale(
        intlLocale: 'pt',
        long: TimeAgoPatterns(justNow: 'registered br', units: {}),
      );
      const hongKong = TimeAgoLocale(
        intlLocale: 'zh_HK',
        long: TimeAgoPatterns(justNow: 'registered zh_HK', units: {}),
      );
      registerMessages('br', breton);
      registerMessages('zh_HK', hongKong);
      expect(lookupMessages('br'), same(breton));
      expect(lookupMessages('zh-hk'), same(hongKong));
      // The canonical codes keep their built-ins.
      expect(lookupMessages('pt'), same(TimeAgoLocales.pt));
      expect(lookupMessages('zh_TW'), same(TimeAgoLocales.zhTW));
    },
  );

  test('an override of a canonical code reaches its aliases', () {
    const chinese = TimeAgoLocale(
      intlLocale: 'zh',
      long: TimeAgoPatterns(justNow: 'registered zh', units: {}),
    );
    registerMessages('zh', chinese);
    expect(lookupMessages('zh_CN'), same(chinese));
    expect(lookupMessages('zh-Hans'), same(chinese));
  });
}
