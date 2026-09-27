import '../time_unit.dart';

/// The text one locale renders for relative times.
///
/// Every bundled locale is a `TimeAgoLocale` table. Implement this directly
/// only when a grammar needs logic a table cannot express.
abstract class TimeAgoMessages {
  /// Lets subclasses be const.
  const TimeAgoMessages();

  /// The `intl` locale used for plural rules and for the full-date fallback,
  /// such as `pt` or `zh_TW`.
  String get intlLocale;

  /// The text for a past time under fifteen seconds, such as "just now".
  String justNow(TimeAgoStyle style);

  /// The text for [count] [unit]s ago, or from now when [future] is true.
  ///
  /// Return `null` when there is no text for [unit] in [style]. The formatter
  /// then tries [TimeAgoStyle.long], and after that shows the full date.
  String? relative(
    TimeUnit unit,
    int count, {
    required bool future,
    required TimeAgoStyle style,
  });
}
