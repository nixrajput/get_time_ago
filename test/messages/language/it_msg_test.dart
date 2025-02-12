import 'package:get_time_ago/get_time_ago.dart';
import 'package:get_time_ago/src/messages/languages/it_msg.dart';
import 'package:test/test.dart';

void main() {
  final messages = ItalianMessages();

  group('ItalianMessages Test', () {
    test('prefixAgo should return an empty string', () {
      expect(messages.prefixAgo(), '');
    });

    test('suffixAgo should return "fa"', () {
      expect(messages.suffixAgo(), 'fa');
    });

    test('justNow should return "proprio ora"', () {
      expect(messages.justNow(10), 'proprio ora');
    });

    test('secsAgo should return correct seconds ago format', () {
      expect(messages.secsAgo(25), '25 secondi');
    });

    test('minAgo should return "un minuto"', () {
      expect(messages.minAgo(1), 'un minuto');
    });

    test('minsAgo should return correct minutes ago format', () {
      expect(messages.minsAgo(5), '5 minuti');
    });

    test('hourAgo should return "un\'ora"', () {
      expect(messages.hourAgo(60), 'un\'ora');
    });

    test('hoursAgo should return correct hours ago format', () {
      expect(messages.hoursAgo(5), '5 ore');
    });

    test('dayAgo should return "un giorno"', () {
      expect(messages.dayAgo(24), 'un giorno');
    });

    test('daysAgo should return correct days ago format', () {
      expect(messages.daysAgo(5), '5 giorni');
    });

    test('wordSeparator should return a space', () {
      expect(messages.wordSeparator(), ' ');
    });
  });

  // Helper function to get the DateTime relative to now
  DateTime _getRelativeDateTime(Duration duration) {
    return DateTime.now().subtract(duration);
  }

  group('GetTimeAgo Test with Italian Locale', () {
    test('should return "proprio ora" for time less than 15 seconds', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(seconds: 0)),
        locale: 'it',
      );
      expect(result, 'proprio ora');
    });

    test('should return correct format for seconds ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(seconds: 20)),
        locale: 'it',
      );
      expect(result, '20 secondi fa');
    });

    test('should return "un minuto fa" for 1 minute ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(minutes: 1)),
        locale: 'it',
      );
      expect(result, 'un minuto fa');
    });

    test('should return correct format for 5 minutes ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(minutes: 5)),
        locale: 'it',
      );
      expect(result, '5 minuti fa');
    });

    test('should return "un\'ora fa" for 1 hour ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(hours: 1)),
        locale: 'it',
      );
      expect(result, 'un\'ora fa');
    });

    test('should return correct format for 5 hours ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(hours: 5)),
        locale: 'it',
      );
      expect(result, '5 ore fa');
    });

    test('should return "un giorno fa" for 1 day ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(days: 1)),
        locale: 'it',
      );
      expect(result, 'un giorno fa');
    });

    test('should return correct format for 5 days ago', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(days: 5)),
        locale: 'it',
      );
      expect(result, '5 giorni fa');
    });

    test('should return formatted date for dates beyond 7 days', () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(days: 10)),
        locale: 'it',
      );
      expect(result, isNot('10 giorni fa'));
    });
  });
}
