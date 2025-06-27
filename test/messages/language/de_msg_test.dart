import 'package:get_time_ago/get_time_ago.dart';
import 'package:test/test.dart';

void main() {
  final messages = GermanMessages();

  group('GermanMessages Test', () {
    test('prefixAgo should return "vor"', () {
      expect(messages.prefixAgo(), 'vor');
    });

    test('suffixAgo should return an empty string', () {
      expect(messages.suffixAgo(), '');
    });

    test('justNow should return "gerade"', () {
      expect(messages.justNow(10), 'gerade');
    });

    test('secsAgo should return correct seconds ago format', () {
      expect(messages.secsAgo(25), '25 Sekunden');
    });

    test('minAgo should return "einer Minute"', () {
      expect(messages.minAgo(1), 'einer Minute');
    });

    test('minsAgo should return correct minutes ago format', () {
      expect(messages.minsAgo(5), '5 Minuten');
    });

    test('hourAgo should return "einer Stunde"', () {
      expect(messages.hourAgo(60), 'einer Stunde');
    });

    test('hoursAgo should return correct hours ago format', () {
      expect(messages.hoursAgo(5), '5 Stunden');
    });

    test('dayAgo should return "einem Tag"', () {
      expect(messages.dayAgo(24), 'einem Tag');
    });

    test('daysAgo should return correct days ago format', () {
      expect(messages.daysAgo(5), '5 Tagen');
    });

    test('wordSeparator should return a space', () {
      expect(messages.wordSeparator(), ' ');
    });
  });

  // Helper function to get the DateTime relative to now
  DateTime _getRelativeDateTime(Duration duration) {
    return DateTime.now().subtract(duration);
  }

  group('GetTimeAgo Test with German Locale', () {
    test('should return vorhin for time less than 15 seconds', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(seconds: 0)),
        locale: 'de',
      );
      expect(result, 'vorhin');
    });

    test('should return correct format for seconds ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(seconds: 20)),
        locale: 'de',
      );
      expect(result, 'vor 20 Sekunden');
    });

    test('should return einer Minute for 1 minute ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(minutes: 1)),
        locale: 'de',
      );
      expect(result, 'vor einer Minute');
    });

    test('should return correct format for 5 minutes ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(minutes: 5)),
        locale: 'de',
      );
      expect(result, 'vor 5 Minuten');
    });

    test('should return einer Stunde for 1 hour ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(hours: 1)),
        locale: 'de',
      );
      expect(result, 'vor einer Stunde');
    });

    test('should return correct format for 5 hours ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(hours: 5)),
        locale: 'de',
      );
      expect(result, 'vor 5 Stunden');
    });

    test('should return einem Tag for 1 day ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(days: 1)),
        locale: 'de',
      );
      expect(result, 'vor einem Tag');
    });

    test('should return correct format for 5 days ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(days: 5)),
        locale: 'de',
      );
      expect(result, 'vor 5 Tagen');
    });

    test('should return formatted date for dates beyond 7 days', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(days: 10)),
        locale: 'de',
      );
      expect(result, isNot('vor 10 Tagen'));
    });
  });
}
