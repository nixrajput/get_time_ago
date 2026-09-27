// Long-style second to day carried over from get_time_ago 2.4.1.
import '../messages/time_ago_locale.dart';
import '../time_unit.dart';
import 'cldr/pt.g.dart';

/// Portuguese (Brazil).
const portuguese = TimeAgoLocale(
  intlLocale: 'pt',
  long: TimeAgoPatterns(
    justNow: 'agora mesmo',
    units: {
      TimeUnit.second: RelativePatterns(
        past: Plural(other: 'Há {0} segundos'),
        future: Plural(
          one: 'daqui a {0} segundo',
          other: 'daqui a {0} segundos',
        ),
      ),
      TimeUnit.minute: RelativePatterns(
        past: Plural(one: 'Há um minuto', other: 'Há {0} minutos'),
        future: Plural(one: 'daqui a um minuto', other: 'daqui a {0} minutos'),
      ),
      TimeUnit.hour: RelativePatterns(
        past: Plural(one: 'Há uma hora', other: 'Há {0} horas'),
        future: Plural(one: 'daqui a uma hora', other: 'daqui a {0} horas'),
      ),
      TimeUnit.day: RelativePatterns(
        past: Plural(one: 'Há um dia', other: 'Há {0} dias'),
        future: Plural(one: 'daqui a um dia', other: 'daqui a {0} dias'),
      ),
      ...ptLongUnits,
    },
  ),
  short: ptShort,
  narrow: ptNarrow,
);
