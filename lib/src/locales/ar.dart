import '../messages/time_ago_locale.dart';
import 'cldr/ar.g.dart';

/// Arabic.
///
/// Long style is CLDR's, because 2.x used one plural form for every count;
/// the future keeps 2.x's wording, بعد.
const arabic = TimeAgoLocale(
  intlLocale: 'ar',
  numerals: Numerals.arabicIndic,
  long: arLong,
  short: arShort,
  narrow: arNarrow,
);
