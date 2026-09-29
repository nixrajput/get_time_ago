// Long-style second to day carried over from get_time_ago 2.4.1.
import '../messages/time_ago_locale.dart';
import '../time_unit.dart';
import 'cldr/vi.g.dart';

/// Vietnamese.
const vietnamese = TimeAgoLocale(
  intlLocale: 'vi',
  long: TimeAgoPatterns(
    justNow: 'ngay bây giờ',
    units: {
      TimeUnit.second: RelativePatterns(
        past: Plural(other: '{0} giây trước'),
        future: Plural(other: '{0} giây nữa'),
      ),
      TimeUnit.minute: RelativePatterns(
        past: Plural(one: '1 phút trước', other: '{0} phút trước'),
        future: Plural(one: '1 phút nữa', other: '{0} phút nữa'),
      ),
      TimeUnit.hour: RelativePatterns(
        past: Plural(one: '1 giờ trước', other: '{0} giờ trước'),
        future: Plural(one: '1 giờ nữa', other: '{0} giờ nữa'),
      ),
      TimeUnit.day: RelativePatterns(
        past: Plural(one: '1 ngày trước', other: '{0} ngày trước'),
        future: Plural(one: '1 ngày nữa', other: '{0} ngày nữa'),
      ),
      ...viLongUnits,
    },
  ),
  short: viShort,
  narrow: viNarrow,
);
