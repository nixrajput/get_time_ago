import 'package:get_time_ago/get_time_ago.dart';
import 'package:get_time_ago/src/messages/languages/ne_msg.dart';
import 'package:test/test.dart';

void main() {
  var nepaliMessages = NepaliMessages();

  group("Nepali Message Test", () {
    test("Just now should return भर्खरै", () {
      expect(nepaliMessages.justNow(5), "भर्खरै");
    });

    test("daysAgo should return 1 दिन", () {
      expect(nepaliMessages.daysAgo(1), "1 दिन");
    });

    test("dayAgo should return एक दिन", () {
      expect(nepaliMessages.dayAgo(24), "एक दिन");
    });

    test("minAgo should return एक मिनेट", () {
      expect(nepaliMessages.minAgo(1), "एक मिनेट");
    });

    test("minsAgo should return 10 मिनेट", () {
      expect(nepaliMessages.minsAgo(10), "10 मिनेट");
    });

    test("prefixAgo should return empty string", () {
      expect(nepaliMessages.prefixAgo(), "");
    });

    test("suffixAgo should return अघि", () {
      expect(nepaliMessages.suffixAgo(), "अघि");
    });

    test("secondsAgo should return 20 सेकेन्ड", () {
      expect(nepaliMessages.secsAgo(20), "20 सेकेन्ड");
    });

    test('wordSeperator should return " " ', () {
      expect(nepaliMessages.wordSeparator(), " ");
    });

    test("hourAgo should return एक घण्टा", () {
      expect(nepaliMessages.hourAgo(40), "एक घण्टा");
    });

    test("hoursAgo should return 3 घण्टा", () {
      expect(nepaliMessages.hoursAgo(3), "3 घण्टा");
    });
  });

  // Helper function to get the DateTime relative to now
  DateTime _getRelativeDateTime(Duration duration) {
    return DateTime.now().subtract(duration);
  }

  group("GetTimeAgo with Nepali Locale", () {
    test("should return भर्खरै for time ellapsed less than 15 seconds", () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(
          const Duration(seconds: 0),
        ),
        locale: "ne",
      );
      expect(result, "भर्खरै");
    });

    test("should return भर्खरै for time ellapsed less than 15 seconds", () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(
          const Duration(seconds: 13),
        ),
        locale: "ne",
      );
      expect(result, "भर्खरै");
    });

    test("should return 20 सेकेन्ड अघि for time ellapsed more than 15 seconds",
        () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(
          const Duration(seconds: 25),
        ),
        locale: "ne",
      );
      expect(result, "25 सेकेन्ड अघि");
    });

    test("should return एक मिनेट अघि for time 1 min ago", () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(minutes: 1)),
        locale: "ne",
      );
      expect(result, "एक मिनेट अघि");
    });

    test("should return 2 मिनेट अघिn for time 2 minutes ago", () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(minutes: 2)),
        locale: "ne",
      );
      expect(result, "2 मिनेट अघि");
    });

    test("should return एक घण्टा अघि for time 1 hour ago", () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(hours: 1)),
        locale: "ne",
      );

      expect(result, "एक घण्टा अघि");
    });

    test("should return 2 घण्टा अघि for time 2 hour ago", () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(hours: 2)),
        locale: "ne",
      );

      expect(result, "2 घण्टा अघि");
    });

    test("should return एक दिन अघि for time 24 hours ago", () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(
          const Duration(hours: 24),
        ),
        locale: "ne",
      );
      expect(result, "एक दिन अघि");
    });

    test("should return 3 दिन अघि for time 3 day ago", () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(
          const Duration(days: 3),
        ),
        locale: "ne",
      );
      expect(result, "3 दिन अघि");
    });

    test("should return 7 दिन अघि for time 7 day ago", () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(
          const Duration(days: 7),
        ),
        locale: "ne",
      );
      expect(result, "7 दिन अघि");
    });

    test("should return formatted data for duration beyond 7 days", () {
      final result = GetTimeAgo.parse(
        _getRelativeDateTime(const Duration(days: 8)),
        locale: "ne",
      );
      expect(result, isNot("8 दिन अघि"));
    });
  });
}
