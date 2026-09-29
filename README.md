<p align="center">
  <img src="https://raw.githubusercontent.com/nixrajput/get_time_ago/master/assets/logo.svg" width="96" alt="get_time_ago" />
</p>

<h1 align="center">get_time_ago</h1>

<p align="center">"5 minutes ago" in 22 languages, with the plurals right and the clock in your hands.</p>

<p align="center">
  <a href="https://pub.dev/packages/get_time_ago"><img src="https://img.shields.io/pub/v/get_time_ago.svg?label=Version" alt="pub package" /></a>
  <a href="https://github.com/nixrajput/get_time_ago/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/nixrajput/get_time_ago/ci.yml?branch=master&label=CI" alt="CI" /></a>
  <a href="https://pub.dev/packages/get_time_ago/score"><img src="https://img.shields.io/pub/likes/get_time_ago?label=Likes" alt="pub likes" /></a>
  <a href="https://pub.dev/packages/get_time_ago/score"><img src="https://img.shields.io/pub/points/get_time_ago?label=Points" alt="pub points" /></a>
  <a href="https://github.com/nixrajput/get_time_ago/graphs/contributors"><img src="https://img.shields.io/github/contributors/nixrajput/get_time_ago?label=Contributors" alt="contributors" /></a>
  <a href="https://github.com/nixrajput/get_time_ago/blob/master/LICENSE"><img src="https://img.shields.io/github/license/nixrajput/get_time_ago?label=Licence" alt="licence" /></a>
</p>

<p align="center">
  <b>22 locales</b> &nbsp;·&nbsp; <b>3 styles</b> &nbsp;·&nbsp; <b>73 tests</b> &nbsp;·&nbsp; <b>1 runtime dependency</b> &nbsp;·&nbsp; <b>0 Flutter dependencies</b>
</p>

<p align="center">
  <sub>Sampled 2.4.1 outputs for every locale are pinned by a golden test, and every new string is checked against a pinned CLDR snapshot, so the text here is sourced rather than guessed. There is no benchmark: formatting a string is not a speed story.</sub>
</p>

<p align="center">
  <a href="https://nixrajput.github.io/get_time_ago">Live demo</a> &nbsp;·&nbsp;
  <a href="#quick-start">Quick start</a> &nbsp;·&nbsp;
  <a href="#styles">Styles</a> &nbsp;·&nbsp;
  <a href="#units">Units</a> &nbsp;·&nbsp;
  <a href="#locales">Locales</a> &nbsp;·&nbsp;
  <a href="#custom-locales">Custom locales</a> &nbsp;·&nbsp;
  <a href="#is-this-for-you">Is this for you</a> &nbsp;·&nbsp;
  <a href="MIGRATION.md">Migrating from 2.x</a> &nbsp;·&nbsp;
  <a href="https://pub.dev/documentation/get_time_ago/latest/">API reference</a>
</p>

## Table of contents

