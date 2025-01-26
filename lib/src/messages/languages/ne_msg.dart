import 'package:get_time_ago/get_time_ago.dart';

class NepaliMessages extends Messages {
  /// Message for approximately 1 day ago. [hours]: The number of hours that have passed (usually 24).
  @override
  String dayAgo(int hours) => "एक दिन";

  /// Message when the elapsed time is in days. [days]: The number of days that have passed.
  @override
  String daysAgo(int days) => "$days दिन";

  /// Message for approximately 1 hour ago. [minutes]: The number of minutes that have passed (usually 60).
  @override
  String hourAgo(int minutes) => "एक घण्टा";

  /// Message when the elapsed time is in hours. [hours]: The number of hours that have passed.
  @override
  String hoursAgo(int hours) => "$hours घण्टा";

  /// Message when the elapsed time is less than 15 seconds. [seconds]: The number of seconds that have passed.
  @override
  String justNow(int seconds) => "भर्खरै";

  /// Message for approximately 1 minute ago. [minutes]: The number of minutes that have passed (usually 1).
  @override
  String minAgo(int minutes) => "एक मिनेट";

  /// Message when the elapsed time is in minutes. [minutes]: The number of minutes that have passed.
  @override
  String minsAgo(int minutes) => "$minutes मिनेट";

  /// Prefix added before the time ago message
  @override
  String prefixAgo() => "";

  /// Message when the elapsed time is less than a minute. [seconds]: The number of seconds that have passed.
  @override
  String secsAgo(int seconds) => "$seconds सेकेन्ड";

  /// Suffix added after the time ago message.
  @override
  String suffixAgo() => "अघि";
}
