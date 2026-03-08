import '../../utils/utility.dart';
import '../messages.dart';

/// The [ArabicMessages] class provides Arabic language-specific
/// implementations of the [Messages] interface. This class is used to format
/// the "time ago" strings in Arabic.
class ArabicMessages extends Messages {
  /// Prefix added before the time message.
  @override
  String prefixAgo() => 'قبل';

  /// Suffix added after the time message.
  @override
  String suffixAgo() => '';

  /// Message when the elapsed time is less than 15 seconds.
  @override
  String justNow(int seconds) => 'الآن';

  /// Message for when the elapsed time is less than a minute.
  @override
  String secsAgo(int seconds) => '${convertToArabicNumbers(seconds)} ثوان';

  /// Message for when the elapsed time is about a minute.
  @override
  String minAgo(int minutes) => 'دقيقة واحدة';

  /// Message for when the elapsed time is in minutes.
  @override
  String minsAgo(int minutes) {
    if (minutes == 2) {
      return 'دقيقتين';
    }
    return '${convertToArabicNumbers(minutes)} دقائق';
  }

  /// Message for when the elapsed time is about an hour.
  @override
  String hourAgo(int minutes) => 'ساعة واحدة';

  /// Message for when the elapsed time is in hours.
  @override
  String hoursAgo(int hours) {
    if (hours == 2) {
      return 'ساعتين';
    }
    return '${convertToArabicNumbers(hours)} ساعات';
  }

  /// Message for when the elapsed time is about a day.
  @override
  String dayAgo(int hours) => 'يوم واحد';

  /// Message for when the elapsed time is in days.
  @override
  String daysAgo(int days) {
    if (days == 2) {
      return 'يومين';
    }
    return '${convertToArabicNumbers(days)} أيام';
  }

  /// Word separator to be used when joining the parts of the message.
  @override
  String wordSeparator() => ' ';
}
