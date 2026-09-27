// Long-style second to day carried over from get_time_ago 2.4.1.
import '../messages/time_ago_locale.dart';
import '../time_unit.dart';
import 'cldr/ro.g.dart';

/// Romanian.
const romanian = TimeAgoLocale(
  intlLocale: 'ro',
  long: TimeAgoPatterns(
    justNow: 'tocmai acum',
    units: {
      TimeUnit.second: RelativePatterns(
        past: Plural(few: 'acum {0} secunde', other: 'acum {0} de secunde'),
        future: Plural(
          one: 'peste {0} secundă',
          few: 'peste {0} secunde',
          other: 'peste {0} de secunde',
        ),
      ),
      TimeUnit.minute: RelativePatterns(
        past: Plural(
          one: 'acum un minut',
          few: 'acum {0} minute',
          other: 'acum {0} de minute',
        ),
        future: Plural(
          one: 'peste un minut',
          few: 'peste {0} minute',
          other: 'peste {0} de minute',
        ),
      ),
      TimeUnit.hour: RelativePatterns(
        past: Plural(
          one: 'acum o oră',
          few: 'acum {0} ore',
          other: 'acum {0} de ore',
        ),
        future: Plural(
          one: 'peste o oră',
          few: 'peste {0} ore',
          other: 'peste {0} de ore',
        ),
      ),
      TimeUnit.day: RelativePatterns(
        past: Plural(one: 'acum o zi', other: 'acum {0} zile'),
        future: Plural(one: 'peste o zi', other: 'peste {0} zile'),
      ),
      ...roLongUnits,
    },
  ),
  short: roShort,
  narrow: roNarrow,
);
