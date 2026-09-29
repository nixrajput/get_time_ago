// Long-style second to day carried over from get_time_ago 2.4.1.
import '../messages/time_ago_locale.dart';
import '../time_unit.dart';
import 'cldr/zh_tw.g.dart';

/// Chinese, Traditional script.
const chineseTraditional = TimeAgoLocale(
  intlLocale: 'zh_TW',
  long: TimeAgoPatterns(
    justNow: '現在',
    units: {
      TimeUnit.second: RelativePatterns(
        past: Plural(other: '{0}秒前'),
        future: Plural(other: '{0}秒後'),
      ),
      TimeUnit.minute: RelativePatterns(
        past: Plural(one: '1分鐘前', other: '{0}分鐘前'),
        future: Plural(one: '1分鐘後', other: '{0}分鐘後'),
      ),
      TimeUnit.hour: RelativePatterns(
        past: Plural(one: '1小時前', other: '{0}小時前'),
        future: Plural(one: '1小時後', other: '{0}小時後'),
      ),
      TimeUnit.day: RelativePatterns(
        past: Plural(one: '1天前', other: '{0}天前'),
        future: Plural(one: '1天後', other: '{0}天後'),
      ),
      ...zhTwLongUnits,
    },
  ),
  short: zhTwShort,
  narrow: zhTwNarrow,
);
