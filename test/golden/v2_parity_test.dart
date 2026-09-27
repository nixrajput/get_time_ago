// Reads files from the repository, so it runs on the VM only.
@TestOn('vm')
library;

import 'dart:convert';
import 'dart:io';

import 'package:get_time_ago/get_time_ago.dart';
import 'package:test/test.dart';

const samples = {
  '1s': Duration(seconds: 1),
  '5s': Duration(seconds: 5),
  '30s': Duration(seconds: 30),
  '90s': Duration(seconds: 90),
  '5m': Duration(minutes: 5),
  '25m': Duration(minutes: 25),
  '90m': Duration(minutes: 90),
  '5h': Duration(hours: 5),
  '21h': Duration(hours: 21),
  '30h': Duration(hours: 30),
  '3d': Duration(days: 3),
  '7d': Duration(days: 7),
};

/// Every output that 3.0 changes on purpose: the CLDR plural fixes and `br`
/// dates, listed in MIGRATION.md. Everything else must match 2.4.1 exactly.
/// The fixture was captured on intl 0.20.3, whose date symbols differ from
/// 0.19.0's, so `date` keys assume a fresh resolution.
const changed = <String, Set<String>>{
  'ar': {
    'past.30s',
    'past.25m',
    'past.21h',
    'future.1s',
    'future.5s',
    'future.30s',
    'future.25m',
    'future.21h',
  },
  'ro': {
    'past.30s',
    'past.25m',
    'past.21h',
    'future.1s',
    'future.30s',
    'future.25m',
    'future.21h',
  },
  'en': {'future.1s'},
  'de': {'future.1s'},
  'es': {'future.1s'},
  'fr': {'future.1s'},
  'it': {'future.1s'},
  'nl': {'future.1s'},
  'pt': {'future.1s'},
  'br': {'future.1s', 'date', 'datePattern'},
};

void main() {
  final fixture =
      jsonDecode(File('test/golden/v2_outputs.json').readAsStringSync())
          as Map<String, dynamic>;
  final now = DateTime(2026, 9, 27, 12);
  final old = DateTime(2020, 1, 1, 9, 5);

  for (final MapEntry(key: code, value: v2) in fixture.entries) {
    test('$code matches 2.4.1 except the listed fixes', () {
      final t = GetTimeAgo(locale: code, clock: () => now);
      final v3 = <String, String>{
        for (final MapEntry(:key, :value) in samples.entries) ...{
          'past.$key': t.format(now.subtract(value)),
          'future.$key': t.format(now.add(value)),
        },
        'date': t.format(old),
        'datePattern': t.copyWith(datePattern: 'yyyy-MM-dd EEEE').format(old),
      };
      final v2Flat = <String, String>{
        for (final direction in ['past', 'future'])
          for (final MapEntry(:key, :value)
              in (v2[direction] as Map<String, dynamic>).entries)
            '$direction.$key': value as String,
        'date': v2['date'] as String,
        'datePattern': v2['datePattern'] as String,
      };
      final expectedChanges = changed[code] ?? const {};
      for (final key in v2Flat.keys) {
        if (expectedChanges.contains(key)) {
          expect(
            v3[key],
            isNot(v2Flat[key]),
            reason: '$code $key was meant to change',
          );
        } else {
          expect(v3[key], v2Flat[key], reason: '$code $key');
        }
      }
    });
  }
}
