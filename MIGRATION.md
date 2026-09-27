# Migrating from 2.x to 3.0

3.0 replaces the global, method-per-string API with an immutable formatter and locales defined as data. The call most apps make, `GetTimeAgo.parse(dateTime, locale:, pattern:)`, keeps its exact signature and compiles unchanged. Everything else below is a rename, a replacement, or an output change you should know about.

## API

| 2.x                                                               | 3.0                                                           |
| ----------------------------------------------------------------- | ------------------------------------------------------------- |
| `GetTimeAgo.parse(dt, locale: l, pattern: p)`                     | unchanged                                                     |
| `GetTimeAgo.setDefaultLocale('fr')`                               | `GetTimeAgo.defaults = const GetTimeAgo(locale: 'fr')`        |
| `GetTimeAgo.setCustomLocaleMessages('x', m)`                      | `GetTimeAgo.registerLocale('x', m)`                           |
| `class X implements Messages`                                     | a `TimeAgoLocale` table, or `class X extends TimeAgoMessages` |
| `FutureTimeMessages` mixin                                        | the `future` patterns of each `RelativePatterns`              |
| `Data.defaultLocale`                                              | `GetTimeAgo.defaults.locale`                                  |
| `Data.messagesMap`                                                | `GetTimeAgo.supportedLocales` and `TimeAgoLocales`            |
| `EnglishMessages()` and the other `*Messages` classes             | `TimeAgoLocales.en` and the other constants                   |
| `formatMessage`, `convertToArabicNumbers`, `convertToUrduNumbers` | removed; `Numerals` covers the digit systems                  |

`setDefaultLocale` threw an `ArgumentError` for an unknown code. `GetTimeAgo.defaults` accepts any code, and formatting never throws. An unknown code falls back to its language part, then to `GetTimeAgo.defaults.locale`, then to English. Use `GetTimeAgo.isSupported(code)` if you want the check.

3.0 also raises two floors: the Dart SDK to `^3.13.0` (Flutter 3.47 or newer), and `intl` from `0.18.0` to `0.19.0`. The `intl` range still reaches `<0.21.0`, so it resolves alongside Flutter 3.47's `flutter_localizations`, which requires `intl ^0.20.3`.

## Converting a custom locale

A 2.x custom locale implemented one method per phrase and composed prefix, message and suffix at runtime:

```dart
class CustomMessages implements Messages {
  @override
  String prefixAgo() => '';
  @override
  String suffixAgo() => 'ago';
  @override
  String justNow(int seconds) => 'just now';
  @override
  String secsAgo(int seconds) => '$seconds seconds';
  @override
  String minAgo(int minutes) => 'a minute';
  @override
  String minsAgo(int minutes) => '$minutes minutes';
  @override
  String hourAgo(int minutes) => 'an hour';
  @override
  String hoursAgo(int hours) => '$hours hours';
  @override
  String dayAgo(int hours) => 'a day';
  @override
  String daysAgo(int days) => '$days days';
  @override
  String wordSeparator() => ' ';
}

GetTimeAgo.setCustomLocaleMessages('en', CustomMessages());
```

In 3.0 each phrase is a whole pattern, with `{0}` for the count and one pattern per CLDR plural category. The past and future forms sit side by side:

```dart
GetTimeAgo.registerLocale(
  'en',
  const TimeAgoLocale(
    intlLocale: 'en',
    long: TimeAgoPatterns(
      justNow: 'just now',
      units: {
        TimeUnit.second: RelativePatterns(
          past: Plural(other: '{0} seconds ago'),
          future: Plural(one: 'in {0} second', other: 'in {0} seconds'),
        ),
        TimeUnit.minute: RelativePatterns(
          past: Plural(one: 'a minute ago', other: '{0} minutes ago'),
          future: Plural(one: 'in a minute', other: 'in {0} minutes'),
        ),
        TimeUnit.hour: RelativePatterns(
          past: Plural(one: 'an hour ago', other: '{0} hours ago'),
          future: Plural(one: 'in an hour', other: 'in {0} hours'),
        ),
        TimeUnit.day: RelativePatterns(
          past: Plural(one: 'a day ago', other: '{0} days ago'),
          future: Plural(one: 'in a day', other: 'in {0} days'),
        ),
      },
    ),
  ),
);
```

