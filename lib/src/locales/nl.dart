// Long-style second to day carried over from get_time_ago 2.4.1.
import '../messages/time_ago_locale.dart';
import '../time_unit.dart';
import 'cldr/nl.g.dart';

/// Dutch.
const dutch = TimeAgoLocale(
  intlLocale: 'nl',
  long: TimeAgoPatterns(
    justNow: 'zojuist',
    units: {
      TimeUnit.second: RelativePatterns(
        past: Plural(other: '{0} seconden geleden'),
        future: Plural(one: 'over {0} seconde', other: 'over {0} seconden'),
      ),
      TimeUnit.minute: RelativePatterns(
        past: Plural(one: 'een minuut geleden', other: '{0} minuten geleden'),
        future: Plural(one: 'over een minuut', other: 'over {0} minuten'),
      ),
      TimeUnit.hour: RelativePatterns(
        past: Plural(one: 'een uur geleden', other: '{0} uur geleden'),
        future: Plural(one: 'over een uur', other: 'over {0} uur'),
      ),
      TimeUnit.day: RelativePatterns(
        past: Plural(one: 'een dag geleden', other: '{0} dagen geleden'),
        future: Plural(one: 'over een dag', other: 'over {0} dagen'),
      ),
      ...nlLongUnits,
    },
  ),
  short: nlShort,
  narrow: nlNarrow,
);
