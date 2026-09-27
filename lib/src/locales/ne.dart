// Long-style second to day carried over from get_time_ago 2.4.1.
import '../messages/time_ago_locale.dart';
import '../time_unit.dart';
import 'cldr/ne.g.dart';

/// Nepali.
const nepali = TimeAgoLocale(
  intlLocale: 'ne',
  long: TimeAgoPatterns(
    justNow: 'भर्खरै',
    units: {
      TimeUnit.second: RelativePatterns(
        past: Plural(other: '{0} सेकेन्ड अघि'),
        future: Plural(other: '{0} सेकेन्ड पछि'),
      ),
      TimeUnit.minute: RelativePatterns(
        past: Plural(one: 'एक मिनेट अघि', other: '{0} मिनेट अघि'),
        future: Plural(one: 'एक मिनेट पछि', other: '{0} मिनेट पछि'),
      ),
      TimeUnit.hour: RelativePatterns(
        past: Plural(one: 'एक घण्टा अघि', other: '{0} घण्टा अघि'),
        future: Plural(one: 'एक घण्टा पछि', other: '{0} घण्टा पछि'),
      ),
      TimeUnit.day: RelativePatterns(
        past: Plural(one: 'एक दिन अघि', other: '{0} दिन अघि'),
        future: Plural(one: 'एक दिन पछि', other: '{0} दिन पछि'),
      ),
      ...neLongUnits,
    },
  ),
  short: neShort,
  narrow: neNarrow,
);
