import '../messages.dart';

/// The [ItalianMessages] class provides Italian language-specific
/// implementations of the [Messages] interface. This class is used to format
/// the "time ago" strings in Italian.
class ItalianMessages implements Messages {
  /// Prefix added before the time message.
  @override
  String prefixAgo() => '';

  /// Suffix added after the time message.
  @override
  String suffixAgo() => 'fa';

  /// Message when the elapsed time is less than 15 seconds.
  @override
  String justNow(int seconds) => 'proprio ora';

  /// Message for when the elapsed time is less than a minute.
  @override
  String secsAgo(int seconds) => '$seconds secondi';

  /// Message for when the elapsed time is about a minute.
  @override
  String minAgo(int minutes) => 'un minuto';

  /// Message for when the elapsed time is in minutes.
  @override
  String minsAgo(int minutes) => '$minutes minuti';

  /// Message for when the elapsed time is about an hour.
  @override
  String hourAgo(int minutes) => 'un\'ora';

  /// Message for when the elapsed time is in hours.
  @override
  String hoursAgo(int hours) => '$hours ore';

  /// Message for when the elapsed time is about a day.
  @override
  String dayAgo(int hours) => 'un giorno';

  /// Message for when the elapsed time is in days.
  @override
  String daysAgo(int days) => '$days giorni';

  /// Word separator to be used when joining the parts of the message.
  @override
  String wordSeparator() => ' ';
}
