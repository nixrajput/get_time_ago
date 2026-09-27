import 'dart:math' as math;

import 'time_unit.dart';

/// Past times closer than this many seconds read as "just now".
const justNowSeconds = 15;

const _minute = 60;
const _hour = 60 * _minute;
const _day = 24 * _hour;

/// [micros] rounded to whole seconds, halves away from zero.
///
/// Rounding once, here, stops a few microseconds of call latency from turning
/// "in 60 seconds" into "in 59 seconds".
int roundSeconds(int micros) => micros >= 0
    ? (micros + 500000) ~/ 1000000
    : -((500000 - micros) ~/ 1000000);

/// The unit and count for [seconds] of elapsed time, or `null` once the time
/// is beyond what [maxUnit] allows and the full date should show instead.
({TimeUnit unit, int count})? unitFor(int seconds, TimeUnit maxUnit) {
  if (seconds < _minute) return (unit: TimeUnit.second, count: seconds);
  if (seconds < _hour) {
    return (unit: TimeUnit.minute, count: seconds ~/ _minute);
  }
  if (seconds < _day) return (unit: TimeUnit.hour, count: seconds ~/ _hour);
  final days = seconds ~/ _day;
  // 2.x showed "7 days" before switching to the date, so days-only stops at 8.
  if (maxUnit.index <= TimeUnit.day.index) {
    return days < 8 ? (unit: TimeUnit.day, count: days) : null;
  }
  if (days < 7) return (unit: TimeUnit.day, count: days);
  if (days < 30) return (unit: TimeUnit.week, count: days ~/ 7);
  if (maxUnit == TimeUnit.week) return null;
  // ponytail: 30-day months and 365-day years, so a 31-day month reads as
  // "a month" a day early. Calendar arithmetic if exact months are ever needed.
  if (days < 365) {
    return (unit: TimeUnit.month, count: math.min(days ~/ 30, 11));
  }
  if (maxUnit == TimeUnit.month) return null;
  return (unit: TimeUnit.year, count: days ~/ 365);
}

/// The next signed second after [seconds] at which the text might change, or
/// `null` when it never will: a past time already shown as a date.
///
/// Only a candidate. The caller re-renders and keeps stepping while the text
/// stays the same, which is what keeps custom locales exact.
int? nextCandidate(int seconds, TimeUnit maxUnit) {
  if (seconds >= 0) {
    if (seconds < justNowSeconds) return justNowSeconds;
    final unit = unitFor(seconds, maxUnit)?.unit;
    if (unit == null) return null;
    final size = _seconds(unit);
    // A unit's range can end before its next multiple, as weeks do at 30 days.
    return [
      (seconds ~/ size + 1) * size,
      for (final threshold in _thresholds)
        if (threshold > seconds) threshold,
    ].reduce(math.min);
  }
  final left = -seconds;
  final unit = unitFor(left, maxUnit)?.unit;
  if (unit == null) return -(_windowDays(maxUnit) * _day - 1);
  final size = _seconds(unit);
  return -((left ~/ size) * size - 1);
}

/// Where one unit hands over to the next, or to the full date.
const _thresholds = [7 * _day, 8 * _day, 30 * _day, 365 * _day];

int _seconds(TimeUnit unit) => switch (unit) {
  TimeUnit.second => 1,
  TimeUnit.minute => _minute,
  TimeUnit.hour => _hour,
  TimeUnit.day => _day,
  TimeUnit.week => 7 * _day,
  TimeUnit.month => 30 * _day,
  TimeUnit.year => 365 * _day,
};

/// The day count at which [unitFor] starts returning `null`.
int _windowDays(TimeUnit maxUnit) => switch (maxUnit) {
  TimeUnit.week => 30,
  TimeUnit.month => 365,
  _ => 8,
};

/// The first elapsed-microseconds value whose [roundSeconds] is [target].
int firstMicrosAt(int target) =>
    target > 0 ? target * 1000000 - 500000 : target * 1000000 - 499999;
