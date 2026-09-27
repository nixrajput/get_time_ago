import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'elapsed.dart';
import 'locales/registry.dart';
import 'messages/time_ago_messages.dart';
import 'time_unit.dart';

/// Formats a [DateTime] relative to now, such as "5 minutes ago" or
/// "in 3 days".
///
/// Immutable and const-constructible, so one instance can be shared, compared
/// and held by a widget. For a one-liner, use [GetTimeAgo.parse].
///
/// ```dart
/// const timeAgo = GetTimeAgo(locale: 'fr', maxUnit: TimeUnit.year);
/// timeAgo.format(DateTime.now().subtract(const Duration(days: 40)));
/// // il y a 1 mois
/// ```
class GetTimeAgo {
  /// Creates a formatter. Every default reproduces 2.x output.
  const GetTimeAgo({
    this.locale = 'en',
    this.style = TimeAgoStyle.long,
    this.maxUnit = TimeUnit.day,
    this.datePattern,
    this.clock,
  });

  /// The locale code, such as `en`, `pt-BR` or `zh_TW`.
  ///
  /// Matching is loose: case and `-`/`_` do not matter, and a region or script
  /// falls back to its language. A code with no match falls back to
  /// [defaults]' locale, then to English, so formatting never throws for an
  /// unknown locale. Use [isSupported] to check one.
  final String locale;

  /// How much room the text may take.
  final TimeAgoStyle style;

  /// The largest unit to use before showing the full date.
  ///
  /// [TimeUnit.day] shows up to "7 days ago" and then the date, as 2.x did.
  /// [TimeUnit.year] never shows the date. Units below [TimeUnit.day] behave
  /// like [TimeUnit.day].
  final TimeUnit maxUnit;

  /// The `intl` date pattern for times beyond [maxUnit]. `null` uses
  /// [defaultDatePattern].
  final String? datePattern;

  /// Where "now" comes from. `null` uses [DateTime.now].
  ///
  /// Pass a server-corrected clock when device time cannot be trusted, or a
  /// fixed one in tests.
  final DateTime Function()? clock;

  /// The date pattern used when [datePattern] is `null`: `01 Jan, 2024 09:05 AM`.
  static const defaultDatePattern = 'dd MMM, yyyy hh:mm aa';

  /// The configuration [parse] uses. Assign a new one to change it app-wide.
  static GetTimeAgo defaults = const GetTimeAgo();

  /// Formats [dateTime] with [defaults], optionally overriding its locale and
  /// its date [pattern].
  static String parse(DateTime dateTime, {String? locale, String? pattern}) =>
      defaults.copyWith(locale: locale, datePattern: pattern).format(dateTime);

  /// Makes [code] available to [locale]. A built-in code, such as `en`, is
  /// overridden.
  static void registerLocale(String code, TimeAgoMessages messages) =>
      registerMessages(code, messages);

  /// Whether [code] resolves to a bundled or registered locale, directly or
  /// through its language.
  static bool isSupported(String code) => lookupMessages(code) != null;

  /// Every bundled and registered locale code.
  static Iterable<String> get supportedLocales => localeCodes();

  static var _dateSymbolsLoaded = false;

  /// [dateTime] relative to [clock], in [locale] and [style].
  String format(DateTime dateTime) {
    final messages = _messages;
    final seconds = roundSeconds(_now().difference(dateTime).inMicroseconds);
    return _text(seconds, messages, () => _date(dateTime, messages));
  }

  /// How long until [format] returns different text for [dateTime], or `null`
  /// if it never will: a past time already shown as a date.
  ///
  /// Lets a widget schedule one timer per change instead of ticking on a fixed
  /// interval.
  Duration? nextChange(DateTime dateTime) {
    final messages = _messages;
    final elapsed = _now().difference(dateTime).inMicroseconds;
    String? date;
    String render(int seconds) =>
        _text(seconds, messages, () => date ??= _date(dateTime, messages));
    final current = roundSeconds(elapsed);
    final text = render(current);
    var next = current;
    // ponytail: gives up after 1000 candidates, over 900 years of year steps,
    // so text that never changes (a locale with no years) returns null.
    for (var i = 0; i < 1000; i++) {
      final candidate = nextCandidate(next, maxUnit);
      if (candidate == null) return null;
      next = candidate;
      if (render(next) != text) {
        return Duration(microseconds: firstMicrosAt(next) - elapsed);
      }
    }
    return null;
  }

  /// A copy with the given fields replaced.
  GetTimeAgo copyWith({
    String? locale,
    TimeAgoStyle? style,
    TimeUnit? maxUnit,
    String? datePattern,
    DateTime Function()? clock,
  }) => GetTimeAgo(
    locale: locale ?? this.locale,
    style: style ?? this.style,
    maxUnit: maxUnit ?? this.maxUnit,
    datePattern: datePattern ?? this.datePattern,
    clock: clock ?? this.clock,
  );

  @override
  bool operator ==(Object other) =>
      other is GetTimeAgo &&
      other.locale == locale &&
      other.style == style &&
      other.maxUnit == maxUnit &&
      other.datePattern == datePattern &&
      other.clock == clock;

  @override
  int get hashCode => Object.hash(locale, style, maxUnit, datePattern, clock);

  DateTime _now() => (clock ?? DateTime.now)();

  TimeAgoMessages get _messages =>
      lookupMessages(locale) ??
      lookupMessages(defaults.locale) ??
      lookupMessages('en')!;

  String _text(int seconds, TimeAgoMessages messages, String Function() date) {
    if (seconds >= 0 && seconds < justNowSeconds) {
      return messages.justNow(style);
    }
    final unit = unitFor(seconds.abs(), maxUnit);
    if (unit == null) return date();
    final future = seconds < 0;
    return messages.relative(
          unit.unit,
          unit.count,
          future: future,
          style: style,
        ) ??
        messages.relative(
          unit.unit,
          unit.count,
          future: future,
          style: TimeAgoStyle.long,
        ) ??
        date();
  }

  String _date(DateTime dateTime, TimeAgoMessages messages) {
    if (!_dateSymbolsLoaded) {
      // Local data loads synchronously; the returned Future is already done.
      initializeDateFormatting();
      _dateSymbolsLoaded = true;
    }
    // Canonicalises `pt-br` to `pt_BR` and falls back to the language. intl
    // has no date symbols for some locales, Occitan among them; 2.x fell back
    // to English there too.
    final dateLocale = Intl.verifiedLocale(
      messages.intlLocale,
      DateFormat.localeExists,
      onFailure: (_) => 'en',
    )!;
    return DateFormat(
      datePattern ?? defaultDatePattern,
      dateLocale,
    ).format(dateTime.toLocal());
  }
}
