import '../messages.dart';

/// The [HindiMessages] class provides Hindi language-specific
/// implementations of the [Messages] interface. This class is used to format
/// the "time ago" strings in Hindi.
class HindiMessages implements Messages {
  /// Prefix added before the time message.
  @override
  String prefixAgo() => '';

  /// Suffix added after the time message.
  @override
  String suffixAgo() => 'पहले';

  @override
  String prefixFromNow() => '';

  @override
  String suffixFromNow() => 'बाद में';

  /// Message when the elapsed time is less than 15 seconds.
  @override
  String justNow(int seconds) => 'अभी';

  /// Message for when the elapsed time is less than a minute.
  @override
  String secsAgo(int seconds) => '$seconds क्षण';

  /// Message for when the elapsed time is about a minute.
  @override
  String minAgo(int minutes) => 'एक मिनट';

  /// Message for when the elapsed time is in minutes.
  @override
  String minsAgo(int minutes) => '$minutes मिनट';

  /// Message for when the elapsed time is about an hour.
  @override
  String hourAgo(int minutes) => 'एक घंटा';

  /// Message for when the elapsed time is in hours.
  @override
  String hoursAgo(int hours) => '$hours घंटे';

  /// Message for when the elapsed time is about a day.
  @override
  String dayAgo(int hours) => 'एक दिन';

  /// Message for when the elapsed time is in days.
  @override
  String daysAgo(int days) => '$days दिन';

  /// Word separator to be used when joining the parts of the message.
  @override
  String wordSeparator() => ' ';
}
