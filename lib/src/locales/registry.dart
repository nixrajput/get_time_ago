import '../messages/time_ago_locale.dart';
import '../messages/time_ago_messages.dart';
import 'ar.dart';
import 'de.dart';
import 'en.dart';
import 'es.dart';
import 'fa.dart';
import 'fr.dart';
import 'hi.dart';
import 'hr.dart';
import 'id.dart';
import 'it.dart';
import 'ja.dart';
import 'ko.dart';
import 'ne.dart';
import 'nl.dart';
import 'oc.dart';
import 'pt.dart';
import 'ro.dart';
import 'tr.dart';
import 'ur.dart';
import 'vi.dart';
import 'zh.dart';
import 'zh_tw.dart';

/// The locales bundled with the package, for reading or for basing a custom
/// locale on.
///
/// ```dart
/// GetTimeAgo.registerLocale(
///   'en',
///   TimeAgoLocales.en.copyWith(
///     long: TimeAgoLocales.en.long.copyWith(justNow: 'now'),
///   ),
/// );
/// ```
abstract final class TimeAgoLocales {
  /// Arabic.
  static const TimeAgoLocale ar = arabic;

  /// German.
  static const TimeAgoLocale de = german;

  /// English.
  static const TimeAgoLocale en = english;

  /// Spanish.
  static const TimeAgoLocale es = spanish;

  /// Persian.
  static const TimeAgoLocale fa = persian;

  /// French.
  static const TimeAgoLocale fr = french;

  /// Hindi.
  static const TimeAgoLocale hi = hindi;

  /// Croatian.
  static const TimeAgoLocale hr = croatian;

  /// Indonesian.
  static const TimeAgoLocale id = indonesian;

  /// Italian.
  static const TimeAgoLocale it = italian;

  /// Japanese.
  static const TimeAgoLocale ja = japanese;

  /// Korean.
  static const TimeAgoLocale ko = korean;

  /// Nepali.
  static const TimeAgoLocale ne = nepali;

  /// Dutch.
  static const TimeAgoLocale nl = dutch;

  /// Occitan. Long style only: CLDR has no Occitan relative-time data yet.
  static const TimeAgoLocale oc = occitan;

  /// Portuguese (Brazil).
  static const TimeAgoLocale pt = portuguese;

  /// Romanian.
  static const TimeAgoLocale ro = romanian;

  /// Turkish.
  static const TimeAgoLocale tr = turkish;

  /// Urdu.
  static const TimeAgoLocale ur = urdu;

  /// Vietnamese.
  static const TimeAgoLocale vi = vietnamese;

  /// Chinese, Simplified script.
  static const TimeAgoLocale zh = chineseSimplified;

  /// Chinese, Traditional script.
  static const TimeAgoLocale zhTW = chineseTraditional;
}

const _builtIn = <String, TimeAgoMessages>{
  'ar': TimeAgoLocales.ar,
  'de': TimeAgoLocales.de,
  'en': TimeAgoLocales.en,
  'es': TimeAgoLocales.es,
  'fa': TimeAgoLocales.fa,
  'fr': TimeAgoLocales.fr,
  'hi': TimeAgoLocales.hi,
  'hr': TimeAgoLocales.hr,
  'id': TimeAgoLocales.id,
  'it': TimeAgoLocales.it,
  'ja': TimeAgoLocales.ja,
  'ko': TimeAgoLocales.ko,
  'ne': TimeAgoLocales.ne,
  'nl': TimeAgoLocales.nl,
  'oc': TimeAgoLocales.oc,
  'pt': TimeAgoLocales.pt,
  'ro': TimeAgoLocales.ro,
  'tr': TimeAgoLocales.tr,
  'ur': TimeAgoLocales.ur,
  'vi': TimeAgoLocales.vi,
  'zh': TimeAgoLocales.zh,
  'zh_tw': TimeAgoLocales.zhTW,
};

const _canonical = {'zh_tw': 'zh_TW'};

const _aliases = {
  // 2.x keys. 'br' is ISO 639 Breton, which is why 2.x dates came out in Breton.
  'br': 'pt',
  'zh_tr': 'zh_tw',
  'zh_cn': 'zh',
  'zh_hans': 'zh',
  // CLDR likely subtags put zh-HK and zh-MO in Traditional script.
  'zh_hant': 'zh_tw',
  'zh_hk': 'zh_tw',
  'zh_mo': 'zh_tw',
};

final _registered = <String, TimeAgoMessages>{};
final _registeredNames = <String, String>{};

String _normalize(String code) => code.replaceAll('-', '_').toLowerCase();

/// The locale for [code], trying aliases and then shorter prefixes, or `null`.
TimeAgoMessages? lookupMessages(String code) {
  var key = _normalize(code);
  while (true) {
    // A registration under the exact code wins over what its alias means.
    final canonical = _aliases[key] ?? key;
    final found =
        _registered[key] ?? _registered[canonical] ?? _builtIn[canonical];
    if (found != null) return found;
    final cut = canonical.lastIndexOf('_');
    if (cut <= 0) return null;
    key = canonical.substring(0, cut);
  }
}

/// Makes [code] resolve to [messages], replacing a built-in of the same code.
void registerMessages(String code, TimeAgoMessages messages) {
  final key = _normalize(code);
  _registered[key] = messages;
  _registeredNames[key] = code;
}

/// Built-in codes, then registered ones that are not overrides.
Iterable<String> localeCodes() => [
  for (final key in _builtIn.keys) _canonical[key] ?? key,
  for (final MapEntry(:key, :value) in _registeredNames.entries)
    if (!_builtIn.containsKey(key)) value,
];
