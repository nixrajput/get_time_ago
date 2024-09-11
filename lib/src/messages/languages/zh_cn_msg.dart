import '../messages.dart';

/// The [SimplifiedChineseMessages] class provides Chinese(Simplified) language-specific
/// implementations of the [Messages] interface. This class is used to format
/// the "time ago" strings in Chinese(Simplified).
class SimplifiedChineseMessages implements Messages {
  /// Prefix added before the time message.
  @override
  String prefixAgo() => '';

  /// Suffix added after the time message.
  @override
  String suffixAgo() => '前';

  /// Message when the elapsed time is less than 15 seconds.
  @override
  String justNow(int seconds) => '刚才';

  /// Message for when the elapsed time is less than a minute.
  @override
  String secsAgo(int seconds) => '$seconds秒';

  /// Message for when the elapsed time is about a minute.
  @override
  String minAgo(int minutes) => '1分钟';

  /// Message for when the elapsed time is in minutes.
  @override
  String minsAgo(int minutes) => '$minutes分钟';

  /// Message for when the elapsed time is about an hour.
  @override
  String hourAgo(int minutes) => '1小时';

  /// Message for when the elapsed time is in hours.
  @override
  String hoursAgo(int hours) => '$hours小时';

  /// Message for when the elapsed time is about a day.
  @override
  String dayAgo(int hours) => '1天';

  /// Message for when the elapsed time is in days.
  @override
  String daysAgo(int days) => '$days天';

  /// Word separator to be used when joining the parts of the message.
  @override
  String wordSeparator() => '';
}
