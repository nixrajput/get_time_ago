// Long-style second to day carried over from get_time_ago 2.4.1.
import '../messages/time_ago_locale.dart';
import '../time_unit.dart';
import 'cldr/fa.g.dart';

/// Persian.
const persian = TimeAgoLocale(
  intlLocale: 'fa',
  numerals: Numerals.extendedArabicIndic,
  long: TimeAgoPatterns(
    justNow: 'همین الان',
    units: {
      TimeUnit.second: RelativePatterns(
        past: Plural(other: '\u{202b} {0} ثانیه پیش'),
        future: Plural(other: '\u{202b} {0} ثانیه دیگر'),
      ),
      TimeUnit.minute: RelativePatterns(
        past: Plural(
          one: '\u{202b} یک دقیقه پیش',
          other: '\u{202b} {0} دقیقه پیش',
        ),
        future: Plural(
          one: '\u{202b} یک دقیقه دیگر',
          other: '\u{202b} {0} دقیقه دیگر',
        ),
      ),
      TimeUnit.hour: RelativePatterns(
        past: Plural(
          one: '\u{202b} یک ساعت پیش',
          other: '\u{202b} {0} ساعت پیش',
        ),
        future: Plural(
          one: '\u{202b} یک ساعت دیگر',
          other: '\u{202b} {0} ساعت دیگر',
        ),
      ),
      TimeUnit.day: RelativePatterns(
        past: Plural(one: '\u{202b} یک روز پیش', other: '\u{202b} {0} روز پیش'),
        future: Plural(
          one: '\u{202b} یک روز دیگر',
          other: '\u{202b} {0} روز دیگر',
        ),
      ),
      ...faLongUnits,
    },
  ),
  short: faShort,
  narrow: faNarrow,
);
