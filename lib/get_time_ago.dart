/// Relative time for Dart and Flutter: "just now", "5 minutes ago",
/// "in 3 days".
///
/// Use [GetTimeAgo.parse] for a one-liner, or build a [GetTimeAgo] to choose
/// the locale, style, largest unit, date pattern and clock.
library;

export 'src/get_time_ago.dart' show GetTimeAgo;
export 'src/locales/registry.dart' show TimeAgoLocales;
export 'src/messages/time_ago_locale.dart'
    show Numerals, Plural, RelativePatterns, TimeAgoLocale, TimeAgoPatterns;
export 'src/messages/time_ago_messages.dart' show TimeAgoMessages;
export 'src/time_unit.dart' show TimeAgoStyle, TimeUnit;
