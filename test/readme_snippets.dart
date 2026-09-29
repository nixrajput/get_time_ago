// Every ```dart block in README.md appears in this file verbatim, so the
// analyzer compiles it; readme_test.dart checks the match.
// ignore_for_file: unused_element, unused_local_variable

import 'dart:async';

import 'package:get_time_ago/get_time_ago.dart';

// dart format off

// A variable, as the reader's own clock would be, so the formatter is not const.
final DateTime Function() serverNow = DateTime.now;

void _parse(DateTime someDate) {
GetTimeAgo.parse(DateTime.now().subtract(const Duration(minutes: 5)));
// 5 minutes ago

GetTimeAgo.parse(someDate, locale: 'fr');
// il y a 5 minutes
}

void _formatter(DateTime someDate) {
const timeAgo = GetTimeAgo(
  locale: 'hr',
  style: TimeAgoStyle.narrow,
  maxUnit: TimeUnit.year,
);

timeAgo.format(someDate);
}

void _defaults() {
GetTimeAgo.defaults = const GetTimeAgo(locale: 'de', datePattern: 'd MMM yyyy');
}

void _units() {
const GetTimeAgo(maxUnit: TimeUnit.year)
    .format(DateTime.now().subtract(const Duration(days: 800)));
// 2 years ago
}

void _clock() {
final timeAgo = GetTimeAgo(clock: serverNow);
}

void _date() {
const GetTimeAgo(datePattern: 'd MMM yyyy').format(DateTime(2024, 1, 1));
// 1 Jan 2024
}

void _customLocale() {
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
}

void _copyLocale() {
GetTimeAgo.registerLocale(
  'en',
  TimeAgoLocales.en.copyWith(
    long: TimeAgoLocales.en.long.copyWith(justNow: 'now'),
  ),
);
}

abstract class _State {
  void setState(void Function() fn) => fn();
  void dispose() {}
}

class _Refresh extends _State {
  _Refresh(this.timeAgo, this.postedAt);
  final GetTimeAgo timeAgo;
  final DateTime postedAt;

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
}

void _after() {
// 3.0
GetTimeAgo.defaults = const GetTimeAgo(locale: 'fr');

GetTimeAgo.registerLocale('en', TimeAgoLocales.en.copyWith(/* ... */));
}
