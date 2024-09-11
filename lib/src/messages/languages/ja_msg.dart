import '../messages.dart';

/// The [JapaneseMessages] class provides Japanese language-specific
/// implementations of the [Messages] interface. This class is used to format
/// the "time ago" strings in Japanese.
class JapaneseMessages implements Messages {
  /// Prefix added before the time message.
  @override
  String prefixAgo() => '';

  /// Suffix added after the time message.
  @override
  String suffixAgo() => '前';

  /// Message when the elapsed time is less than 15 seconds.
  @override
  String justNow(int seconds) => '唯今';

  /// Message for when the elapsed time is less than a minute.
  @override
  String secsAgo(int seconds) => '$seconds秒';

  /// Message for when the elapsed time is about a minute.
  @override
  String minAgo(int minutes) => '1分';

  /// Message for when the elapsed time is in minutes.
  @override
  String minsAgo(int minutes) => '$minutes分';

  /// Message for when the elapsed time is about an hour.
  @override
  String hourAgo(int minutes) => '1時間';

  /// Message for when the elapsed time is in hours.
  @override
  String hoursAgo(int hours) => '$hours時間';

  /// Message for when the elapsed time is about a day.
  @override
  String dayAgo(int hours) => '1日';

  /// Message for when the elapsed time is in days.
  @override
  String daysAgo(int days) => '$days日';

  /// Word separator to be used when joining the parts of the message.
  @override
  String wordSeparator() => '';
}
