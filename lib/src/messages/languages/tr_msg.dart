import '../future_time_messages.dart';
import '../messages.dart';

/// The [TurkishMessages] class provides Turkish language-specific
/// implementations of the [Messages] interface. This class is used to format
/// the "time ago" strings in Turkish.
class TurkishMessages with FutureTimeMessages implements Messages {
  /// Prefix added before the time message.
  @override
  String prefixAgo() => '';

  /// Suffix added after the time message.
  @override
  String suffixAgo() => 'önce';

  @override
  String prefixFromNow() => '';

  @override
  String suffixFromNow() => 'sonra';

  /// Message when the elapsed time is less than 15 seconds.
  @override
  String justNow(int seconds) => 'hemen şimdi';

  /// Message for when the elapsed time is less than a minute.
  @override
  String secsAgo(int seconds) => '$seconds saniye';

  /// Message for when the elapsed time is about a minute.
  @override
  String minAgo(int minutes) => '1 dakika';

  /// Message for when the elapsed time is in minutes.
  @override
  String minsAgo(int minutes) => '$minutes dakika';

  /// Message for when the elapsed time is about an hour.
  @override
  String hourAgo(int minutes) => 'bir saat';

  /// Message for when the elapsed time is in hours.
  @override
  String hoursAgo(int hours) => '$hours saat';

  /// Message for when the elapsed time is about a day.
  @override
  String dayAgo(int hours) => 'bir gün';

  /// Message for when the elapsed time is in days.
  @override
  String daysAgo(int days) => '$days gün';

  /// Word separator to be used when joining the parts of the message.
  @override
  String wordSeparator() => ' ';
}
