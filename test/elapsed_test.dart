import 'package:get_time_ago/src/elapsed.dart';
import 'package:get_time_ago/src/time_unit.dart';
import 'package:test/test.dart';

const minute = 60, hour = 3600, day = 86400;

void main() {
  group('roundSeconds', () {
    test('rounds halves away from zero', () {
      expect(roundSeconds(1499999), 1);
      expect(roundSeconds(1500000), 2);
      expect(roundSeconds(-499999), 0);
      expect(roundSeconds(-500000), -1);
      expect(roundSeconds(-1500000), -2);
    });

    test(
      'a few microseconds short of a minute still reads as a minute (4.2)',
      () {
        expect(roundSeconds(60 * 1000000 - 3), 60);
      },
    );
  });

  group('unitFor with maxUnit day (2.x thresholds)', () {
    final cases = <int, (TimeUnit, int)?>{
      0: (TimeUnit.second, 0),
      59: (TimeUnit.second, 59),
      60: (TimeUnit.minute, 1),
      119: (TimeUnit.minute, 1),
      120: (TimeUnit.minute, 2),
      hour - 1: (TimeUnit.minute, 59),
      hour: (TimeUnit.hour, 1),
      90 * minute: (TimeUnit.hour, 1),
      day - 1: (TimeUnit.hour, 23),
      day: (TimeUnit.day, 1),
      30 * hour: (TimeUnit.day, 1),
      8 * day - 1: (TimeUnit.day, 7),
      8 * day: null,
    };
    for (final MapEntry(key: seconds, value: expected) in cases.entries) {
      test('$seconds s', () {
        final got = unitFor(seconds, TimeUnit.day);
        expect(got == null ? null : (got.unit, got.count), expected);
      });
    }

    test('maxUnit below day behaves like day', () {
      expect(unitFor(3 * day, TimeUnit.second), (unit: TimeUnit.day, count: 3));
      expect(unitFor(8 * day, TimeUnit.hour), isNull);
    });
  });

  group('unitFor with larger units', () {
    (TimeUnit, int)? at(int days, TimeUnit max) {
      final got = unitFor(days * day, max);
      return got == null ? null : (got.unit, got.count);
    }

    test('week', () {
      expect(at(6, TimeUnit.week), (TimeUnit.day, 6));
      expect(at(7, TimeUnit.week), (TimeUnit.week, 1));
      expect(at(29, TimeUnit.week), (TimeUnit.week, 4));
      expect(at(30, TimeUnit.week), isNull);
    });

    test('month', () {
      expect(at(30, TimeUnit.month), (TimeUnit.month, 1));
      expect(at(59, TimeUnit.month), (TimeUnit.month, 1));
      expect(at(60, TimeUnit.month), (TimeUnit.month, 2));
      expect(at(364, TimeUnit.month), (TimeUnit.month, 11));
      expect(at(365, TimeUnit.month), isNull);
    });

    test('year never falls back to the date', () {
      expect(at(365, TimeUnit.year), (TimeUnit.year, 1));
      expect(at(730, TimeUnit.year), (TimeUnit.year, 2));
      expect(at(3000000, TimeUnit.year), (TimeUnit.year, 8219));
    });
  });

  group('nextCandidate', () {
    test('past', () {
      expect(nextCandidate(0, TimeUnit.day), justNowSeconds);
      expect(nextCandidate(20, TimeUnit.day), 21);
      expect(nextCandidate(5 * minute + 7, TimeUnit.day), 6 * minute);
      expect(nextCandidate(5 * hour, TimeUnit.day), 6 * hour);
      expect(nextCandidate(3 * day + 5, TimeUnit.day), 4 * day);
      expect(nextCandidate(9 * day, TimeUnit.day), isNull);
    });

    test('future counts down', () {
      expect(nextCandidate(-1, TimeUnit.day), 0);
      expect(nextCandidate(-45, TimeUnit.day), -44);
      expect(nextCandidate(-5 * minute, TimeUnit.day), -(5 * minute - 1));
      expect(
        nextCandidate(-(5 * minute + 30), TimeUnit.day),
        -(5 * minute - 1),
      );
      expect(nextCandidate(-20 * day, TimeUnit.day), -(8 * day - 1));
      expect(nextCandidate(-40 * day, TimeUnit.week), -(30 * day - 1));
    });
  });

  test('firstMicrosAt is where roundSeconds first reaches the target', () {
    for (final target in [-300, -1, 0, 1, 15, 360]) {
      final at = firstMicrosAt(target);
      expect(roundSeconds(at), target, reason: 'at $target');
      expect(roundSeconds(at - 1), target - 1, reason: 'before $target');
    }
  });
}
