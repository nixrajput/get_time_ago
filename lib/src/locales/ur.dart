// Long-style second to day carried over from get_time_ago 2.4.1.
import '../messages/time_ago_locale.dart';
import '../time_unit.dart';
import 'cldr/ur.g.dart';

/// Urdu.
const urdu = TimeAgoLocale(
  intlLocale: 'ur',
  numerals: Numerals.extendedArabicIndic,
  long: TimeAgoPatterns(
    justNow: 'ابھی',
    units: {
      TimeUnit.second: RelativePatterns(
        past: Plural(other: '\u{202b} {0} سیکنڈ پہلے'),
        future: Plural(other: '\u{202b} {0} سیکنڈ بعد'),
      ),
      TimeUnit.minute: RelativePatterns(
        past: Plural(
          one: '\u{202b} ایک منٹ پہلے',
          other: '\u{202b} {0} منٹ پہلے',
        ),
        future: Plural(
          one: '\u{202b} ایک منٹ بعد',
          other: '\u{202b} {0} منٹ بعد',
        ),
      ),
      TimeUnit.hour: RelativePatterns(
        past: Plural(
          one: '\u{202b} ایک گھنٹہ پہلے',
          other: '\u{202b} {0} گھنٹے پہلے',
        ),
        future: Plural(
          one: '\u{202b} ایک گھنٹہ بعد',
          other: '\u{202b} {0} گھنٹے بعد',
        ),
      ),
      TimeUnit.day: RelativePatterns(
        past: Plural(
          one: '\u{202b} ایک دن پہلے',
          other: '\u{202b} {0} دن پہلے',
        ),
        future: Plural(
          one: '\u{202b} ایک دن بعد',
          other: '\u{202b} {0} دن بعد',
        ),
      ),
      ...urLongUnits,
    },
  ),
  short: urShort,
  narrow: urNarrow,
);
