# Changelog

## [3.0.0]

A rewrite around an immutable formatter and locales defined as data. `GetTimeAgo.parse(dateTime, locale:, pattern:)` keeps its signature; see [MIGRATION.md](MIGRATION.md) for everything else.

- **Breaking:** `GetTimeAgo` is now an immutable, const-constructible formatter with `locale`, `style`, `maxUnit`, `datePattern` and `clock`, and a `format` method. `GetTimeAgo.defaults` replaces `setDefaultLocale`, and `registerLocale` replaces `setCustomLocaleMessages`.
- **Breaking:** `Messages`, `FutureTimeMessages`, `Data`, every `*Messages` class, `formatMessage`, `convertToArabicNumbers` and `convertToUrduNumbers` are removed. Custom locales are a `TimeAgoLocale` table or a `TimeAgoMessages` subclass, and the bundled ones are `TimeAgoLocales.en` and so on.
- **Breaking:** the SDK floor is now Dart `^3.13.0` (Flutter 3.47 or newer), and the `intl` floor rises from `0.18.0` to `0.19.0` (the range still reaches `<0.21.0`).
- **Added:** `TimeAgoStyle.short` ("5 min. ago") and `TimeAgoStyle.narrow` ("5m ago"), generated from CLDR 48.2.2 for every locale except Occitan, which CLDR does not cover.
- **Added:** weeks, months and years through `maxUnit`, opt-in. The default still shows the full date after 7 days. ([#20](https://github.com/nixrajput/get_time_ago/issues/20))
- **Added:** an injectable `clock`. ([#48](https://github.com/nixrajput/get_time_ago/issues/48))
- **Added:** a global date pattern through `GetTimeAgo.defaults`. ([#49](https://github.com/nixrajput/get_time_ago/issues/49))
- **Added:** `nextChange`, the time until the text next changes, for refreshing a UI exactly when needed.
- **Added:** Croatian (`hr`), from CLDR. ([#36](https://github.com/nixrajput/get_time_ago/issues/36))
- **Added:** loose locale matching. Case and `-`/`_` are ignored, a region or script falls back to its language, `zh_HK`/`zh_MO`/`zh_Hant` resolve to Traditional Chinese, and an unknown code falls back instead of throwing.
- **Fixed:** unit messages received `1` instead of the count their parameters described; every unit now receives its real count. ([#32](https://github.com/nixrajput/get_time_ago/issues/32))
- **Fixed:** Arabic plural nouns from 11 up, and for seconds, now follow CLDR ("قبل ١١ دقيقة", not "قبل ١١ دقائق").
- **Fixed:** Romanian adds "de" from 20 up ("acum 25 de minute").
- **Fixed:** "in 1 seconds" is now "in 1 second" in `en`, `de`, `es`, `fr`, `it`, `nl`, `pt` and `ro`.
- **Fixed:** future times lost a unit to truncation ("in 59 seconds" for a minute away); the elapsed time is now rounded to the nearest second.
- **Fixed:** UTC times past the relative window were shown in UTC wall-clock time; they are now shown in local time. ([#47](https://github.com/nixrajput/get_time_ago/issues/47))
- **Fixed:** the `br` key formatted dates in Breton; it is now an alias of `pt`.
- **Fixed:** `ItalianMessages` and `NepaliMessages` were not exported; every bundled locale is now reachable through `TimeAgoLocales`.
- **Chore:** a golden test pins sampled 2.4.1 outputs for every locale, past and future, to catch any change not listed above, and a parity test keeps the CLDR-generated tables equal to the pinned snapshot, apart from two Arabic short-style strings that CLDR gets wrong.

## [2.4.1]

- **Fixed**: Improved Japanese (ja) locale messages.

## [2.4.0]

- **Chore:** Automated release pipeline — merges to `master` tag the version and publish to pub.dev, with CI enforcing (at PR time) a version bump ahead of the latest published release and a matching CHANGELOG entry. No API changes; rolls up the fixes since 2.3.2.

## [2.3.4]

- **Fixed:** Future dates are now formatted as relative future time (e.g. `in 20 seconds`) instead of incorrectly showing as past. ([#52](https://github.com/nixrajput/get_time_ago/issues/52))
- **Added:** Optional `FutureTimeMessages` mixin for locale-specific future formatting (`prefixFromNow` / `suffixFromNow`). Bundled locales use this mixin. Custom locales that only `implement Messages` remain compatible and fall back to `in` / empty suffix for future dates.

## [2.3.2]

- **Added:** Improved German (de) locale messages.

## [2.3.1]

- **Fixed:** Correction text in zh_tw_msg.dart

## [2.3.0]

- **Added:** Support for Italian (it) locale.
- **Updated:** Documentation for new locale.
- **Fixed:** Issue with locale in `DateFormat` method of `intl` package. ([#43](https://github.com/nixrajput/get_time_ago/issues/43))

## [2.2.0]

- **Added:** Support for Nepali (ne) locale.
- **Updated:** Documentation for new locale.
- **Improved:** Updated and added new test cases.

## [2.1.2]

- **Updated:** Dependencies.

## [2.1.1]

- **Fixed:** Issue with the demo web app.
- **Security:** Added `SECURITY.md` for reporting vulnerabilities and ensuring security best practices.
- **Enhanced:** Added a pull request template for standardized contribution checks.

## [2.1.0]

- **Added:** Support for Dutch (nl) locale.
- **Updated:** Dependencies.
- **Fixed:** All known bugs and issues.

## [2.0.0]

- **Breaking:** Introduced `justNow` method to display times less than 15 seconds.
- **Updated:** Documentation for breaking changes.
- **Improved:** Added comments to classes, messages, data, and utility functions.
- **Improved:** Updated and added new test cases.

## [1.3.1]

- **Fixed:** Lint errors and warnings.

## [1.3.0]

- **Updated:** Dependencies.
- **Updated:** Documentation to include all contributors.
- **Fixed:** All known bugs and issues.

## [1.2.5]

- **Changed:** License updated to MIT.
- **Added:** Support for Romanian (ro) locale.
- **Updated:** Dependencies.
- **Fixed:** All known bugs and issues.

## [1.2.4]

- **Added:** Support for Persian (fa) locale.
- **Fixed:** All known bugs and issues.

## [1.2.3]

- **Updated:** `intl` package version.
- **Removed:** Unnecessary dependencies.
- **Fixed:** All known bugs and issues.

## [1.2.2]

- **Removed:** Unnecessary dependencies.
- **Fixed:** All known bugs and issues.

## [1.2.1]

- **Updated:** Documentation.
- **Fixed:** All known bugs and issues.

## [1.2.0]

- **Updated:** `intl` package version.
- **Fixed:** All known bugs.

## [1.1.8]

- **Added:** Support for Vietnamese (vi) locale.
- **Fixed:** All known issues.

## [1.1.7]

- **Added:** Urdu (ur) and Arabic (ar) locale support.
- **Added:** Utility functions to convert English numbers to Urdu and Arabic numbers.
- **Updated:** Tests and documentation.
- **Fixed:** All known bugs.

## [1.1.6]

- **Updated:** Project structure.
- **Added:** Method to override `DefaultMessages`.
- **Added:** Method to add custom locales and messages.
- **Removed:** Unnecessary code.
- **Updated:** Documentation.

## [1.1.5]

- **Added:** Turkish (tr) locale support.
- **Fixed:** Minor bugs.

## [1.1.4]

- **Fixed:** Minor bugs.
- **Improved:** Performance.

## [1.1.3]

- **Added:** Indonesian (id) locale support.
- **Fixed:** Bugs.
- **Updated:** Documentation.

## [1.1.2]

- **Fixed:** Bugs.
- **Updated:** Documentation.

## [1.1.1]

- **Added:** Traditional Chinese (zh_tr) locale support.
- **Fixed:** Bugs.
- **Updated:** Documentation.

## [1.1.0]

- **Added:** German (de) locale support.
- **Fixed:** Bugs.
- **Updated:** Documentation.

## [1.0.9]

- **Added:** Korean (ko) locale support.
- **Fixed:** Bugs.

## [1.0.8]

- **Fixed:** Bugs.
- **Improved:** Performance and source code optimization.

## [1.0.7+1]

- **Fixed:** Minor bugs.
- **Improved:** Performance.

## [1.0.7]

- **Added:** Occitan (oc) locale support.
- **Fixed:** Minor bugs and corrections in French locale.

## [1.0.6]

- **Added:** Japanese (ja) locale support.
- **Added:** Customizable `DateFormat` pattern argument.
- **Updated:** Documentation and screenshots for Android.
- **Fixed:** Minor bugs.
- **Improved:** Performance.

## [1.0.5]

- **Updated:** Documentation.

## [1.0.4]

- **Improved:** Performance.
- **Added:** Time display with date.

## [1.0.3]

- **Renamed:** Default class to `GetTimeAgo` and method `getTimeAgo` to `parse`.
- **Updated:** Documentation.

## [1.0.2]

- **Optimized:** Source code.
- **Updated:** Documentation.

## [1.0.1]

- **Added:** Simplified Chinese (zh) locale support.
- **Fixed:** Minor bugs.
- **Optimized:** Source code.
- **Updated:** Documentation.

## [1.0.0]

- **Added:** Null Safety support.
- **Fixed:** Minor bugs.
- **Improved:** Performance.

## [0.1.7]

- **Fixed:** Bugs.
- **Improved:** Performance.

## [0.1.6]

- **Fixed:** Minor bugs.

## [0.1.3]

- **Fixed:** Minor bugs.
- **Optimized:** Source code.
- **Updated:** Example for better illustration.

## [0.1.2]

- **Fixed:** Minor bugs.
- **Updated:** Documentation.

## [0.1.1]

- **Fixed:** Minor bugs.
- **Updated:** Documentation and examples.

## [0.1.0]

- **Added:** Support for English (en), Spanish (es), French (fr), Hindi (hi), Portuguese (pt), and Brazilian (br) locales.
- **Optimized:** Source code.
- **Fixed:** Minor bugs.
- **Updated:** Documentation and examples.

## [0.0.7]

- **Fixed:** Minor bugs.

## [0.0.6]

- **Fixed:** Bugs.
- **Updated:** Example.

## [0.0.5]

- **Updated:** Screenshots.

## [0.0.4]

- **Added:** Implementation example and Android screenshots.
- **Fixed:** Bugs.

## [0.0.3]

- **Made:** `getTimeAgo()` function static.

## [0.0.2]

- **Updated:** Functionality to use `TimeAgo.getTimeAgo` for formatting.

## [0.0.1]

- Initial release.
