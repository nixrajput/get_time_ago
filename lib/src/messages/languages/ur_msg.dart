import '../../utils/utility.dart';
import '../messages.dart';

/// The [UrduMessages] class provides Urdu language-specific
/// implementations of the [Messages] interface. This class is used to format
/// the "time ago" strings in Urdu.
class UrduMessages extends Messages {
  /// Prefix added before the time message.
  @override
  String prefixAgo() => '\u202B'; // right to left embedding character

  /// Suffix added after the time message.
  @override
  String suffixAgo() => 'پہلے';

  @override
  String prefixFromNow() => '\u202B';

  @override
  String suffixFromNow() => 'بعد';

  /// Message when the elapsed time is less than 15 seconds.
  @override
  String justNow(int seconds) => 'ابھی';

  /// Message for when the elapsed time is less than a minute.
  @override
  String secsAgo(int seconds) => '${convertToUrduNumbers(seconds)} سیکنڈ';

  /// Message for when the elapsed time is about a minute.
  @override
  String minAgo(int minutes) => 'ایک منٹ';

  /// Message for when the elapsed time is in minutes.
  @override
  String minsAgo(int minutes) => '${convertToUrduNumbers(minutes)} منٹ';

  /// Message for when the elapsed time is about an hour.
  @override
  String hourAgo(int minutes) => 'ایک گھنٹہ';

  /// Message for when the elapsed time is in hours.
  @override
  String hoursAgo(int hours) => '${convertToUrduNumbers(hours)} گھنٹے';

  /// Message for when the elapsed time is about a day.
  @override
  String dayAgo(int hours) => 'ایک دن';

  /// Message for when the elapsed time is in days.
  @override
  String daysAgo(int days) => '${convertToUrduNumbers(days)} دن';

  /// Word separator to be used when joining the parts of the message.
  @override
  String wordSeparator() => ' ';
}
