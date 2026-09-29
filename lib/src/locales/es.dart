// Long-style second to day carried over from get_time_ago 2.4.1.
import '../messages/time_ago_locale.dart';
import '../time_unit.dart';
import 'cldr/es.g.dart';

/// Spanish.
const spanish = TimeAgoLocale(
  intlLocale: 'es',
  long: TimeAgoPatterns(
    justNow: 'hace poco',
    units: {
      TimeUnit.second: RelativePatterns(
        past: Plural(other: 'hace {0} segundos'),
        future: Plural(one: 'en {0} segundo', other: 'en {0} segundos'),
      ),
      TimeUnit.minute: RelativePatterns(
        past: Plural(one: 'hace un minuto', other: 'hace {0} minutos'),
        future: Plural(one: 'en un minuto', other: 'en {0} minutos'),
      ),
      TimeUnit.hour: RelativePatterns(
        past: Plural(one: 'hace una hora', other: 'hace {0} horas'),
        future: Plural(one: 'en una hora', other: 'en {0} horas'),
      ),
      TimeUnit.day: RelativePatterns(
        past: Plural(one: 'hace un día', other: 'hace {0} días'),
        future: Plural(one: 'en un día', other: 'en {0} días'),
      ),
      ...esLongUnits,
    },
  ),
  short: esShort,
  narrow: esNarrow,
);
