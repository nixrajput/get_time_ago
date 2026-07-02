/// The [Messages] abstract class defines the interface for localization messages
/// used in formatting "time ago" strings. Implementations of this class should
/// provide specific messages for different time intervals (e.g., seconds, minutes, hours)
/// and optional prefix/suffix strings to be used in the final output.
abstract class Messages {
  /// Prefix added before the time ago message.
  /// Example: 'about' or '' (empty).
  String prefixAgo();

  /// Suffix added after the time ago message.
  /// Example: 'ago' or '' (empty).
  String suffixAgo();

  /// Message when the elapsed time is less than 15 seconds.
  /// [seconds]: The number of seconds that have passed.
  String justNow(int seconds);

  /// Message when the elapsed time is less than a minute.
  /// [seconds]: The number of seconds that have passed.
  String secsAgo(int seconds);

  /// Message for approximately 1 minute ago.
  /// [minutes]: The number of minutes that have passed (usually 1).
  String minAgo(int minutes);

  /// Message when the elapsed time is in minutes.
  /// [minutes]: The number of minutes that have passed.
  String minsAgo(int minutes);

  /// Message for approximately 1 hour ago.
  /// [minutes]: The number of minutes that have passed (usually 60).
  String hourAgo(int minutes);

  /// Message when the elapsed time is in hours.
  /// [hours]: The number of hours that have passed.
  String hoursAgo(int hours);

  /// Message for approximately 1 day ago.
  /// [hours]: The number of hours that have passed (usually 24).
  String dayAgo(int hours);

  /// Message when the elapsed time is in days.
  /// [days]: The number of days that have passed.
  String daysAgo(int days);

  /// A word separator that concatenates words in a message.
  /// By default, it returns a space (' ').
  String wordSeparator() => ' ';
}
