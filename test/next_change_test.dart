import 'package:get_time_ago/get_time_ago.dart';
import 'package:test/test.dart';

final now = DateTime(2026, 9, 27, 12);

void main() {
  test('exact values around the half-second rounding boundary', () {
    final t = GetTimeAgo(clock: () => now);
    expect(
      t.nextChange(now.subtract(const Duration(minutes: 5))),
      const Duration(seconds: 59, milliseconds: 500),
    );
    expect(
      t.nextChange(now.add(const Duration(minutes: 5))),
      const Duration(microseconds: 500001),
    );
    expect(t.nextChange(now), const Duration(seconds: 14, milliseconds: 500));
  });

  test('a past date never changes again', () {
    expect(
      GetTimeAgo(
        clock: () => now,
      ).nextChange(now.subtract(const Duration(days: 30))),
      isNull,
    );
  });

  test('a future date changes when it enters the relative window', () {
    final t = GetTimeAgo(clock: () => now);
    final dt = now.add(const Duration(days: 10));
    final wait = t.nextChange(dt)!;
    expect(GetTimeAgo(clock: () => now.add(wait)).format(dt), 'in 7 days');
  });

  group('text that can never change again returns null, not a hang', () {
    // Registered once; these codes are unique to this file.
    final en = TimeAgoLocales.en;
    GetTimeAgo.registerLocale(
      'test-days-only',
      en.copyWith(
        long: en.long.copyWith(
          units: {
            for (final MapEntry(:key, :value) in en.long.units.entries)
              if (key.index <= TimeUnit.day.index) key: value,
          },
        ),
      ),
    );
    GetTimeAgo.registerLocale(
      'test-flat-year',
      en.copyWith(
        long: en.long.copyWith(
          units: {
            ...en.long.units,
            TimeUnit.year: const RelativePatterns(
              past: Plural(other: 'over a year ago'),
              future: Plural(other: 'in over a year'),
            ),
          },
        ),
      ),
    );

    for (final (locale, days) in [
      ('oc', 10),
      ('oc', 400),
      ('test-days-only', 10),
      ('test-days-only', 400),
      ('test-flat-year', 400),
      ('test-flat-year', 4000),
    ]) {
      test('$locale, $days days ago, maxUnit year', () {
        final t = GetTimeAgo(
          locale: locale,
          maxUnit: TimeUnit.year,
          clock: () => now,
        );
        expect(t.nextChange(now.subtract(Duration(days: days))), isNull);
      });
    }
  });

  final offsets = <Duration>[
    for (final s in [
      0,
      3,
      14,
      15,
      16,
      59,
      60,
      61,
      119,
      3599,
      3600,
      86399,
      86400,
      86400 * 6 + 5,
      86400 * 29,
      86400 * 200,
      86400 * 400,
    ])
      for (final sign in [1, -1])
        Duration(seconds: s * sign, milliseconds: 137 * sign),
  ];

  for (final (locale, style, max) in [
    ('en', TimeAgoStyle.long, TimeUnit.day),
    ('en', TimeAgoStyle.narrow, TimeUnit.year),
    ('ar', TimeAgoStyle.long, TimeUnit.month),
    ('oc', TimeAgoStyle.long, TimeUnit.week),
    ('oc', TimeAgoStyle.long, TimeUnit.year),
    ('test-days-only', TimeAgoStyle.long, TimeUnit.year),
    ('test-flat-year', TimeAgoStyle.long, TimeUnit.year),
    ('hr', TimeAgoStyle.short, TimeUnit.year),
  ]) {
    test(
      'the text changes exactly at nextChange: $locale ${style.name} ${max.name}',
      () {
        GetTimeAgo at(DateTime instant) => GetTimeAgo(
          locale: locale,
          style: style,
          maxUnit: max,
          clock: () => instant,
        );
        for (final offset in offsets) {
          final dt = now.subtract(offset);
          final text = at(now).format(dt);
          final wait = at(now).nextChange(dt);
          if (wait == null) {
            expect(
              at(now.add(const Duration(days: 3650))).format(dt),
              text,
              reason: '$offset should never change',
            );
            continue;
          }
          expect(wait, greaterThan(Duration.zero), reason: '$offset');
          expect(
            at(now.add(wait - const Duration(microseconds: 1))).format(dt),
            text,
            reason: '$offset just before',
          );
          expect(
            at(now.add(wait)).format(dt),
            isNot(text),
            reason: '$offset at',
          );
        }
      },
    );
  }
}
