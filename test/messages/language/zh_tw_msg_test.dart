import 'package:get_time_ago/get_time_ago.dart';
import 'package:test/test.dart';

void main() {
  final traditionalChineseMessages = TraditionalChineseMessages();

  group('TraditionalChineseMessages Test', () {
    test('prefixAgo should return an empty string', () {
      expect(traditionalChineseMessages.prefixAgo(), '');
    });

    test('suffixAgo should return "前"', () {
      expect(traditionalChineseMessages.suffixAgo(), '前');
    });

    test('justNow should return "現在"', () {
      expect(traditionalChineseMessages.justNow(10), '現在');
    });

    test('secsAgo should return correct seconds format', () {
      expect(traditionalChineseMessages.secsAgo(20), '20秒');
    });

    test('minAgo should return "1分鐘"', () {
      expect(traditionalChineseMessages.minAgo(1), '1分鐘');
    });

    test('minsAgo should return correct minutes format', () {
      expect(traditionalChineseMessages.minsAgo(5), '5分鐘');
    });

    test('hourAgo should return "1小時"', () {
      expect(traditionalChineseMessages.hourAgo(60), '1小時');
    });

    test('hoursAgo should return correct hours format', () {
      expect(traditionalChineseMessages.hoursAgo(5), '5小時');
    });

    test('dayAgo should return "1天"', () {
      expect(traditionalChineseMessages.dayAgo(24), '1天');
    });

    test('daysAgo should return correct days format', () {
      expect(traditionalChineseMessages.daysAgo(5), '5天');
    });

    test('wordSeparator should return an empty string', () {
      expect(traditionalChineseMessages.wordSeparator(), '');
    });
  });

  // Helper function to get the DateTime relative to now
  DateTime _getRelativeDateTime(Duration duration) {
    return DateTime.now().subtract(duration);
  }

  group('GetTimeAgo Test with Chinese(Traditional) Locale', () {
    test('should return "現在" for time less than 15 seconds', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(seconds: 5)),
        locale: 'zh_tr',
      );
      expect(result, '現在');
    });

    test('should return "30秒前" for 30 seconds ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(seconds: 30)),
        locale: 'zh_tr',
      );
      expect(result, '30秒前');
    });

    test('should return "1分鐘前" for 1 minute ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(minutes: 1)),
        locale: 'zh_tr',
      );
      expect(result, '1分鐘前');
    });

    test('should return "2分鐘前" for 2 minutes ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(minutes: 2)),
        locale: 'zh_tr',
      );
      expect(result, '2分鐘前');
    });

    test('should return "1小時前" for 1 hour ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(hours: 1)),
        locale: 'zh_tr',
      );
      expect(result, '1小時前');
    });

    test('should return "2小時前" for 2 hours ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(hours: 2)),
        locale: 'zh_tr',
      );
      expect(result, '2小時前');
    });

    test('should return "1天前" for 1 day ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(hours: 24)),
        locale: 'zh_tr',
      );
      expect(result, '1天前');
    });

    test('should return "3天前" for 3 days ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(days: 3)),
        locale: 'zh_tr',
      );
      expect(result, '3天前');
    });

    test('should return formatted date for dates beyond 7 days', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(days: 10)),
        locale: 'zh_tr',
      );
      expect(result, isNot('10天前'));
    });
  });
}
