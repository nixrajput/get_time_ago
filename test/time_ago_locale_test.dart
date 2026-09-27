import 'package:get_time_ago/src/messages/time_ago_locale.dart';
import 'package:get_time_ago/src/time_unit.dart';
import 'package:test/test.dart';

const minute = RelativePatterns(
  past: Plural(
    one: 'prije {0} minutu',
    few: 'prije {0} minute',
    other: 'prije {0} minuta',
  ),
  future: Plural(
    one: 'za {0} minutu',
    few: 'za {0} minute',
    other: 'za {0} minuta',
  ),
);

void main() {
  group('Plural.select follows CLDR plural rules', () {
    test('Croatian one/few/other, including 21 and 22', () {
      final expected = {
        1: 'one',
        2: 'few',
        4: 'few',
        5: 'other',
        11: 'other',
        21: 'one',
        22: 'few',
        25: 'other',
      };
      const p = Plural(one: 'one', few: 'few', other: 'other');
      for (final MapEntry(key: n, value: category) in expected.entries) {
        expect(p.select(n, 'hr'), category, reason: '$n');
      }
    });

    test('Arabic two/few/many', () {
      const p = Plural(
        one: 'one',
        two: 'two',
        few: 'few',
        many: 'many',
        other: 'other',
      );
      expect([1, 2, 3, 10, 11, 99, 100].map((n) => p.select(n, 'ar')), [
        'one',
        'two',
        'few',
        'few',
        'many',
        'many',
        'other',
      ]);
    });

    test('an exact 1 reaches `one` even where CLDR has no one category', () {
      const p = Plural(one: '일분 전', other: '{0}분 전');
      expect(p.select(1, 'ko'), '일분 전');
      expect(p.select(2, 'ko'), '{0}분 전');
    });

    test('a missing category falls back to other', () {
      const p = Plural(one: 'one', other: 'other');
      expect(p.select(3, 'hr'), 'other');
    });
  });

  test('Numerals convert only the digits of the count', () {
    expect(Numerals.latin.format(2024), '2024');
    expect(Numerals.arabicIndic.format(2024), '٢٠٢٤');
    expect(Numerals.extendedArabicIndic.format(2024), '۲۰۲۴');
  });

  group('TimeAgoLocale', () {
    const locale = TimeAgoLocale(
      intlLocale: 'hr',
      long: TimeAgoPatterns(
        justNow: 'upravo',
        units: {TimeUnit.minute: minute},
      ),
      short: TimeAgoPatterns(justNow: 'sad', units: {}),
    );

    String? relative(
      TimeUnit unit,
      int count, {
      bool future = false,
      TimeAgoStyle style = TimeAgoStyle.long,
    }) => locale.relative(unit, count, future: future, style: style);

    test('substitutes the count into the chosen pattern', () {
      expect(relative(TimeUnit.minute, 21), 'prije 21 minutu');
      expect(relative(TimeUnit.minute, 3, future: true), 'za 3 minute');
    });

    test('returns null for a unit or style it lacks', () {
      expect(relative(TimeUnit.week, 1), isNull);
      expect(relative(TimeUnit.minute, 5, style: TimeAgoStyle.short), isNull);
      expect(relative(TimeUnit.minute, 5, style: TimeAgoStyle.narrow), isNull);
    });

    test('justNow falls back to long when a style is missing', () {
      expect(locale.justNow(TimeAgoStyle.short), 'sad');
      expect(locale.justNow(TimeAgoStyle.narrow), 'upravo');
    });

    test('applies its numerals', () {
      const ar = TimeAgoLocale(
        intlLocale: 'ar',
        numerals: Numerals.arabicIndic,
        long: TimeAgoPatterns(
          justNow: 'الآن',
          units: {
            TimeUnit.minute: RelativePatterns(
              past: Plural(other: 'قبل {0} دقيقة'),
              future: Plural(other: 'بعد {0} دقيقة'),
            ),
          },
        ),
      );
      expect(
        ar.relative(
          TimeUnit.minute,
          11,
          future: false,
          style: TimeAgoStyle.long,
        ),
        'قبل ١١ دقيقة',
      );
    });

    test('copyWith replaces only what it is given', () {
      final copy = locale.copyWith(long: locale.long.copyWith(justNow: 'sada'));
      expect(copy.justNow(TimeAgoStyle.long), 'sada');
      expect(
        copy.relative(
          TimeUnit.minute,
          5,
          future: false,
          style: TimeAgoStyle.long,
        ),
        'prije 5 minuta',
      );
      expect(copy.intlLocale, 'hr');
      expect(copy.numerals, Numerals.latin);
    });
  });
}
