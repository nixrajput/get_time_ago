import '../future_time_messages.dart';
import '../messages.dart';

/// The [VietnameseMessages] class provides Vietnamese language-specific
/// implementations of the [Messages] interface. This class is used to format
/// the "time ago" strings in Vietnamese.
class VietnameseMessages with FutureTimeMessages implements Messages {
  /// Prefix added before the time message.
  @override
  String prefixAgo() => '';

  /// Suffix added after the time message.
  @override
  String suffixAgo() => 'trước';

  @override
  String prefixFromNow() => '';

  @override
  String suffixFromNow() => 'nữa';

  /// Message when the elapsed time is less than 15 seconds.
  @override
  String justNow(int seconds) => 'ngay bây giờ';

  /// Message for when the elapsed time is less than a minute.
  @override
  String secsAgo(int seconds) => '$seconds giây';

  /// Message for when the elapsed time is about a minute.
  @override
  String minAgo(int minutes) => '1 phút';

  /// Message for when the elapsed time is in minutes.
  @override
  String minsAgo(int minutes) => '$minutes phút';

  /// Message for when the elapsed time is about an hour.
  @override
  String hourAgo(int minutes) => '1 giờ';

  /// Message for when the elapsed time is in hours.
  @override
  String hoursAgo(int hours) => '$hours giờ';

  /// Message for when the elapsed time is about a day.
  @override
  String dayAgo(int hours) => '1 ngày';

  /// Message for when the elapsed time is in days.
  @override
  String daysAgo(int days) => '$days ngày';

  /// Word separator to be used when joining the parts of the message.
  @override
  String wordSeparator() => ' ';
}
