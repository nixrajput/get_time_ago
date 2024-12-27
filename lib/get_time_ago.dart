import 'package:get_time_ago/src/utils/data.dart';
import 'package:intl/intl.dart';

import 'messages/messages.dart';
import 'utils/utility.dart';

/// Enumeration representing time units for minimum variance.
enum TimeVarianceUnit {
  seconds,
  minutes,
  hours,
  days,
}

/// The `GetTimeAgo` class provides functionality to format a `DateTime` object into a
/// human-readable "time ago" string such as "a minute ago", "5 days ago", etc.
/// It supports multiple locales and allows for custom locale messages.
/// You can also specify custom date formats for cases where the time difference is too large.
/// The class handles different time units such as seconds, minutes, hours, and days, and provides
/// localized messages accordingly.
class GetTimeAgo {
  /// The default locale for the time ago messages, initially set to the default locale in Data.
  static String _defaultLocale = Data.defaultLocale;

  /// A map that stores different message formats for various locales.
  /// Each locale is mapped to its corresponding Messages object.
  static final Map<String, Messages> _messageMap = Data.messagesMap;

  /// Sets the default [locale] to be used if no specific locale is passed in the parse function.
  /// By default, it is set to 'en' (English).
  ///
  /// Throws an [ArgumentError] if the provided locale is not available in [_messageMap].
  static void setDefaultLocale(String locale) {
    if (!_messageMap.containsKey(locale)) {
      throw ArgumentError('[locale] must be a valid locale');
    }
    _defaultLocale = locale;
  }

  /// Sets a [customLocale] with the provided [customMessages] to be available for use in time ago formatting.
  ///
  /// This allows you to define custom messages for new locales.
  /// To implement this, you need to define the [Messages] interface and provide the required messages.
  static void setCustomLocaleMessages(
    String customLocale,
    Messages customMessages,
  ) {
    _messageMap[customLocale] = customMessages;
  }

  /// [parse] function formats the provided [dateTime] into a human-readable time ago string.
  /// Example output: 'a minute ago', '5 days ago', etc.
  ///
  /// - If [locale] is passed, it uses the messages for that locale. Otherwise, it defaults to [_defaultLocale].
  /// - If [pattern] is passed, it will use the custom DateFormat pattern for displaying the date.
  /// - [minimumVarianceUnit]: (optional) Determines the stopping point for displaying "Less than [Unit]" messages.
  ///   For example, if set to `TimeVarianceUnit.minutes`, "Less than a minute" will be displayed
  ///   until a minute has passed, unless it's less than 15 seconds ago.
  ///
  /// The function computes the time difference between the current time and [dateTime] and returns an appropriate message.
  static String parse(
    DateTime dateTime, {
    String? locale,
    String? pattern,
    TimeVarianceUnit? minimumVarianceUnit,
  }) {
    // Get the locale, if not provided, fallback to the default locale.
    final selectedLocale = locale ?? _defaultLocale;

    // Retrieve the message set for the locale. If not found, fallback to default messages.
    final message = _messageMap[selectedLocale] ?? Data.defaultMessages;

    // Format the dateTime using the provided pattern or the default pattern.
    final formattedDate =
        DateFormat(pattern ?? "dd MMM, yyyy hh:mm aa").format(dateTime);

    // Get the current time for comparison.
    final currentClock = DateTime.now();

    // Calculate the time difference between now and the provided dateTime.
    final elapsed = currentClock.difference(dateTime).abs();

    // If no minimumVarianceUnit is provided, use the original behavior
    if (minimumVarianceUnit == null) {
      return _formatElapsed(elapsed, message, formattedDate);
    }

    // Calculate the threshold and unit label based on the selected TimeVarianceUnit
    Duration threshold;
    String unitLabel;
    switch (minimumVarianceUnit) {
      case TimeVarianceUnit.seconds:
        threshold = Duration(seconds: 15); // Default to "Just now" for < 15s
        unitLabel = "seconds";
        break;
      case TimeVarianceUnit.minutes:
        threshold = Duration(minutes: 1);
        unitLabel = "minute";
        break;
      case TimeVarianceUnit.hours:
        threshold = Duration(hours: 1);
        unitLabel = "hour";
        break;
      case TimeVarianceUnit.days:
        threshold = Duration(days: 1);
        unitLabel = "day";
        break;
      default:
        threshold = Duration.zero;
        unitLabel = ""; // No label if no unit specified
    }

    // Handle "Just now" and "Less than [Unit]" logic
    if (elapsed < Duration(seconds: 15)) {
      return message.justNow(elapsed.inSeconds); // Display "Just now"
    } else if (elapsed < threshold) {
      return "Less than $unitLabel"; // Display "Less than [Unit]"
    }

    return _formatElapsed(elapsed, message, formattedDate);
  }

  /// Formats the elapsed time into a human-readable string based on predefined rules.
  static String _formatElapsed(Duration elapsed, Messages message, String formattedDate) {
    final prefix = message.prefixAgo();
    final suffix = message.suffixAgo();

    if (elapsed.inSeconds < 60) {
      return formatMessage(prefix, message.secsAgo(elapsed.inSeconds), suffix, message);
    } else if (elapsed.inMinutes < 2) {
      return formatMessage(prefix, message.minAgo(elapsed.inMinutes), suffix, message);
    } else if (elapsed.inMinutes < 60) {
      return formatMessage(prefix, message.minsAgo(elapsed.inMinutes), suffix, message);
    } else if (elapsed.inHours < 2) {
      return formatMessage(prefix, message.hourAgo(elapsed.inHours), suffix, message);
    } else if (elapsed.inHours < 24) {
      return formatMessage(prefix, message.hoursAgo(elapsed.inHours), suffix, message);
    } else if (elapsed.inHours < 48) {
      return formatMessage(prefix, message.dayAgo(elapsed.inHours ~/ 24), suffix, message);
    } else if (elapsed.inDays < 8) {
      return formatMessage(prefix, message.daysAgo(elapsed.inDays), suffix, message);
    } 
    
    return formattedDate;
  }
}
