// Long-style second to day carried over from get_time_ago 2.4.1.
import '../messages/time_ago_locale.dart';
import '../time_unit.dart';
import 'cldr/fr.g.dart';

/// French.
const french = TimeAgoLocale(
  intlLocale: 'fr',
  long: TimeAgoPatterns(
    justNow: 'en ce moment',
    units: {
      TimeUnit.second: RelativePatterns(
        past: Plural(other: 'il y a {0} secondes'),
        future: Plural(one: 'dans {0} seconde', other: 'dans {0} secondes'),
      ),
      TimeUnit.minute: RelativePatterns(
        past: Plural(one: 'il y a une minute', other: 'il y a {0} minutes'),
        future: Plural(one: 'dans une minute', other: 'dans {0} minutes'),
      ),
      TimeUnit.hour: RelativePatterns(
        past: Plural(one: 'il y a une heure', other: 'il y a {0} heures'),
        future: Plural(one: 'dans une heure', other: 'dans {0} heures'),
      ),
      TimeUnit.day: RelativePatterns(
        past: Plural(one: 'il y a un jour', other: 'il y a {0} jours'),
        future: Plural(one: 'dans un jour', other: 'dans {0} jours'),
      ),
      ...frLongUnits,
    },
  ),
  short: frShort,
  narrow: frNarrow,
);
