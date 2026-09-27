// Long-style second to day carried over from get_time_ago 2.4.1.
import '../messages/time_ago_locale.dart';
import '../time_unit.dart';
import 'cldr/id.g.dart';

/// Indonesian.
const indonesian = TimeAgoLocale(
  intlLocale: 'id',
  long: TimeAgoPatterns(
    justNow: 'baru saja',
    units: {
      TimeUnit.second: RelativePatterns(
        past: Plural(other: '{0} detik lalu'),
        future: Plural(other: '{0} detik lagi'),
      ),
      TimeUnit.minute: RelativePatterns(
        past: Plural(one: 'semenit lalu', other: '{0} menit lalu'),
        future: Plural(one: 'semenit lagi', other: '{0} menit lagi'),
      ),
      TimeUnit.hour: RelativePatterns(
        past: Plural(one: 'sejam lalu', other: '{0} jam lalu'),
        future: Plural(one: 'sejam lagi', other: '{0} jam lagi'),
      ),
      TimeUnit.day: RelativePatterns(
        past: Plural(one: 'sehari lalu', other: '{0} hari lalu'),
        future: Plural(one: 'sehari lagi', other: '{0} hari lagi'),
      ),
      ...idLongUnits,
    },
  ),
  short: idShort,
  narrow: idNarrow,
);
