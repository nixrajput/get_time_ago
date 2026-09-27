// Long-style second to day carried over from get_time_ago 2.4.1.
import '../messages/time_ago_locale.dart';
import '../time_unit.dart';
import 'cldr/en.g.dart';

/// English.
const english = TimeAgoLocale(
  intlLocale: 'en',
  long: TimeAgoPatterns(
    justNow: 'just now',
    units: {
      TimeUnit.second: RelativePatterns(
        past: Plural(other: '{0} seconds ago'),
        future: Plural(one: 'in {0} second', other: 'in {0} seconds'),
      ),
      TimeUnit.minute: RelativePatterns(
        past: Plural(one: 'a minute ago', other: '{0} minutes ago'),
        future: Plural(one: 'in a minute', other: 'in {0} minutes'),
      ),
      TimeUnit.hour: RelativePatterns(
        past: Plural(one: 'an hour ago', other: '{0} hours ago'),
        future: Plural(one: 'in an hour', other: 'in {0} hours'),
      ),
      TimeUnit.day: RelativePatterns(
        past: Plural(one: 'a day ago', other: '{0} days ago'),
        future: Plural(one: 'in a day', other: 'in {0} days'),
      ),
      TimeUnit.week: RelativePatterns(
        past: Plural(one: 'a week ago', other: '{0} weeks ago'),
        future: Plural(one: 'in a week', other: 'in {0} weeks'),
      ),
      TimeUnit.month: RelativePatterns(
        past: Plural(one: 'a month ago', other: '{0} months ago'),
        future: Plural(one: 'in a month', other: 'in {0} months'),
      ),
      TimeUnit.year: RelativePatterns(
        past: Plural(one: 'a year ago', other: '{0} years ago'),
        future: Plural(one: 'in a year', other: 'in {0} years'),
      ),
    },
  ),
  short: enShort,
  narrow: enNarrow,
);
