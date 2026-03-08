import '../messages/messages.dart';

/// Utility function [convertToUrduNumbers] to convert an English number
/// into its Urdu numeral equivalent.
/// The function takes an integer [input] and replaces its English digits
/// (0-9) with corresponding Urdu digits.
/// Example: 123 -> '۱۲۳'
String convertToUrduNumbers(int input) {
  // List of English digits
  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

  // List of corresponding Urdu digits
  const urdu = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

  // Convert the input number to a string
  var result = input.toString();

  // Replace each English digit with its Urdu counterpart
  for (var i = 0; i < english.length; i++) {
    result = result.replaceAll(english[i], urdu[i]);
  }

  // Return the result with Urdu digits
  return result;
}

/// Utility function [convertToArabicNumbers] to convert an English number
/// into its Arabic numeral equivalent.
/// The function takes an integer [input] and replaces its English digits
/// (0-9) with corresponding Arabic digits.
/// Example: 123 -> '١٢٣'
String convertToArabicNumbers(int input) {
  // List of English digits
  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

  // List of corresponding Arabic digits
  const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

  // Convert the input number to a string
  var result = input.toString();

  // Replace each English digit with its Arabic counterpart
  for (var i = 0; i < english.length; i++) {
    result = result.replaceAll(english[i], arabic[i]);
  }

  // Return the result with Arabic digits
  return result;
}

/// Helper method [formatMessage] to format a time message by combining the
/// [prefix], [msg] (main message), and [suffix]. The method concatenates the
/// non-empty parts of the message using the [Messages.wordSeparator()] to join them.
/// Example: "about", "5 minutes", "ago" -> "about 5 minutes ago"
String formatMessage(
  String prefix,
  String msg,
  String suffix,
  Messages message,
) {
  // Combine non-empty parts of the message and join them using the word separator
  return [prefix, msg, suffix]
      .where(
          (part) => part.isNotEmpty) // Ensure only non-empty parts are joined
      .join(message.wordSeparator()); // Join parts with the word separator
}

