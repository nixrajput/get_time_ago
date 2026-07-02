import '../future_time_messages.dart';
import '../messages.dart';

/// The [FrenchMessages] class provides French language-specific
/// implementations of the [Messages] interface. This class is used to format
/// the "time ago" strings in French.
class FrenchMessages with FutureTimeMessages implements Messages {
  /// Prefix added before the time message.
  @override
  String prefixAgo() => 'il y a';

  /// Suffix added after the time message.
  @override
  String suffixAgo() => '';

  @override
  String prefixFromNow() => 'dans';

  @override
  String suffixFromNow() => '';

  /// Message when the elapsed time is less than 15 seconds.
  @override
  String justNow(int seconds) => 'en ce moment';

  /// Message for when the elapsed time is less than a minute.
  @override
  String secsAgo(int seconds) => '$seconds secondes';

  /// Message for when the elapsed time is about a minute.
  @override
  String minAgo(int minutes) => 'une minute';

  /// Message for when the elapsed time is in minutes.
  @override
  String minsAgo(int minutes) => '$minutes minutes';

  /// Message for when the elapsed time is about an hour.
  @override
  String hourAgo(int minutes) => 'une heure';

  /// Message for when the elapsed time is in hours.
  @override
  String hoursAgo(int hours) => '$hours heures';

  /// Message for when the elapsed time is about a day.
  @override
  String dayAgo(int hours) => 'un jour';

  /// Message for when the elapsed time is in days.
  @override
  String daysAgo(int days) => '$days jours';

  /// Word separator to be used when joining the parts of the message.
  @override
  String wordSeparator() => ' ';
}