If you only wanted to change a string or two of a bundled locale, copy it instead:

```dart
GetTimeAgo.registerLocale(
  'en',
  TimeAgoLocales.en.copyWith(
    long: TimeAgoLocales.en.long.copyWith(justNow: 'now'),
  ),
);
```

The unit methods in 2.x were documented as receiving minutes or hours, but always received `1` ([#32](https://github.com/nixrajput/get_time_ago/issues/32)). In 3.0 the count is always in the unit it describes.

## Output changes

Every 2.4.1 output not listed here is pinned by a golden test and is identical in 3.0.

**Plural forms now follow CLDR.** 2.x used one noun form for every count.

| Locale | Input          | 2.4.1           | 3.0                |
| ------ | -------------- | --------------- | ------------------ |
| `ar`   | 11 minutes ago | قبل ١١ دقائق    | قبل ١١ دقيقة       |
| `ar`   | 30 seconds ago | قبل ٣٠ ثوان     | قبل ٣٠ ثانية       |
| `ar`   | 21 hours ago   | قبل ٢١ ساعات    | قبل ٢١ ساعة        |
| `ar`   | in 5 seconds   | بعد ٥ ثوان      | بعد ٥ ثوانٍ         |
| `ro`   | 25 minutes ago | acum 25 minute  | acum 25 de minute  |
| `ro`   | 30 seconds ago | acum 30 secunde | acum 30 de secunde |
| `ro`   | in 21 hours    | peste 21 ore    | peste 21 de ore    |
| `en`   | in 1 second    | in 1 seconds    | in 1 second        |

The same singular fix for "in 1 second" applies to `de`, `es`, `fr`, `it`, `nl`, `pt` and `ro`. In Arabic, minutes, hours and days from 1 to 10 are unchanged, but every future seconds count is not: 1 and 2 now use CLDR's singular and dual forms (بعد ثانية واحدة, بعد ثانيتين), and 3 to 10 read ثوانٍ instead of ثوان. Romanian counts from 1 to 19 are unchanged.

**Future times round instead of truncating.** 2.x measured "now" a few microseconds after you built the date and truncated, so a time 60 seconds away read "in 59 seconds" and one 8 days away read "in 7 days". 3.0 rounds to the nearest second first, so they read "in a minute" and show the date.

**UTC times are shown in local time.** Past the relative window, 2.x formatted a UTC `DateTime` in UTC wall-clock time ([#47](https://github.com/nixrajput/get_time_ago/issues/47)). 3.0 converts it to local time first. Relative text was never affected.

**Locale codes resolve instead of falling back to English.** 2.x matched codes exactly, so `pt_BR`, `de_AT`, `zh_TW`, `fr-FR` and `PT` all printed English "5 minutes ago". 3.0 ignores case and `-` versus `_`, falls back from a region or script to the language, and maps `zh_HK`, `zh_MO` and `zh_Hant` to Traditional Chinese. An unknown code now falls back to `GetTimeAgo.defaults.locale` before English; in 2.x it printed English even after `setDefaultLocale('fr')`.

**`br` dates are Portuguese.** `br` is the ISO code for Breton, so 2.x printed Breton month names next to Portuguese relative text. `br` is now an alias of `pt`, and dates follow.

## New in 3.0

- `style`: `TimeAgoStyle.short` ("5 min. ago") and `TimeAgoStyle.narrow` ("5m ago").
- `maxUnit`: weeks, months and years, opt-in; the default still switches to the date after 7 days.
- `clock`: an injectable "now" ([#48](https://github.com/nixrajput/get_time_ago/issues/48)).
- `datePattern` on `GetTimeAgo.defaults`: a global date pattern ([#49](https://github.com/nixrajput/get_time_ago/issues/49)).
- `nextChange`: when the text will next change, for refreshing a UI.
- Croatian ([#36](https://github.com/nixrajput/get_time_ago/issues/36)).
