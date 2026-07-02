import '../messages.dart';

/// The [OccitanMessages] class provides Occitan language-specific
/// implementations of the [Messages] interface. This class is used to format
/// the "time ago" strings in Occitan.
class OccitanMessages implements Messages {
  /// Prefix added before the time message.
  @override
  String prefixAgo() => 'fa';

  /// Suffix added after the time message.
  @override
  String suffixAgo() => '';

  @override
  String prefixFromNow() => 'dins';

  @override
  String suffixFromNow() => '';

  /// Message when the elapsed time is less than 15 seconds.
  @override
  String justNow(int seconds) => 'just ara';

  /// Message for when the elapsed time is less than a minute.
  @override
  String secsAgo(int seconds) => '$seconds segondas';

  /// Message for when the elapsed time is about a minute.
  @override
  String minAgo(int minutes) => 'una minuta';

  /// Message for when the elapsed time is in minutes.
  @override
  String minsAgo(int minutes) => '$minutes minutas';

  /// Message for when the elapsed time is about an hour.
  @override
  String hourAgo(int minutes) => 'una ora';

  /// Message for when the elapsed time is in hours.
  @override
  String hoursAgo(int hours) => '$hours oras';

  /// Message for when the elapsed time is about a day.
  @override
  String dayAgo(int hours) => 'un jorn';

  /// Message for when the elapsed time is in days.
  @override
  String daysAgo(int days) => '$days jors';

  /// Word separator to be used when joining the parts of the message.
  @override
  String wordSeparator() => ' ';
}
