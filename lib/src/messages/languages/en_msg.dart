import '../future_time_messages.dart';
import '../messages.dart';

/// The [EnglishMessages] class provides English language-specific
/// implementations of the [Messages] interface. This class is used to format
/// the "time ago" strings in English.
class EnglishMessages with FutureTimeMessages implements Messages {
  /// Prefix added before the time message.
  @override
  String prefixAgo() => '';

  /// Suffix added after the time message.
  @override
  String suffixAgo() => 'ago';

  @override
  String prefixFromNow() => 'in';

  @override
  String suffixFromNow() => '';

  /// Message when the elapsed time is less than 15 seconds.
  @override
  String justNow(int seconds) => 'just now';

  /// Message for when the elapsed time is less than a minute.
  @override
  String secsAgo(int seconds) => '$seconds seconds';

  /// Message for when the elapsed time is about a minute.
  @override
  String minAgo(int minutes) => 'a minute';

  /// Message for when the elapsed time is in minutes.
  @override
  String minsAgo(int minutes) => '$minutes minutes';

  /// Message for when the elapsed time is about an hour.
  @override
  String hourAgo(int minutes) => 'an hour';

  /// Message for when the elapsed time is in hours.
  @override
  String hoursAgo(int hours) => '$hours hours';

  /// Message for when the elapsed time is about a day.
  @override
  String dayAgo(int hours) => 'a day';

  /// Message for when the elapsed time is in days.
  @override
  String daysAgo(int days) => '$days days';

  /// Word separator to be used when joining the parts of the message.
  @override
  String wordSeparator() => ' ';
}
