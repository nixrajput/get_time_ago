// Long-style second to day carried over from get_time_ago 2.4.1.
import '../messages/time_ago_locale.dart';
import '../time_unit.dart';
import 'cldr/ko.g.dart';

/// Korean.
const korean = TimeAgoLocale(
  intlLocale: 'ko',
  long: TimeAgoPatterns(
    justNow: '바로 지금',
    units: {
      TimeUnit.second: RelativePatterns(
        past: Plural(other: '{0}초전'),
        future: Plural(other: '{0}초후'),
      ),
      TimeUnit.minute: RelativePatterns(
        past: Plural(one: '일분전', other: '{0}분전'),
        future: Plural(one: '일분후', other: '{0}분후'),
      ),
      TimeUnit.hour: RelativePatterns(
        past: Plural(one: '한시간전', other: '{0}시간전'),
        future: Plural(one: '한시간후', other: '{0}시간후'),
      ),
      TimeUnit.day: RelativePatterns(
        past: Plural(one: '하루전', other: '{0}일전'),
        future: Plural(one: '하루후', other: '{0}일후'),
      ),
      ...koLongUnits,
    },
  ),
  short: koShort,
  narrow: koNarrow,
);
