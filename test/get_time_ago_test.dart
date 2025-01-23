import 'package:get_time_ago/get_time_ago.dart';
import 'package:intl/intl.dart';
import 'package:test/test.dart';

import 'custom_locale_test_message.dart';

void main() {
  // Helper function to get the DateTime relative to now
  DateTime _getRelativeDateTime(Duration duration) {
    return DateTime.now().subtract(duration);
  }

  group('GetTimeAgo Test Cases', () {
    test('Test seconds ago (less than 15 seconds)', () {
      final dateTime = _getRelativeDateTime(const Duration(seconds: 10));
      final result = GetTimeAgo.parse(dateTime);
      expect(result, equals('just now'));
    });

    test('Test seconds ago (less than 60 seconds)', () {
      final dateTime = _getRelativeDateTime(const Duration(seconds: 45));
      final result = GetTimeAgo.parse(dateTime);
      expect(result, equals('45 seconds ago'));
    });

    test('Test 1 minute ago (around 60 seconds)', () {
      final dateTime = _getRelativeDateTime(const Duration(minutes: 1));
      final result = GetTimeAgo.parse(dateTime);
      expect(result, equals('a minute ago'));
    });

    test('Test minutes ago (less than 60 minutes)', () {
      final dateTime = _getRelativeDateTime(const Duration(minutes: 30));
      final result = GetTimeAgo.parse(dateTime);
      expect(result, equals('30 minutes ago'));
    });

    test('Test 1 hour ago', () {
      final dateTime = _getRelativeDateTime(const Duration(hours: 1));
      final result = GetTimeAgo.parse(dateTime);
      expect(result, equals('an hour ago'));
    });

    test('Test hours ago (less than 24 hours)', () {
      final dateTime = _getRelativeDateTime(const Duration(hours: 5));
      final result = GetTimeAgo.parse(dateTime);
      expect(result, equals('5 hours ago'));
    });

    test('Test 1 day ago', () {
      final dateTime = _getRelativeDateTime(const Duration(days: 1));
      final result = GetTimeAgo.parse(dateTime);
      expect(result, equals('a day ago'));
    });

    test('Test days ago (less than 8 days)', () {
      final dateTime = _getRelativeDateTime(const Duration(days: 5));
      final result = GetTimeAgo.parse(dateTime);
      expect(result, equals('5 days ago'));
    });

    test('Test date formatting for more than 8 days', () {
      final dateTime = _getRelativeDateTime(const Duration(days: 10));
      final result = GetTimeAgo.parse(dateTime);
      final expectedDate = DateFormat("dd MMM, yyyy hh:mm aa").format(dateTime);
      expect(result, equals(expectedDate));
    });

    test('Test invalid locale (throws error)', () {
      expect(() => GetTimeAgo.setDefaultLocale('invalid'), throwsArgumentError);
    });

    test('Test custom locale (French)', () {
      GetTimeAgo.setDefaultLocale('fr');
      final dateTime = _getRelativeDateTime(const Duration(minutes: 5));
      final result = GetTimeAgo.parse(dateTime);
      expect(result, equals('il y a 5 minutes'));
    });

    test('Test custom pattern', () {
      GetTimeAgo.setDefaultLocale('en');
      final dateTime = DateTime(2024, 8, 10, 14, 30);
      final result = GetTimeAgo.parse(dateTime, pattern: 'yyyy-MM-dd HH:mm');
      expect(result, equals('2024-08-10 14:30'));
    });

    test('Test custom locale messages', () {
      GetTimeAgo.setCustomLocaleMessages('test', CustomLocaleTestMessages());
      final dateTime = _getRelativeDateTime(const Duration(minutes: 3));
      final result = GetTimeAgo.parse(dateTime, locale: 'test');
      expect(result, equals('3 mins ago'));
    });
  });
}