- [Table of contents](#table-of-contents)
- [Overview](#overview)
- [Demo](#demo)
- [Quick start](#quick-start)
  - [Prerequisites](#prerequisites)
  - [Install](#install)
  - [Format a time](#format-a-time)
- [Styles](#styles)
- [Units](#units)
- [Clock and time zones](#clock-and-time-zones)
- [The full date](#the-full-date)
- [Locales](#locales)
- [Custom locales](#custom-locales)
- [Refreshing the text](#refreshing-the-text)
- [Before and after](#before-and-after)
- [Is this for you](#is-this-for-you)
- [Compared to](#compared-to)
- [FAQ](#faq)
- [Migrating from 2.x](#migrating-from-2x)
- [Contributing](#contributing)
- [Contributors](#contributors)
- [License](#license)
- [Support the project](#support-the-project)
- [Connect](#connect)

## Overview

get_time_ago turns a `DateTime` into relative text: "just now", "5 minutes ago", "in 3 days". It is pure Dart with one dependency, `intl`, so the same code runs in a Flutter app, on a server, in a CLI and on the web.

A `GetTimeAgo` is immutable and takes its "now" from a clock you can replace, so tests are deterministic and a server-corrected time is one argument away. Unknown locale codes never throw: they fall back to the nearest language, then to your default, then to English, which is what you want when the code comes straight from a device.

## Demo

Try every option in the [live web demo](https://nixrajput.github.io/get_time_ago): the locale, the style, the largest unit and the date pattern, with a slider that scrubs a moment across four years and a live row refreshed through `nextChange`. It is the [example app](example/README.md) built for the web; the same app runs on Android, iOS, macOS, Windows and Linux.

## Quick start

### Prerequisites

- Dart SDK `^3.13.0`. Flutter 3.47 or newer bundles a compatible SDK.

### Install

```yaml
dependencies:
  get_time_ago: ^3.0.0
```

Then `dart pub get` or `flutter pub get`, and import it:

```dart
import 'package:get_time_ago/get_time_ago.dart';
```

### Format a time

The one-liner uses the app-wide defaults:

```dart
GetTimeAgo.parse(DateTime.now().subtract(const Duration(minutes: 5)));
// 5 minutes ago

GetTimeAgo.parse(someDate, locale: 'fr');
// il y a 5 minutes
```

Build a formatter when you want to choose more than the locale. It is const, so it can live in a widget or a constant:

```dart
const timeAgo = GetTimeAgo(
  locale: 'hr',
  style: TimeAgoStyle.narrow,
  maxUnit: TimeUnit.year,
);

timeAgo.format(someDate);
```

Change the defaults once, at startup, and every `parse` call follows:

```dart
GetTimeAgo.defaults = const GetTimeAgo(locale: 'de', datePattern: 'd MMM yyyy');
```

## Styles

| Style                         | English       | Source                    |
| ----------------------------- | ------------- | ------------------------- |
| `TimeAgoStyle.long` (default) | 5 minutes ago | 2.x wording, kept exactly |
| `TimeAgoStyle.short`          | 5 min. ago    | CLDR 48.2.2               |
| `TimeAgoStyle.narrow`         | 5m ago        | CLDR 48.2.2               |

"Just now" follows the style too: short and narrow use CLDR's word for now. Occitan has long style only, because CLDR has no Occitan relative-time data yet; asking it for short or narrow gives long.

## Units

By default, times older than 7 days show the full date, as they did in 2.x. `maxUnit` lets the relative text go further:

| `maxUnit`                | Relative text up to  | Then           |
| ------------------------ | -------------------- | -------------- |
| `TimeUnit.day` (default) | 7 days               | the full date  |
| `TimeUnit.week`          | 4 weeks (29 days)    | the full date  |
| `TimeUnit.month`         | 11 months (364 days) | the full date  |
| `TimeUnit.year`          | any age              | never the date |

```dart
const GetTimeAgo(maxUnit: TimeUnit.year)
    .format(DateTime.now().subtract(const Duration(days: 800)));
// 2 years ago
```

Months are 30 days and years are 365 days, so a 31-day month reads as "a month" one day early. The count is always rounded to the nearest second first, so a time that is 60 seconds away reads "in a minute" rather than "in 59 seconds".

## Clock and time zones

`clock` replaces `DateTime.now`. Pass a server-corrected clock when device time cannot be trusted, or a fixed one in tests:

```dart
final timeAgo = GetTimeAgo(clock: () => serverNow());
```

The relative text compares instants, so a UTC `DateTime` and a local one give the same answer. When the full date is shown, it is converted to local time first, so `2020-03-06T20:46:17Z` reads in the reader's time zone.

## The full date

Times beyond `maxUnit` show a date formatted with `intl`'s `DateFormat`, in the formatter's locale:

```dart
const GetTimeAgo(datePattern: 'd MMM yyyy').format(DateTime(2024, 1, 1));
// 1 Jan 2024
```

`GetTimeAgo.defaultDatePattern` is `dd MMM, yyyy hh:mm aa`, the 2.x default. `GetTimeAgo.parse` also takes a `pattern:` for a single call. Where `intl` has no date symbols for a locale, as with Occitan, the date is formatted in English.

## Locales

| Code | Language            | Code    | Language                  |
| ---- | ------------------- | ------- | ------------------------- |
| `ar` | Arabic              | `ja`    | Japanese                  |
| `de` | German              | `ko`    | Korean                    |
| `en` | English             | `ne`    | Nepali                    |
| `es` | Spanish             | `nl`    | Dutch                     |
| `fa` | Persian             | `oc`    | Occitan (long style only) |
| `fr` | French              | `pt`    | Portuguese (Brazil)       |
| `hi` | Hindi               | `ro`    | Romanian                  |
| `hr` | Croatian            | `tr`    | Turkish                   |
| `id` | Indonesian          | `ur`    | Urdu                      |
| `it` | Italian             | `vi`    | Vietnamese                |
| `zh` | Chinese, Simplified | `zh_TW` | Chinese, Traditional      |

Codes are matched loosely. Case and `-` or `_` do not matter, and a region or script falls back to its language, so `en_US`, `pt-PT` and `pt_BR` all work. `zh_HK`, `zh_MO` and `zh_Hant` resolve to Traditional Chinese, following CLDR. The 2.x keys `br` and `zh_tr` still work as aliases.

A code with no match falls back to `GetTimeAgo.defaults.locale`, then to English. Check a code with `GetTimeAgo.isSupported('sv')`, and list them all with `GetTimeAgo.supportedLocales`.

## Custom locales

A locale is a table of patterns, one per unit, direction and CLDR plural category, with `{0}` where the count goes. This Swedish sketch is illustrative, not a vetted translation:

```dart
GetTimeAgo.registerLocale(
  'sv',
  const TimeAgoLocale(
    intlLocale: 'sv',
    long: TimeAgoPatterns(
      justNow: 'just nu',
      units: {
        TimeUnit.minute: RelativePatterns(
          past: Plural(one: 'för {0} minut sedan', other: 'för {0} minuter sedan'),
          future: Plural(one: 'om {0} minut', other: 'om {0} minuter'),
        ),
        // ...the other units
      },
    ),
  ),
);
```

Give only the plural categories the language uses; the rest fall back to `other`. A unit a locale leaves out shows the full date.

To change one string of a bundled locale, copy it:

```dart
GetTimeAgo.registerLocale(
  'en',
  TimeAgoLocales.en.copyWith(
    long: TimeAgoLocales.en.long.copyWith(justNow: 'now'),
  ),
);
```

When a grammar needs logic a table cannot express, extend `TimeAgoMessages` and implement `justNow` and `relative` yourself.

## Refreshing the text

`nextChange` says how long until the text for a time will change, so a UI can refresh exactly then instead of ticking every second:

```dart
Timer? timer;

void schedule() {
  timer?.cancel();
  final wait = timeAgo.nextChange(postedAt);
  if (wait != null) timer = Timer(wait, () => setState(schedule));
}

@override
void dispose() {
  timer?.cancel();
  super.dispose();
}
```

It returns `null` for a past time already shown as a date, because that text never changes again. A ready-made Flutter widget built on this is planned as a separate package.

## Before and after

In 2.x, the default locale was global state and a custom locale implemented every method of `Messages`:

```dart
// 2.x
GetTimeAgo.setDefaultLocale('fr');

class CustomMessages implements Messages {
  @override
  String prefixAgo() => '';
  @override
  String suffixAgo() => 'ago';
  @override
  String minsAgo(int minutes) => '$minutes minutes';
  // ...ten more methods
}
GetTimeAgo.setCustomLocaleMessages('en', CustomMessages());
```

In 3.0, the defaults are one immutable value and a locale is data:

```dart
// 3.0
GetTimeAgo.defaults = const GetTimeAgo(locale: 'fr');

GetTimeAgo.registerLocale('en', TimeAgoLocales.en.copyWith(/* ... */));
```

[MIGRATION.md](MIGRATION.md) maps every 2.x call to its 3.0 equivalent and lists every output that changed.

## Is this for you

Use it for relative timestamps in feeds, chats, notifications, logs and server responses, in any of the 22 languages, in Flutter or plain Dart.

It fits particularly well if you need correct plurals (Arabic, Croatian and Romanian all change their nouns with the count), deterministic tests, or a clock you do not trust.

**Skip it if** you want calendar phrasing such as "yesterday" or "last week"; [`relative_time`](https://pub.dev/packages/relative_time) and [`jiffy`](https://pub.dev/packages/jiffy) do that. Skip it too if you need multi-unit durations such as "2 hours 5 minutes", which [`moment_dart`](https://pub.dev/packages/moment_dart) formats.

## Compared to

**[`timeago`](https://pub.dev/packages/timeago)** is the most used package in this space. It ships message files for many languages but registers only English and Spanish by default, takes a fixed `clock` value rather than a function, and uses fixed thresholds with plural helpers written by hand per locale. It is a good fit when you want the widest set of message files and are happy to register them yourself.

**[`jiffy`](https://pub.dev/packages/jiffy)** is a date library for parsing, manipulating, querying and formatting, and **[`moment_dart`](https://pub.dev/packages/moment_dart)** is an immutable `DateTime` subclass that also formats durations. In both, relative time is one feature among many; reach for them when you need the rest too.

**[`relative_time`](https://pub.dev/packages/relative_time)** generates its locales from CLDR and supports "yesterday"-style phrasing, but it formats through a Flutter `BuildContext`, so it does not run in plain Dart.

**This package** does one thing: relative time, in pure Dart, with CLDR plurals, three styles, an injectable clock and a `nextChange` hook for refreshing UIs.

## FAQ

**Does it work on the web?**
Yes. It is pure Dart with no `dart:io`, and it compiles to JavaScript.

**Why does Occitan show a date where other languages show weeks?**
CLDR, which the new units and styles come from, has no Occitan relative-time data yet, so Occitan has only the four units it had in 2.x. Contributions are welcome.

**What happens with a locale code the package does not know?**
It falls back to the language part of the code, then to `GetTimeAgo.defaults.locale`, then to English. It never throws while formatting.

**Why did my Arabic or Romanian text change in 3.0?**
2.x used one plural form for every count. Arabic needs a different noun form from 11 up, and Romanian adds "de" from 20 up, so 3.0 follows CLDR, the Unicode data that ICU and web browsers format with. [MIGRATION.md](MIGRATION.md) lists every change.

**What do the numbers in the header mean?**
They are the things this package controls and can check: how many languages it speaks, how many styles, and how many tests pin that text down. Formatting a string is too fast to be worth a benchmark.

## Migrating from 2.x

3.0 replaces the global, method-per-string API with an immutable formatter and locales defined as data. The call most apps make, `GetTimeAgo.parse(dateTime, locale:, pattern:)`, keeps its exact signature and compiles unchanged. [MIGRATION.md](MIGRATION.md) maps every 2.x symbol and lists every output change.

## Contributing

Fork the repository, make your changes and open a pull request. Please read [CONTRIBUTING.md](CONTRIBUTING.md) first, and note that every PR must bump the version in `pubspec.yaml` and add a matching `CHANGELOG.md` entry.

## Contributors

Thanks to everyone who has contributed to get_time_ago.

<a href="https://github.com/nixrajput/get_time_ago/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=nixrajput/get_time_ago" alt="Contributors" />
</a>

## License

MIT. See [LICENSE](LICENSE).

## Support the project

<div align="center">

get_time_ago is MIT licensed and free to use, always. If it saves you writing plural rules for another language, sponsorship is welcome.

<br />

<a href="https://github.com/sponsors/nixrajput">
  <img src="https://img.shields.io/badge/Sponsor_on_GitHub-EA4AAA?style=for-the-badge&logo=githubsponsors&logoColor=white" alt="GitHub Sponsors" />
</a>
<a href="https://ko-fi.com/nixrajput">
  <img src="https://img.shields.io/badge/Ko--fi-FF5E5B?style=for-the-badge&logo=kofi&logoColor=white" alt="Ko-fi" />
</a>
<a href="https://www.buymeacoffee.com/nixrajput">
  <img src="https://img.shields.io/badge/Buy_Me_a_Coffee-FFDD00?style=for-the-badge&logo=buymeacoffee&logoColor=black" alt="Buy Me a Coffee" />
</a>

</div>

## Connect

<div align="center">

**Nikhil Rajput**

<a href="https://github.com/nixrajput"><img src="https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white" alt="GitHub" /></a>
<a href="https://linkedin.com/in/nixrajput"><img src="https://img.shields.io/badge/LinkedIn-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn" /></a>
<a href="https://x.com/nixrajput"><img src="https://img.shields.io/badge/X-000000?style=for-the-badge&logo=x&logoColor=white" alt="X" /></a>
<a href="https://instagram.com/nixrajput"><img src="https://img.shields.io/badge/Instagram-E4405F?style=for-the-badge&logo=instagram&logoColor=white" alt="Instagram" /></a>
<a href="https://telegram.me/nixrajput"><img src="https://img.shields.io/badge/Telegram-26A5E4?style=for-the-badge&logo=telegram&logoColor=white" alt="Telegram" /></a>
<a href="mailto:nkr.nikhil.nkr@gmail.com"><img src="https://img.shields.io/badge/Email-EA4335?style=for-the-badge&logo=gmail&logoColor=white" alt="Email" /></a>

</div>
