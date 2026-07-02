import '../../utils/utility.dart';
import '../messages.dart';

/// The [PersianMessages] class provides Persian language-specific
/// implementations of the [Messages] interface. This class is used to format
/// the "time ago" strings in Persian.
class PersianMessages extends Messages {
  /// Prefix added before the time message.
  @override
  String prefixAgo() => '\u202B';

  /// Suffix added after the time message.
  @override
  String suffixAgo() => 'پیش';

  @override
  String prefixFromNow() => '\u202B';

  @override
  String suffixFromNow() => 'دیگر';

  /// Message when the elapsed time is less than 15 seconds.
  @override
  String justNow(int seconds) => 'همین الان';

  /// Message for when the elapsed time is less than a minute.
  @override
  String secsAgo(int seconds) => '${convertToUrduNumbers(seconds)} ثانیه';

  /// Message for when the elapsed time is about a minute.
  @override
  String minAgo(int minutes) => 'یک دقیقه';

  /// Message for when the elapsed time is in minutes.
  @override
  String minsAgo(int minutes) => '${convertToUrduNumbers(minutes)} دقیقه';

  /// Message for when the elapsed time is about an hour.
  @override
  String hourAgo(int minutes) => 'یک ساعت';

  /// Message for when the elapsed time is in hours.
  @override
  String hoursAgo(int hours) => '${convertToUrduNumbers(hours)} ساعت';

  /// Message for when the elapsed time is about a day.
  @override
  String dayAgo(int hours) => 'یک روز';

  /// Message for when the elapsed time is in days.
  @override
  String daysAgo(int days) => '${convertToUrduNumbers(days)} روز';

  /// Word separator to be used when joining the parts of the message.
  @override
  String wordSeparator() => ' ';
}
