import 'package:get_time_ago/src/messages/languages/ne_msg.dart';

import '../messages/languages/ar_msg.dart';
import '../messages/languages/de_msg.dart';
import '../messages/languages/en_msg.dart';
import '../messages/languages/es_msg.dart';
import '../messages/languages/fa_msg.dart';
import '../messages/languages/fr_msg.dart';
import '../messages/languages/hi_msg.dart';
import '../messages/languages/id_msg.dart';
import '../messages/languages/ja_msg.dart';
import '../messages/languages/ko_msg.dart';
import '../messages/languages/nl_msg.dart';
import '../messages/languages/oc_msg.dart';
import '../messages/languages/pt_br_msg.dart';
import '../messages/languages/ro_msg.dart';
import '../messages/languages/tr_msg.dart';
import '../messages/languages/ur_msg.dart';
import '../messages/languages/vi_msg.dart';
import '../messages/languages/zh_cn_msg.dart';
import '../messages/languages/zh_tw_msg.dart';
import '../messages/messages.dart';

/// The [Data] class holds all constant and runtime data used in the package.
/// This includes default locale settings, default messages, and a map of supported
/// locales along with their corresponding [Messages] implementations.
class Data {
  // The default locale for the package, set to English ('en').
  static const String defaultLocale = 'en';

  // The default set of messages (English) used if no locale is specified or if a locale is not found.
  static final Messages defaultMessages = EnglishMessages();

  // A map that associates various locale codes with their respective [Messages] objects.
  // Each entry corresponds to a language, with the locale code as the key and the [Messages]
  // implementation for that language as the value.
  static final Map<String, Messages> messagesMap = {
    'ar': ArabicMessages(), // Arabic
    'en': EnglishMessages(), // English
    'es': EspanaMessages(), // Spanish
    'fa': PersianMessages(), // Persian (Farsi)
    'fr': FrenchMessages(), // French
    'hi': HindiMessages(), // Hindi
    'pt': PortugueseBrazilMessages(), // Portuguese (Brazil)
    'br': PortugueseBrazilMessages(), // Portuguese (Brazil alternate)
    'zh': SimplifiedChineseMessages(), // Simplified Chinese
    'zh_tr': TraditionalChineseMessages(), // Traditional Chinese
    'ja': JapaneseMessages(), // Japanese
    'oc': OccitanMessages(), // Occitan
    'ko': KoreanMessages(), // Korean
    'de': GermanMessages(), // German
    'id': IndonesianMessages(), // Indonesian
    'tr': TurkishMessages(), // Turkish
    'ur': UrduMessages(), // Urdu
    'vi': VietnameseMessages(), // Vietnamese
    'ro': RomanianMessages(), // Romanian
    'nl': DutchMessages(), // Dutch
    "ne": NepaliMessages(), // Nepali
  };
}
