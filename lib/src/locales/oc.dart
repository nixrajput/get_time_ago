// Long-style second to day carried over from get_time_ago 2.4.1.
import '../messages/time_ago_locale.dart';
import '../time_unit.dart';

/// Occitan.
const occitan = TimeAgoLocale(
  intlLocale: 'oc',
  long: TimeAgoPatterns(
    justNow: 'just ara',
    units: {
      TimeUnit.second: RelativePatterns(
        past: Plural(other: 'fa {0} segondas'),
        future: Plural(other: 'dins {0} segondas'),
      ),
      TimeUnit.minute: RelativePatterns(
        past: Plural(one: 'fa una minuta', other: 'fa {0} minutas'),
        future: Plural(one: 'dins una minuta', other: 'dins {0} minutas'),
      ),
      TimeUnit.hour: RelativePatterns(
        past: Plural(one: 'fa una ora', other: 'fa {0} oras'),
        future: Plural(one: 'dins una ora', other: 'dins {0} oras'),
      ),
      TimeUnit.day: RelativePatterns(
        past: Plural(one: 'fa un jorn', other: 'fa {0} jors'),
        future: Plural(one: 'dins un jorn', other: 'dins {0} jors'),
      ),
    },
  ),
);
