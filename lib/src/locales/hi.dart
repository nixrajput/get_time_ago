// Long-style second to day carried over from get_time_ago 2.4.1.
import '../messages/time_ago_locale.dart';
import '../time_unit.dart';
import 'cldr/hi.g.dart';

/// Hindi.
const hindi = TimeAgoLocale(
  intlLocale: 'hi',
  long: TimeAgoPatterns(
    justNow: 'अभी',
    units: {
      TimeUnit.second: RelativePatterns(
        past: Plural(other: '{0} क्षण पहले'),
        future: Plural(other: '{0} क्षण बाद में'),
      ),
      TimeUnit.minute: RelativePatterns(
        past: Plural(one: 'एक मिनट पहले', other: '{0} मिनट पहले'),
        future: Plural(one: 'एक मिनट बाद में', other: '{0} मिनट बाद में'),
      ),
      TimeUnit.hour: RelativePatterns(
        past: Plural(one: 'एक घंटा पहले', other: '{0} घंटे पहले'),
        future: Plural(one: 'एक घंटा बाद में', other: '{0} घंटे बाद में'),
      ),
      TimeUnit.day: RelativePatterns(
        past: Plural(one: 'एक दिन पहले', other: '{0} दिन पहले'),
        future: Plural(one: 'एक दिन बाद में', other: '{0} दिन बाद में'),
      ),
      ...hiLongUnits,
    },
  ),
  short: hiShort,
  narrow: hiNarrow,
);
