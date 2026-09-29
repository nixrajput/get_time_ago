import '../messages/time_ago_locale.dart';
import 'cldr/hr.g.dart';

/// Croatian, entirely from CLDR.
const croatian = TimeAgoLocale(
  intlLocale: 'hr',
  long: hrLong,
  short: hrShort,
  narrow: hrNarrow,
);
