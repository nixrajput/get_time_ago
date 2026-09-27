// Long-style second to day carried over from get_time_ago 2.4.1.
import '../messages/time_ago_locale.dart';
import '../time_unit.dart';
import 'cldr/zh.g.dart';

/// Chinese, Simplified script.
const chineseSimplified = TimeAgoLocale(
  intlLocale: 'zh',
  long: TimeAgoPatterns(
    justNow: '刚才',
    units: {
      TimeUnit.second: RelativePatterns(
        past: Plural(other: '{0}秒前'),
        future: Plural(other: '{0}秒后'),
      ),
      TimeUnit.minute: RelativePatterns(
        past: Plural(one: '1分钟前', other: '{0}分钟前'),
        future: Plural(one: '1分钟后', other: '{0}分钟后'),
      ),
      TimeUnit.hour: RelativePatterns(
        past: Plural(one: '1小时前', other: '{0}小时前'),
        future: Plural(one: '1小时后', other: '{0}小时后'),
      ),
      TimeUnit.day: RelativePatterns(
        past: Plural(one: '1天前', other: '{0}天前'),
        future: Plural(one: '1天后', other: '{0}天后'),
      ),
      ...zhLongUnits,
    },
  ),
  short: zhShort,
  narrow: zhNarrow,
);
