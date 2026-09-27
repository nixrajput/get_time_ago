// Long-style second to day carried over from get_time_ago 2.4.1.
import '../messages/time_ago_locale.dart';
import '../time_unit.dart';
import 'cldr/ja.g.dart';

/// Japanese.
const japanese = TimeAgoLocale(
  intlLocale: 'ja',
  long: TimeAgoPatterns(
    justNow: 'たった今',
    units: {
      TimeUnit.second: RelativePatterns(
        past: Plural(other: '{0}秒前'),
        future: Plural(other: '{0}秒後'),
      ),
      TimeUnit.minute: RelativePatterns(
        past: Plural(one: '1分前', other: '{0}分前'),
        future: Plural(one: '1分後', other: '{0}分後'),
      ),
      TimeUnit.hour: RelativePatterns(
        past: Plural(one: '1時間前', other: '{0}時間前'),
        future: Plural(one: '1時間後', other: '{0}時間後'),
      ),
      TimeUnit.day: RelativePatterns(
        past: Plural(one: '1日前', other: '{0}日前'),
        future: Plural(one: '1日後', other: '{0}日後'),
      ),
      ...jaLongUnits,
    },
  ),
  short: jaShort,
  narrow: jaNarrow,
);
