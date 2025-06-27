import '../messages.dart';

/// The [GermanMessages] class provides German language-specific
/// implementations of the [Messages] interface. This class is used to format
/// the "time ago" strings in German.
class GermanMessages implements Messages {
  /// Prefix added before the time message.
  @override
  String prefixAgo() => 'vor';

  /// Suffix added after the time message.
  @override
  String suffixAgo() => '';

  /// Message when the elapsed time is less than 15 seconds.
  @override
  String justNow(int seconds) => 'gerade eben';

  /// Message for when the elapsed time is less than a minute.
  @override
  String secsAgo(int seconds) => '$seconds Sekunden';

  /// Message for when the elapsed time is about a minute.
  @override
  String minAgo(int minutes) => 'einer Minute';

  /// Message for when the elapsed time is in minutes.
  @override
  String minsAgo(int minutes) => '$minutes Minuten';

  /// Message for when the elapsed time is about an hour.
  @override
  String hourAgo(int minutes) => 'einer Stunde';

  /// Message for when the elapsed time is in hours.
  @override
  String hoursAgo(int hours) => '$hours Stunden';

  /// Message for when the elapsed time is about a day.
  @override
  String dayAgo(int hours) => 'einem Tag';

  /// Message for when the elapsed time is in days.
  @override
  String daysAgo(int days) => '$days Tagen';

  /// Word separator to be used when joining the parts of the message.
  @override
  String wordSeparator() => ' ';
}
