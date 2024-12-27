# get_time_ago

A Dart package that converts and formats `DateTime` objects into human-readable 'time ago' strings, such as '20 seconds ago', 'a minute ago', or '7 hours ago'. This package provides an easy way to display relative time differences in your Flutter or Dart applications. It supports various time units (seconds, minutes, hours, days, etc.) and automatically adjusts the format based on how recent the event occurred. Ideal for displaying timestamps in news feeds, social media posts, or chat messages.

[![pub package](https://img.shields.io/pub/v/get_time_ago.svg?label=Version&style=flat)][pub]
[![Stars](https://img.shields.io/github/stars/nixrajput/get-time-ago?label=Stars&style=flat)][repo]
[![Forks](https://img.shields.io/github/forks/nixrajput/get-time-ago?label=Forks&style=flat)][repo]
[![Watchers](https://img.shields.io/github/watchers/nixrajput/get-time-ago?label=Watchers&style=flat)][repo]
[![Contributors](https://img.shields.io/github/contributors/nixrajput/get-time-ago?label=Contributors&style=flat)][repo]
[![CI](https://github.com/nixrajput/get-time-ago/workflows/CI/badge.svg?style=flat)][pub]

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/nixrajput/get-time-ago?label=Latest&style=flat)][releases]
[![GitHub last commit](https://img.shields.io/github/last-commit/nixrajput/get-time-ago?label=Last+Commit&style=flat)][repo]
[![GitHub issues](https://img.shields.io/github/issues/nixrajput/get-time-ago?label=Issues&style=flat)][issues]
[![GitHub pull requests](https://img.shields.io/github/issues-pr/nixrajput/get-time-ago?label=Pull+Requests&style=flat)][pulls]
[![GitHub License](https://img.shields.io/github/license/nixrajput/get-time-ago?label=Licence&style=flat)][license]

## Table of Contents

- [get\_time\_ago](#get_time_ago)
  - [Table of Contents](#table-of-contents)
  - [Breaking Changes for the Version ^2.0.0](#breaking-changes-for-the-version-200)
    - [1. Added `justNow` Method in `Messages` Interface](#1-added-justnow-method-in-messages-interface)
    - [Impact on Custom Implementations:](#impact-on-custom-implementations)
    - [Example of Custom Locale Update:](#example-of-custom-locale-update)
  - [Demo](#demo)
    - [Click here to experience the demo in a Web App](#click-here-to-experience-the-demo-in-a-web-app)
  - [Installation](#installation)
  - [Usage](#usage)
    - [Formatting String as `get_time_ago`](#formatting-string-as-get_time_ago)
    - [Setting default locale](#setting-default-locale)
    - [Setting Custom Locale \& Messages](#setting-custom-locale--messages)
  - [Supported Languages](#supported-languages)
  - [Contributing](#contributing)
  - [License](#license)
  - [Support My Work](#support-my-work)
  - [Connect With Me](#connect-with-me)
  - [Activities](#activities)

## Breaking Changes for the Version ^2.0.0

### 1. Added `justNow` Method in `Messages` Interface

In version 2.0.0, a new method `justNow(int seconds)` has been added to the `Messages` interface. This method is responsible for providing a custom message when the elapsed time is less than 15 seconds.

### Impact on Custom Implementations:

If you have implemented any custom locales by extending the `Messages` interface, you will need to update your implementation to include the new `justNow` method. Failing to implement this method will result in compilation errors.

### Example of Custom Locale Update:

Before:

```dart
class MyCustomMessages implements Messages {
  @override
  String prefixAgo() => '';

  @override
  String suffixAgo() => 'ago';

  // Implement the other methods here...
}
```

After (Version 2.0.0):

```dart
class MyCustomMessages implements Messages {
  @override
  String prefixAgo() => '';

  @override
  String suffixAgo() => 'ago';

  @override
  String justNow(int seconds) => 'just now';  // New method

  // Implement the other methods here...
}
```

This section explains the breaking change, the impact it has on custom implementations, and provides an example of how to update existing code to comply with the new changes in version ^2.0.0.

## Demo

### [Click here to experience the demo in a Web App](https://nixrajput.github.io/get_time_ago)

## Installation

Add `get_time_ago` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  get_time_ago: ^latest_version
```

## Usage

Format any `DateTime` object into `get_time_ago` format by following steps:

```dart
// Import the plugin
import 'package:get_time_ago/get_time_ago.dart';

// Pass DateTime object as argument in the method
var _dateTime = DateTime.now().subtract(const Duration(minutes: 10)); // [DateTime] object
print(GetTimeAgo.parse(_dateTime)); // 10 minutes ago

// Formatting with locale
print(GetTimeAgo.parse(_dateTime, locale:'es')); // hace 10 minutos
```

### Formatting String as `get_time_ago`

If you have saved a `DateTime` object as a String into a variable, database or cloud, then you have
to first convert the String into `DateTime` object and then pass it as argument in `parse` method
of `get_time_ago` plugin to format it into `get_time_ago` format by following steps:

```dart
// Import the plugin
import 'package:get_time_ago/get_time_ago.dart';

var _timestamp = '2021-05-10 05:21:37.712498'; // [DateTime] formatted as String.
var _convertedTimestamp = DateTime.parse(_timestamp); // Converting into [DateTime] object
var result = GetTimeAgo.parse(_convertedTimestamp);
print(result);
```

### Setting default locale

If you want to change your default `locale`, then call `setDefaultLocale` method and pass
the `locale` code as the argument.

```dart
// Import the plugin
import 'package:get_time_ago/get_time_ago.dart';

@override
void initState() {
  super.initState();
  GetTimeAgo.setDefaultLocale('fr'); // Sets the default locale to French
}
```

### Setting Custom Locale & Messages

Implementing and Adding Custom Messages

```dart
class CustomMessages implements Messages {
  /// Prefix added before the time message.
  @override
  String prefixAgo() => '';

  /// Suffix added after the time message.
  @override
  String suffixAgo() => 'ago';

  /// Message when the elapsed time is less than 15 seconds.
  @override
  String justNow(int seconds) => 'just now';

  /// Message for when the elapsed time is less than a minute.
  @override
  String secsAgo(int seconds) => '$seconds seconds';

  /// Message for when the elapsed time is about a minute.
  @override
  String minAgo(int minutes) => 'a minute';

  /// Message for when the elapsed time is in minutes.
  @override
  String minsAgo(int minutes) => '$minutes minutes';

  /// Message for when the elapsed time is about an hour.
  @override
  String hourAgo(int minutes) => 'an hour';

  /// Message for when the elapsed time is in hours.
  @override
  String hoursAgo(int hours) => '$hours hours';

  /// Message for when the elapsed time is about a day.
  @override
  String dayAgo(int hours) => 'a day';

  /// Message for when the elapsed time is in days.
  @override
  String daysAgo(int days) => '$days days';

  /// Word separator to be used when joining the parts of the message.
  @override
  String wordSeparator() => ' ';
}
```

Overriding `en` Locale Messages with Custom Messages

```dart
GetTimeAgo.setCustomLocaleMessages('en', CustomMessages());
```

### Minimum Variance Unit

With the addition of the `minimumVarianceUnit` parameter, you can now control how recently past events are displayed before switching to standard time ago strings. For example:

- If you specify `TimeVarianceUnit.minutes`, the output will show **"Less than a minute"** until 60 seconds have elapsed, at which point it will switch to **"a minute ago"**.
- If no variance unit is specified, the behavior defaults to the original "time ago" logic.

```dart
import 'package:get_time_ago/get_time_ago.dart';

// Example: Default behavior
final now = DateTime.now();
final fiveSecondsAgo = now.subtract(Duration(seconds: 5));
print(GetTimeAgo.parse(fiveSecondsAgo)); // Output: "Just now"

// Example: With minimumVarianceUnit set to minutes
final thirtySecondsAgo = now.subtract(Duration(seconds: 30));
print(GetTimeAgo.parse(thirtySecondsAgo, minimumVarianceUnit: TimeVarianceUnit.minutes));
// Output: "Less than a minute"

// Example: Five minutes ago with minutes variance
final fiveMinutesAgo = now.subtract(Duration(minutes: 5));
print(GetTimeAgo.parse(fiveMinutesAgo, minimumVarianceUnit: TimeVarianceUnit.minutes));
// Output: "5 minutes ago"
```

## Supported Languages

- Arabic
- English
- Spanish
- Persian (Farsi)
- French
- Hindi
- Portuguese (Brazil)
- Portuguese (Brazil alternate)
- Simplified Chinese
- Traditional Chinese
- Japanese
- Occitan
- Korean
- German
- Indonesian
- Turkish
- Urdu
- Vietnamese
- Romanian
- Dutch
- Open to accept PR for adding more languages

## Contributing

If you would like to contribute to this project, feel free to fork the repository, make your changes, and submit a pull request. Please follow the guidelines in the [CONTRIBUTING.md](CONTRIBUTING.md) file.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support My Work

Your support helps me dedicate more time to developing high-quality, impactful projects in the open-source community. Sponsor me, and together, let’s bring even more innovation to life!

[![Sponsor](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=%23fe8e86)](https://github.com/sponsors/nixrajput)

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/nixrajput)

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/nixrajput)

## Connect With Me

[![GitHub: nixrajput](https://img.shields.io/badge/nixrajput-EFF7F6?logo=GitHub&logoColor=333&link=https://www.github.com/nixrajput)][github]
[![Linkedin: nixrajput](https://img.shields.io/badge/nixrajput-EFF7F6?logo=LinkedIn&logoColor=blue&link=https://www.linkedin.com/in/nixrajput)][linkedin]
[![Instagram: nixrajput](https://img.shields.io/badge/nixrajput-EFF7F6?logo=Instagram&link=https://www.instagram.com/nixrajput)][instagram]
[![Twitter: nixrajput07](https://img.shields.io/badge/nixrajput07-EFF7F6?logo=X&logoColor=333&link=https://x.com/nixrajput07)][twitter]
[![Telegram: nixrajput](https://img.shields.io/badge/nixrajput-EFF7F6?logo=Telegram&link=https://telegram.me/nixrajput)][telegram]
[![Gmail: nkr.nikhi.nkr@gmail.com](https://img.shields.io/badge/nkr.nikhil.nkr@gmail.com-EFF7F6?logo=Gmail&link=mailto:nkr.nikhil.nkr@gmail.com)][gmail]

## Activities

![Alt](https://repobeats.axiom.co/api/embed/cbde7baa03c95d2e3261af1fa679d94570341b08.svg "Repobeats analytics image")

[pub]: https://pub.dev/packages/get_time_ago
[github]: https://github.com/nixrajput
[telegram]: https://telegram.me/nixrajput
[twitter]: https://twitter.com/nixrajput07
[instagram]: https://instagram.com/nixrajput
[linkedin]: https://linkedin.com/in/nixrajput
[gmail]: mailto:nkr.nikhil.nkr@gmail.com
[releases]: https://github.com/nixrajput/get-time-ago/releases
[repo]: https://github.com/nixrajput/get-time-ago
[issues]: https://github.com/nixrajput/get-time-ago/issues
[license]: https://github.com/nixrajput/get-time-ago/blob/master/LICENSE
[pulls]: https://github.com/nixrajput/get-time-ago/pulls
