import 'package:intl/intl.dart';

import '../time_unit.dart';
import 'time_ago_messages.dart';

/// One pattern per CLDR plural category, with `{0}` where the count goes.
///
/// Give only the categories the language uses. A missing category falls back
/// to [other].
class Plural {
  /// Creates the patterns for one unit in one direction.
  const Plural({
    this.zero,
    this.one,
    this.two,
    this.few,
    this.many,
    required this.other,
  });

  /// The CLDR `zero` pattern.
  final String? zero;

  /// The CLDR `one` pattern, also used whenever the count is exactly 1.
  final String? one;

  /// The CLDR `two` pattern.
  final String? two;

  /// The CLDR `few` pattern.
  final String? few;

  /// The CLDR `many` pattern.
  final String? many;

  /// The pattern for every other count.
  final String other;

  /// The pattern for [count] under [locale]'s plural rules.
  String select(int count, String locale) =>
      // Explicit-number cases stay on: an exact 1 must reach [one] even where
      // CLDR has no `one` category, which is how Korean keeps 일분.
      Intl.pluralLogic(
        count,
        zero: zero,
        one: one,
        two: two,
        few: few,
        many: many,
        other: other,
        locale: locale,
      );
}

/// The past and future patterns for one unit.
class RelativePatterns {
  /// Creates the patterns for one unit.
  const RelativePatterns({required this.past, required this.future});

  /// "5 minutes ago".
  final Plural past;

  /// "in 5 minutes".
  final Plural future;
}

/// Everything one style of a locale says.
class TimeAgoPatterns {
  /// Creates the text for one style.
  const TimeAgoPatterns({required this.justNow, required this.units});

  /// The text for a past time under fifteen seconds.
  final String justNow;

  /// The patterns for each unit this style covers.
  final Map<TimeUnit, RelativePatterns> units;

  /// A copy with the given fields replaced.
  TimeAgoPatterns copyWith({
    String? justNow,
    Map<TimeUnit, RelativePatterns>? units,
  }) => TimeAgoPatterns(
    justNow: justNow ?? this.justNow,
    units: units ?? this.units,
  );
}

/// The digits a locale writes numbers with.
enum Numerals {
  /// 0123456789.
  latin(0x30),

  /// ٠١٢٣٤٥٦٧٨٩, as Arabic uses.
  arabicIndic(0x660),

  /// ۰۱۲۳۴۵۶۷۸۹, as Persian and Urdu use.
  extendedArabicIndic(0x6F0);

  const Numerals(this._zero);

  final int _zero;

  /// [number] written in these digits.
  String format(int number) => String.fromCharCodes(
    '$number'.codeUnits.map((unit) => unit - 0x30 + _zero),
  );
}

/// A locale defined as data: patterns per style, unit, direction and plural
/// category.
class TimeAgoLocale extends TimeAgoMessages {
  /// Creates a locale. [long] is required; [short] and [narrow] fall back to it.
  const TimeAgoLocale({
    required this.intlLocale,
    required this.long,
    this.short,
    this.narrow,
    this.numerals = Numerals.latin,
  });

  @override
  final String intlLocale;

  /// The [TimeAgoStyle.long] text.
  final TimeAgoPatterns long;

  /// The [TimeAgoStyle.short] text, if this locale has one.
  final TimeAgoPatterns? short;

  /// The [TimeAgoStyle.narrow] text, if this locale has one.
  final TimeAgoPatterns? narrow;

  /// The digits the count is written in.
  final Numerals numerals;

  TimeAgoPatterns? _patterns(TimeAgoStyle style) => switch (style) {
    TimeAgoStyle.long => long,
    TimeAgoStyle.short => short,
    TimeAgoStyle.narrow => narrow,
  };

  @override
  String justNow(TimeAgoStyle style) => (_patterns(style) ?? long).justNow;

  @override
  String? relative(
    TimeUnit unit,
    int count, {
    required bool future,
    required TimeAgoStyle style,
  }) {
    final patterns = _patterns(style)?.units[unit];
    if (patterns == null) return null;
    final plural = future ? patterns.future : patterns.past;
    return plural
        .select(count, intlLocale)
        .replaceAll('{0}', numerals.format(count));
  }

  /// A copy with the given fields replaced.
  TimeAgoLocale copyWith({
    String? intlLocale,
    TimeAgoPatterns? long,
    TimeAgoPatterns? short,
    TimeAgoPatterns? narrow,
    Numerals? numerals,
  }) => TimeAgoLocale(
    intlLocale: intlLocale ?? this.intlLocale,
    long: long ?? this.long,
    short: short ?? this.short,
    narrow: narrow ?? this.narrow,
    numerals: numerals ?? this.numerals,
  );
}
