import 'package:get_time_ago/get_time_ago.dart';
import 'package:test/test.dart';

void main() {
  final japaneseMessages = JapaneseMessages();

  group('FrenchMessages Test', () {
    test('prefixAgo should return an empty string', () {
      expect(japaneseMessages.prefixAgo(), '');
    });

    test('suffixAgo should return "前"', () {
      expect(japaneseMessages.suffixAgo(), '前');
    });

    test('justNow should return "たった今"', () {
      expect(japaneseMessages.justNow(20), 'たった今');
    });

    test('secsAgo should return correct seconds ago format', () {
      expect(japaneseMessages.secsAgo(25), '25秒');
    });

    test('minAgo should return "1分"', () {
      expect(japaneseMessages.minAgo(1), '1分');
    });

    test('minsAgo should return correct minutes ago format', () {
      expect(japaneseMessages.minsAgo(5), '5分');
    });

    test('hourAgo should return "1時間"', () {
      expect(japaneseMessages.hourAgo(60), '1時間');
    });

    test('hoursAgo should return correct hours ago format', () {
      expect(japaneseMessages.hoursAgo(5), '5時間');
    });

    test('dayAgo should return "1日"', () {
      expect(japaneseMessages.dayAgo(24), '1日');
    });

    test('daysAgo should return correct days ago format', () {
      expect(japaneseMessages.daysAgo(5), '5日');
    });

    test('wordSeparator should return a space', () {
      expect(japaneseMessages.wordSeparator(), '');
    });
  });

  // Helper function to get the DateTime relative to now
  DateTime _getRelativeDateTime(Duration duration) {
    return DateTime.now().subtract(duration);
  }

  group('GetTimeAgo Test with Japanese Locale', () {
    test('should return "たった今" for time less than 15 seconds', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(seconds: 5)),
        locale: 'ja',
      );
      expect(result, 'たった今');
    });

    test('should return "20秒前" for 20 seconds ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(seconds: 20)),
        locale: 'ja',
      );
      expect(result, '20秒前');
    });

    test('should return "1分前" for 1 minute ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(minutes: 1)),
        locale: 'ja',
      );
      expect(result, '1分前');
    });

    test('should return "2分前" for 2 minutes ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(minutes: 2)),
        locale: 'ja',
      );
      expect(result, '2分前');
    });

    test('should return "1時間前" for 1 hour ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(hours: 1)),
        locale: 'ja',
      );
      expect(result, '1時間前');
    });

    test('should return "2時間前" for 2 hours ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(hours: 2)),
        locale: 'ja',
      );
      expect(result, '2時間前');
    });

    test('should return "1日前" for 1 day ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(hours: 24)),
        locale: 'ja',
      );
      expect(result, '1日前');
    });

    test('should return "3日前" for 3 days ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(days: 3)),
        locale: 'ja',
      );
      expect(result, '3日前');
    });

    test('should return formatted date for dates beyond 7 days', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(days: 10)),
        locale: 'ja',
      );
      expect(result, isNot('10日前'));
    });
  });
}
