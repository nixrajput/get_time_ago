import 'package:get_time_ago/src/utils/data.dart';
import 'package:intl/intl.dart';

import 'messages/messages.dart';
import 'utils/utility.dart';

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
  ///
  /// The function computes the time difference between the current time and [dateTime] and returns an appropriate message.
  static String parse(
    DateTime dateTime, {
    String? locale,
    String? pattern,
  }) {
    // Get the locale, if not provided, fallback to the default locale.
    final selectedLocale = locale ?? _defaultLocale;

    // Retrieve the message set for the locale. If not found, fallback to default messages.
    final message = _messageMap[selectedLocale] ?? Data.defaultMessages;

    // Format the dateTime using the provided pattern or the default pattern.
    final formattedDate =
        DateFormat(pattern ?? "dd MMM, yyyy hh:mm aa", locale).format(dateTime);

    // Get the current time for comparison.
    final currentClock = DateTime.now();

    // Calculate the time difference between now and the provided dateTime.
    final elapsed = currentClock.difference(dateTime).abs();

    // Retrieve the prefix and suffix for the time ago message.
    final prefix = message.prefixAgo();
    final suffix = message.suffixAgo();
    String result;

    // Determine the appropriate message based on the elapsed time.
    if (elapsed.inSeconds < 15) {
      // If the time difference is less than 15 seconds, display "just now".
      result = formatMessage(
        '',
        message.justNow(elapsed.inSeconds),
        '',
        message,
      );
    } else if (elapsed.inSeconds < 60) {
      // If the time difference is less than 60 seconds, display the seconds ago message.
      result = formatMessage(
        prefix,
        message.secsAgo(elapsed.inSeconds),
        suffix,
        message,
      );
    } else if (elapsed.inMinutes < 2) {
      // If the time difference is less than 2 minutes, display "a minute ago".
      result = formatMessage(
        prefix,
        message.minAgo(elapsed.inMinutes),
        suffix,
        message,
      );
    } else if (elapsed.inMinutes < 60) {
      // If the time difference is less than 60 minutes, display the minutes ago message.
      result = formatMessage(
        prefix,
        message.minsAgo(elapsed.inMinutes),
        suffix,
        message,
      );
    } else if (elapsed.inHours < 2) {
      // If the time difference is less than 2 hours, display "an hour ago".
      result = formatMessage(
        prefix,
        message.hourAgo(elapsed.inHours),
        suffix,
        message,
      );
    } else if (elapsed.inHours < 24) {
      // If the time difference is less than 24 hours, display the hours ago message.
      result = formatMessage(
        prefix,
        message.hoursAgo(elapsed.inHours),
        suffix,
        message,
      );
    } else if (elapsed.inHours < 48) {
      // If the time difference is less than 48 hours, display "a day ago".
      result = formatMessage(
        prefix,
        message.dayAgo(elapsed.inHours ~/ 24),
        suffix,
        message,
      );
    } else if (elapsed.inDays < 8) {
      // If the time difference is less than 8 days, display the days ago message.
      result = formatMessage(
        prefix,
        message.daysAgo(elapsed.inDays),
        suffix,
        message,
      );
    } else {
      // If the time difference is greater than 7 days, display the formatted date.
      result = formattedDate;
    }

    return result;
  }
}
