// Long-style second to day carried over from get_time_ago 2.4.1.
import '../messages/time_ago_locale.dart';
import '../time_unit.dart';
import 'cldr/de.g.dart';

/// German.
const german = TimeAgoLocale(
  intlLocale: 'de',
  long: TimeAgoPatterns(
    justNow: 'gerade eben',
    units: {
      TimeUnit.second: RelativePatterns(
        past: Plural(other: 'vor {0} Sekunden'),
        future: Plural(one: 'in {0} Sekunde', other: 'in {0} Sekunden'),
      ),
      TimeUnit.minute: RelativePatterns(
        past: Plural(one: 'vor einer Minute', other: 'vor {0} Minuten'),
        future: Plural(one: 'in einer Minute', other: 'in {0} Minuten'),
      ),
      TimeUnit.hour: RelativePatterns(
        past: Plural(one: 'vor einer Stunde', other: 'vor {0} Stunden'),
        future: Plural(one: 'in einer Stunde', other: 'in {0} Stunden'),
      ),
      TimeUnit.day: RelativePatterns(
        past: Plural(one: 'vor einem Tag', other: 'vor {0} Tagen'),
        future: Plural(one: 'in einem Tag', other: 'in {0} Tagen'),
      ),
      ...deLongUnits,
    },
  ),
  short: deShort,
  narrow: deNarrow,
);
