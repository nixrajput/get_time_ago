import '../messages.dart';

/// The [KoreanMessages] class provides Korean language-specific
/// implementations of the [Messages] interface. This class is used to format
/// the "time ago" strings in Korean.
class KoreanMessages implements Messages {
  /// Prefix added before the time message.
  @override
  String prefixAgo() => '';

  /// Suffix added after the time message.
  @override
  String suffixAgo() => '전';

  @override
  String prefixFromNow() => '';

  @override
  String suffixFromNow() => '후';

  /// Message when the elapsed time is less than 15 seconds.
  @override
  String justNow(int seconds) => '바로 지금';

  /// Message for when the elapsed time is less than a minute.
  @override
  String secsAgo(int seconds) => '$seconds초';

  /// Message for when the elapsed time is about a minute.
  @override
  String minAgo(int minutes) => '일분';

  /// Message for when the elapsed time is in minutes.
  @override
  String minsAgo(int minutes) => '$minutes분';

  /// Message for when the elapsed time is about an hour.
  @override
  String hourAgo(int minutes) => '한시간';

  /// Message for when the elapsed time is in hours.
  @override
  String hoursAgo(int hours) => '$hours시간';

  /// Message for when the elapsed time is about a day.
  @override
  String dayAgo(int hours) => '하루';

  /// Message for when the elapsed time is in days.
  @override
  String daysAgo(int days) => '$days일';

  /// Word separator to be used when joining the parts of the message.
  @override
  String wordSeparator() => '';
}
