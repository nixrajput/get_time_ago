// Long-style second to day carried over from get_time_ago 2.4.1.
import '../messages/time_ago_locale.dart';
import '../time_unit.dart';
import 'cldr/it.g.dart';

/// Italian.
const italian = TimeAgoLocale(
  intlLocale: 'it',
  long: TimeAgoPatterns(
    justNow: 'proprio ora',
    units: {
      TimeUnit.second: RelativePatterns(
        past: Plural(other: '{0} secondi fa'),
        future: Plural(one: 'tra {0} secondo', other: 'tra {0} secondi'),
      ),
      TimeUnit.minute: RelativePatterns(
        past: Plural(one: 'un minuto fa', other: '{0} minuti fa'),
        future: Plural(one: 'tra un minuto', other: 'tra {0} minuti'),
      ),
      TimeUnit.hour: RelativePatterns(
        past: Plural(one: 'un\'ora fa', other: '{0} ore fa'),
        future: Plural(one: 'tra un\'ora', other: 'tra {0} ore'),
      ),
      TimeUnit.day: RelativePatterns(
        past: Plural(one: 'un giorno fa', other: '{0} giorni fa'),
        future: Plural(one: 'tra un giorno', other: 'tra {0} giorni'),
      ),
      ...itLongUnits,
    },
  ),
  short: itShort,
  narrow: itNarrow,
);
