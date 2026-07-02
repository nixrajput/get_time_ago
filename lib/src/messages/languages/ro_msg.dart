import '../future_time_messages.dart';
import '../messages.dart';

/// The [RomanianMessages] class provides Romanian language-specific
/// implementations of the [Messages] interface. This class is used to format
/// the "time ago" strings in Romanian.
class RomanianMessages with FutureTimeMessages implements Messages {
  /// Prefix added before the time message.
  @override
  String prefixAgo() => 'acum';

  /// Suffix added after the time message.
  @override
  String suffixAgo() => '';

  @override
  String prefixFromNow() => 'peste';

  @override
  String suffixFromNow() => '';

  /// Message when the elapsed time is less than 15 seconds.
  @override
  String justNow(int seconds) => 'tocmai acum';

  /// Message for when the elapsed time is less than a minute.
  @override
  String secsAgo(int seconds) => '$seconds secunde';

  /// Message for when the elapsed time is about a minute.
  @override
  String minAgo(int minutes) => 'un minut';

  /// Message for when the elapsed time is in minutes.
  @override
  String minsAgo(int minutes) => '$minutes minute';

  /// Message for when the elapsed time is about an hour.
  @override
  String hourAgo(int minutes) => 'o oră';

  /// Message for when the elapsed time is in hours.
  @override
  String hoursAgo(int hours) => '$hours ore';

  /// Message for when the elapsed time is about a day.
  @override
  String dayAgo(int hours) => 'o zi';

  /// Message for when the elapsed time is in days.
  @override
  String daysAgo(int days) => '$days zile';

  /// Word separator to be used when joining the parts of the message.
  @override
  String wordSeparator() => ' ';
}
