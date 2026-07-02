import '../future_time_messages.dart';
import '../messages.dart';

/// The [DutchMessages] class provides Dutch language-specific
/// implementations of the [Messages] interface. This class is used to format
/// the "time ago" strings in Dutch.
class DutchMessages with FutureTimeMessages implements Messages {
  /// Prefix added before the time message.
  @override
  String prefixAgo() => '';

  /// Suffix added after the time message.
  @override
  String suffixAgo() => 'geleden';

  @override
  String prefixFromNow() => 'over';

  @override
  String suffixFromNow() => '';

  /// Message when the elapsed time is less than 15 seconds.
  @override
  String justNow(int seconds) => 'zojuist';

  /// Message for when the elapsed time is less than a minute.
  @override
  String secsAgo(int seconds) => '$seconds seconden';

  /// Message for when the elapsed time is about a minute.
  @override
  String minAgo(int minutes) => 'een minuut';

  /// Message for when the elapsed time is in minutes.
  @override
  String minsAgo(int minutes) => '$minutes minuten';

  /// Message for when the elapsed time is about an hour.
  @override
  String hourAgo(int minutes) => 'een uur';

  /// Message for when the elapsed time is in hours.
  @override
  String hoursAgo(int hours) => '$hours uur';

  /// Message for when the elapsed time is about a day.
  @override
  String dayAgo(int hours) => 'een dag';

  /// Message for when the elapsed time is in days.
  @override
  String daysAgo(int days) => '$days dagen';

  /// Word separator to be used when joining the parts of the message.
  @override
  String wordSeparator() => ' ';
}
