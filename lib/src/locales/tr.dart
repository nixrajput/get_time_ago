// Long-style second to day carried over from get_time_ago 2.4.1.
import '../messages/time_ago_locale.dart';
import '../time_unit.dart';
import 'cldr/tr.g.dart';

/// Turkish.
const turkish = TimeAgoLocale(
  intlLocale: 'tr',
  long: TimeAgoPatterns(
    justNow: 'hemen şimdi',
    units: {
      TimeUnit.second: RelativePatterns(
        past: Plural(other: '{0} saniye önce'),
        future: Plural(other: '{0} saniye sonra'),
      ),
      TimeUnit.minute: RelativePatterns(
        past: Plural(one: '1 dakika önce', other: '{0} dakika önce'),
        future: Plural(one: '1 dakika sonra', other: '{0} dakika sonra'),
      ),
      TimeUnit.hour: RelativePatterns(
        past: Plural(one: 'bir saat önce', other: '{0} saat önce'),
        future: Plural(one: 'bir saat sonra', other: '{0} saat sonra'),
      ),
      TimeUnit.day: RelativePatterns(
        past: Plural(one: 'bir gün önce', other: '{0} gün önce'),
        future: Plural(one: 'bir gün sonra', other: '{0} gün sonra'),
      ),
      ...trLongUnits,
    },
  ),
  short: trShort,
  narrow: trNarrow,
);
