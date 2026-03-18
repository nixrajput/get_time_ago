import 'package:get_time_ago/get_time_ago.dart';
import 'package:test/test.dart';

void main() {
  final messages = ArabicMessages();

  group('ArabicMessages Test', () {
    test('prefixAgo should return "قبل"', () {
      expect(messages.prefixAgo(), 'قبل');
    });

    test('suffixAgo should return empty string', () {
      expect(messages.suffixAgo(), '');
    });

    test('justNow should return "الآن"', () {
      expect(messages.justNow(10), 'الآن');
    });

    test('secsAgo should return correct seconds ago format', () {
      expect(messages.secsAgo(5), '٥ ثوان');
    });

    test('minAgo should return "دقيقة واحدة"', () {
      expect(messages.minAgo(1), 'دقيقة واحدة');
    });

    test('minsAgo should return correct plural form for 2 minutes', () {
      expect(messages.minsAgo(2), 'دقيقتين');
    });

    test('minsAgo should return correct plural form for more than 2 minutes',
        () {
      expect(messages.minsAgo(5), '٥ دقائق');
    });

    test('hourAgo should return "ساعة واحدة"', () {
      expect(messages.hourAgo(60), 'ساعة واحدة');
    });

    test('hoursAgo should return correct plural form for 2 hours', () {
      expect(messages.hoursAgo(2), 'ساعتين');
    });

    test('hoursAgo should return correct plural form for more than 2 hours',
        () {
      expect(messages.hoursAgo(5), '٥ ساعات');
    });

    test('dayAgo should return "يوم واحد"', () {
      expect(messages.dayAgo(24), 'يوم واحد');
    });

    test('daysAgo should return correct plural form for 2 days', () {
      expect(messages.daysAgo(2), 'يومين');
    });

    test('daysAgo should return correct plural form for more than 2 days', () {
      expect(messages.daysAgo(5), '٥ أيام');
    });

    test('wordSeparator should return a space', () {
      expect(messages.wordSeparator(), ' ');
    });
  });

  // Helper function to get the DateTime relative to now
  DateTime _getRelativeDateTime(Duration duration) {
    return DateTime.now().subtract(duration);
  }

  group('GetTimeAgo Test with Arabic Locale', () {
    test('should return الآن for time less than 15 seconds', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(seconds: 0)),
        locale: 'ar',
      );
      expect(result, 'الآن');
    });

    test('should return correct format for 30 seconds ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(seconds: 30)),
        locale: 'ar',
      );
      expect(result, 'قبل ٣٠ ثوان');
    });

    test('should return دقيقة واحدة for 1 minute ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(minutes: 1)),
        locale: 'ar',
      );
      expect(result, 'قبل دقيقة واحدة');
    });

    test('should return دقيقتين for 2 minutes ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(minutes: 2)),
        locale: 'ar',
      );
      print(result.toString() == 'قبل دقيقتين');
      expect(result, 'قبل دقيقتين');
    });

    test('should return correct format for 5 minutes ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(minutes: 5)),
        locale: 'ar',
      );
      expect(result, 'قبل ٥ دقائق');
    });

    test('should return ساعة واحدة for 1 hour ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(hours: 1)),
        locale: 'ar',
      );
      expect(result, 'قبل ساعة واحدة');
    });

    test('should return ساعتين for 2 hours ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(hours: 2)),
        locale: 'ar',
      );
      expect(result, 'قبل ساعتين');
    });

    test('should return correct format for 5 hours ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(hours: 5)),
        locale: 'ar',
      );
      expect(result, 'قبل ٥ ساعات');
    });

    test('should return يوم واحد for 1 day ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(days: 1)),
        locale: 'ar',
      );
      expect(result, 'قبل يوم واحد');
    });

    test('should return يومين for 2 days ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(days: 2)),
        locale: 'ar',
      );
      expect(result, 'قبل يومين');
    });

    test('should return correct format for 5 days ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(days: 5)),
        locale: 'ar',
      );
      expect(result, 'قبل ٥ أيام');
    });

    test('should return formatted date for dates beyond 7 days', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(days: 10)),
        locale: 'ar',
      );
      expect(result, isNot('قبل ١٠ أيام'));
    });
  });
}
