import 'package:get_time_ago/get_time_ago.dart';
import 'package:intl/intl.dart';
import 'package:test/test.dart';

final now = DateTime(2026, 9, 27, 12);
DateTime clock() => now;
DateTime ago(Duration d) => now.subtract(d);
DateTime ahead(Duration d) => now.add(d);

GetTimeAgo at({
  String locale = 'en',
  TimeAgoStyle style = TimeAgoStyle.long,
  TimeUnit maxUnit = TimeUnit.day,
  String? datePattern,
}) => GetTimeAgo(
  locale: locale,
  style: style,
  maxUnit: maxUnit,
  datePattern: datePattern,
  clock: clock,
);

String fullDate(DateTime dt) =>
    DateFormat(GetTimeAgo.defaultDatePattern, 'en').format(dt.toLocal());

void main() {
  tearDown(() => GetTimeAgo.defaults = const GetTimeAgo());

  group('2.x thresholds, unchanged', () {
    final cases = {
      const Duration(seconds: 14): 'just now',
      const Duration(seconds: 15): '15 seconds ago',
      const Duration(seconds: 59): '59 seconds ago',
      const Duration(seconds: 60): 'a minute ago',
      const Duration(minutes: 2): '2 minutes ago',
      const Duration(minutes: 59): '59 minutes ago',
      const Duration(hours: 1): 'an hour ago',
      const Duration(hours: 23): '23 hours ago',
      const Duration(hours: 24): 'a day ago',
      const Duration(hours: 47): 'a day ago',
      const Duration(days: 7, hours: 23): '7 days ago',
    };
    for (final MapEntry(key: d, value: text) in cases.entries) {
      test('$d', () => expect(at().format(ago(d)), text));
    }

    test('8 days falls back to the date', () {
      final dt = ago(const Duration(days: 8));
      expect(at().format(dt), fullDate(dt));
    });
  });

  group('regressions', () {
    test('4.1 (#32): every unit receives its real count', () {
      final seen = <(TimeUnit, int)>[];
      GetTimeAgo.registerLocale('recorder', _Recorder(seen));
      final t = at(locale: 'recorder');
      for (final d in [
        const Duration(seconds: 100),
        const Duration(minutes: 90),
        const Duration(minutes: 150),
        const Duration(hours: 30),
      ]) {
        t.format(ago(d));
      }
      expect(seen, [
        (TimeUnit.minute, 1),
        (TimeUnit.hour, 1),
        (TimeUnit.hour, 2),
        (TimeUnit.day, 1),
      ]);
    });

    test('4.2: a future time no longer loses a unit to latency', () {
      expect(
        at().format(ahead(const Duration(seconds: 60, microseconds: -3))),
        'in a minute',
      );
      expect(at().format(ahead(const Duration(seconds: 14))), 'in 14 seconds');
      expect(at().format(ahead(const Duration(days: 7))), 'in 7 days');
    });

    test('4.3 (#47): a UTC time is shown in local time', () {
      final utc = DateTime.utc(2020, 3, 6, 20, 46, 17);
      expect(
        at().format(utc),
        DateFormat(GetTimeAgo.defaultDatePattern, 'en').format(utc.toLocal()),
      );
    });

    test('4.4: br formats dates in Portuguese, not Breton', () {
      final old = DateTime(2020, 1, 1, 9, 5);
      expect(at(locale: 'br').format(old), at(locale: 'pt').format(old));
      expect(at(locale: 'br').format(old), contains('jan.'));
    });

    test('4.5: Italian and Nepali are reachable', () {
      expect(TimeAgoLocales.it.justNow(TimeAgoStyle.long), 'proprio ora');
      expect(TimeAgoLocales.ne.justNow(TimeAgoStyle.long), 'भर्खरै');
      expect(GetTimeAgo.isSupported('it'), isTrue);
      expect(GetTimeAgo.isSupported('ne'), isTrue);
    });

    group('4.6: plural nouns follow CLDR', () {
      final cases = {
        ('ar', const Duration(seconds: 30), false): 'قبل ٣٠ ثانية',
        ('ar', const Duration(minutes: 11), false): 'قبل ١١ دقيقة',
        ('ar', const Duration(minutes: 25), false): 'قبل ٢٥ دقيقة',
        ('ar', const Duration(hours: 21), false): 'قبل ٢١ ساعة',
        ('ar', const Duration(minutes: 5), false): 'قبل ٥ دقائق',
        ('ar', const Duration(seconds: 5), true): 'بعد ٥ ثوانٍ',
        ('ar', const Duration(seconds: 1), true): 'بعد ثانية واحدة',
        ('ro', const Duration(seconds: 30), false): 'acum 30 de secunde',
        ('ro', const Duration(minutes: 25), false): 'acum 25 de minute',
        ('ro', const Duration(hours: 21), true): 'peste 21 de ore',
        ('ro', const Duration(minutes: 5), false): 'acum 5 minute',
        ('ro', const Duration(seconds: 1), true): 'peste 1 secundă',
        ('en', const Duration(seconds: 1), true): 'in 1 second',
        ('de', const Duration(seconds: 1), true): 'in 1 Sekunde',
        ('es', const Duration(seconds: 1), true): 'en 1 segundo',
        ('fr', const Duration(seconds: 1), true): 'dans 1 seconde',
        ('it', const Duration(seconds: 1), true): 'tra 1 secondo',
        ('nl', const Duration(seconds: 1), true): 'over 1 seconde',
        ('pt', const Duration(seconds: 1), true): 'daqui a 1 segundo',
      };
      for (final MapEntry(key: (locale, d, future), value: text)
          in cases.entries) {
        test('$locale ${future ? '+' : '-'}$d', () {
          expect(at(locale: locale).format(future ? ahead(d) : ago(d)), text);
        });
      }
    });
  });

  group('maxUnit', () {
    String f(int days, TimeUnit max) =>
        at(maxUnit: max).format(ago(Duration(days: days)));

    test('week', () {
      expect(f(6, TimeUnit.week), '6 days ago');
      expect(f(7, TimeUnit.week), 'a week ago');
      expect(f(29, TimeUnit.week), '4 weeks ago');
      expect(f(30, TimeUnit.week), fullDate(ago(const Duration(days: 30))));
    });

    test('month and year', () {
      expect(f(30, TimeUnit.month), 'a month ago');
      expect(f(60, TimeUnit.month), '2 months ago');
      expect(f(364, TimeUnit.month), '11 months ago');
      expect(f(365, TimeUnit.year), 'a year ago');
      expect(f(800, TimeUnit.year), '2 years ago');
      expect(
        at(maxUnit: TimeUnit.year).format(ahead(const Duration(days: 400))),
        'in a year',
      );
    });

    test('other locales take the new units from CLDR', () {
      expect(
        at(
          locale: 'fr',
          maxUnit: TimeUnit.year,
        ).format(ago(const Duration(days: 40))),
        'il y a 1 mois',
      );
      expect(
        at(
          locale: 'hr',
          maxUnit: TimeUnit.week,
        ).format(ago(const Duration(days: 14))),
        'prije 2 tjedna',
      );
    });

    test('Occitan has no weeks yet, so it shows the date', () {
      final dt = ago(const Duration(days: 10));
      expect(at(locale: 'oc', maxUnit: TimeUnit.week).format(dt), fullDate(dt));
    });
  });

  group('styles', () {
    test('short and narrow come from CLDR', () {
      final five = ago(const Duration(minutes: 5));
      expect(at(style: TimeAgoStyle.short).format(five), '5 min. ago');
      expect(at(style: TimeAgoStyle.narrow).format(five), '5m ago');
      expect(
        at(style: TimeAgoStyle.narrow).format(ahead(const Duration(hours: 3))),
        'in 3h',
      );
      expect(
        at(style: TimeAgoStyle.short).format(ago(const Duration(seconds: 3))),
        'now',
      );
    });

    test('a locale without the style falls back to long', () {
      final five = ago(const Duration(minutes: 5));
      expect(
        at(locale: 'oc', style: TimeAgoStyle.narrow).format(five),
        at(locale: 'oc').format(five),
      );
    });

    test('Croatian', () {
      final hr = at(locale: 'hr');
      expect(hr.format(ago(const Duration(minutes: 1))), 'prije 1 minutu');
      expect(hr.format(ago(const Duration(minutes: 22))), 'prije 22 minute');
      expect(hr.format(ahead(const Duration(minutes: 5))), 'za 5 minuta');
      expect(hr.format(ago(const Duration(seconds: 2))), 'sad');
    });

    test('Arabic short style corrects two CLDR mistakes', () {
      final ar = at(
        locale: 'ar',
        style: TimeAgoStyle.short,
        maxUnit: TimeUnit.year,
      );
      expect(ar.format(ago(const Duration(days: 90))), 'قبل ٣ أشهر');
      expect(ar.format(ahead(const Duration(days: 14))), 'خلال أسبوعين');
    });
  });

  group('configuration', () {
    test('defaults drives parse, which can override locale and pattern', () {
      GetTimeAgo.defaults = const GetTimeAgo(locale: 'fr', clock: clock);
      final five = ago(const Duration(minutes: 5));
      expect(GetTimeAgo.parse(five), 'il y a 5 minutes');
      expect(GetTimeAgo.parse(five, locale: 'en'), '5 minutes ago');
      expect(
        GetTimeAgo.parse(
          DateTime(2024, 8, 10, 14, 30),
          pattern: 'yyyy-MM-dd HH:mm',
        ),
        '2024-08-10 14:30',
      );
    });

    test('a global date pattern (#49)', () {
      GetTimeAgo.defaults = const GetTimeAgo(
        datePattern: 'd MMM yyyy',
        clock: clock,
      );
      expect(GetTimeAgo.parse(DateTime(2024, 1, 1)), '1 Jan 2024');
    });

    test('an injected clock (#48)', () {
      final server = GetTimeAgo(clock: () => DateTime(2030));
      expect(server.format(DateTime(2029, 12, 31, 23, 55)), '5 minutes ago');
    });

    test('copyWith, == and hashCode', () {
      final a = at(locale: 'fr');
      expect(a.copyWith(), a);
      expect(a.copyWith().hashCode, a.hashCode);
      expect(a.copyWith(style: TimeAgoStyle.narrow), isNot(a));
      expect(a.copyWith(maxUnit: TimeUnit.year).maxUnit, TimeUnit.year);
    });

    test('supportedLocales lists the built-ins', () {
      expect(GetTimeAgo.supportedLocales, containsAll(['en', 'hr', 'zh_TW']));
    });
  });

  test('the date locale is matched loosely, like locale codes are', () {
    final old = DateTime(2020, 1, 1, 9, 5);
    for (final (code, intlLocale) in [
      ('test-pt-lower', 'pt_br'),
      ('test-pt-hyphen', 'pt-BR'),
    ]) {
      GetTimeAgo.registerLocale(
        code,
        TimeAgoLocales.pt.copyWith(intlLocale: intlLocale),
      );
      expect(at(locale: code).format(old), at(locale: 'pt').format(old));
    }
    GetTimeAgo.registerLocale(
      'test-unknown-intl',
      TimeAgoLocales.en.copyWith(intlLocale: 'xx_YY'),
    );
    expect(at(locale: 'test-unknown-intl').format(old), fullDate(old));
  });

  group('review focus', () {
    test('device locale codes never throw', () {
      final five = ago(const Duration(minutes: 5));
      for (final code in [
        'en_US',
        'pt-PT',
        'zh-Hant-HK',
        'sr_Latn',
        '',
        'xx',
      ]) {
        expect(
          () => at(locale: code).format(five),
          returnsNormally,
          reason: code,
        );
      }
      expect(at(locale: 'zh-Hant-HK').format(five), '5分鐘前');
      expect(at(locale: 'sr_Latn').format(five), '5 minutes ago');
    });

    test('now and a fraction of a second ahead read as just now', () {
      expect(at().format(now), 'just now');
      expect(at().format(ahead(const Duration(milliseconds: 300))), 'just now');
      expect(
        at().format(ahead(const Duration(milliseconds: 600))),
        'in 1 second',
      );
    });

    test('an unknown default locale still formats, in English', () {
      GetTimeAgo.defaults = const GetTimeAgo(locale: 'xx', clock: clock);
      expect(
        GetTimeAgo.parse(ago(const Duration(minutes: 5))),
        '5 minutes ago',
      );
    });

    test('a custom locale with no text falls back to the date', () {
      GetTimeAgo.registerLocale('silent', const _Silent());
      final dt = ago(const Duration(minutes: 5));
      expect(at(locale: 'silent').format(dt), fullDate(dt));
    });

    test('a UTC clock against a local time, and far dates', () {
      final utcClock = GetTimeAgo(clock: now.toUtc);
      expect(utcClock.format(ago(const Duration(minutes: 5))), '5 minutes ago');
      final far = const GetTimeAgo(maxUnit: TimeUnit.year, clock: clock);
      expect(far.format(DateTime(1970)), '56 years ago');
      expect(far.format(DateTime(9999)), startsWith('in '));
    });
  });
}

class _Recorder extends TimeAgoMessages {
  _Recorder(this.seen);

  final List<(TimeUnit, int)> seen;

  @override
  String get intlLocale => 'en';

  @override
  String justNow(TimeAgoStyle style) => 'now';

  @override
  String? relative(
    TimeUnit unit,
    int count, {
    required bool future,
    required TimeAgoStyle style,
  }) {
    seen.add((unit, count));
    return '$count ${unit.name}';
  }
}

class _Silent extends TimeAgoMessages {
  const _Silent();

  @override
  String get intlLocale => 'xx';

  @override
  String justNow(TimeAgoStyle style) => '';

  @override
  String? relative(
    TimeUnit unit,
    int count, {
    required bool future,
    required TimeAgoStyle style,
  }) => null;
}
