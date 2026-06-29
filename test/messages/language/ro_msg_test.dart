import 'package:get_time_ago/get_time_ago.dart';
import 'package:test/test.dart';

void main() {
  final romanianMessages = RomanianMessages();

  group('RomanianMessages Test', () {
    test('prefixAgo should return "acum"', () {
      expect(romanianMessages.prefixAgo(), 'acum');
    });

    test('suffixAgo should return an empty string', () {
      expect(romanianMessages.suffixAgo(), '');
    });

    test('justNow should return "tocmai acum"', () {
      expect(romanianMessages.justNow(20), 'tocmai acum');
    });

    test('secsAgo should return correct seconds ago format', () {
      expect(romanianMessages.secsAgo(25), '25 secunde');
    });

    test('minAgo should return "un minut"', () {
      expect(romanianMessages.minAgo(1), 'un minut');
    });

    test('minsAgo should return correct minutes ago format', () {
      expect(romanianMessages.minsAgo(5), '5 minute');
    });

    test('hourAgo should return "o oră"', () {
      expect(romanianMessages.hourAgo(60), 'o oră');
    });

    test('hoursAgo should return correct hours ago format', () {
      expect(romanianMessages.hoursAgo(5), '5 ore');
    });

    test('dayAgo should return "o zi"', () {
      expect(romanianMessages.dayAgo(24), 'o zi');
    });

    test('daysAgo should return correct days ago format', () {
      expect(romanianMessages.daysAgo(5), '5 zile');
    });

    test('wordSeparator should return a space', () {
      expect(romanianMessages.wordSeparator(), ' ');
    });
  });

  // Helper function to get the DateTime relative to now
  DateTime _getRelativeDateTime(Duration duration) {
    return DateTime.now().subtract(duration);
  }

  group('GetTimeAgo Test with Romanian Locale', () {
    test('should return "tocmai acum" for just now (0 seconds ago)', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(seconds: 0)),
        locale: 'ro',
      );
      expect(result, 'tocmai acum');
    });

    test('should return correct format for 25 seconds ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(seconds: 25)),
        locale: 'ro',
      );
      expect(result, 'acum 25 secunde');
    });

    test('should return "un minut" for 1 minute ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(minutes: 1)),
        locale: 'ro',
      );
      expect(result, 'acum un minut');
    });

    test('should return correct format for 5 minutes ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(minutes: 5)),
        locale: 'ro',
      );
      expect(result, 'acum 5 minute');
    });

    test('should return "o oră" for 1 hour ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(hours: 1)),
        locale: 'ro',
      );
      expect(result, 'acum o oră');
    });

    test('should return correct format for 5 hours ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(hours: 5)),
        locale: 'ro',
      );
      expect(result, 'acum 5 ore');
    });

    test('should return "o zi" for 1 day ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(days: 1)),
        locale: 'ro',
      );
      expect(result, 'acum o zi');
    });

    test('should return correct format for 5 days ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(days: 5)),
        locale: 'ro',
      );
      expect(result, 'acum 5 zile');
    });

    test('should return formatted date for dates beyond 7 days', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(days: 10)),
        locale: 'ro',
      );
      expect(result, isNot('acum 10 zile'));
    });
  });
}
