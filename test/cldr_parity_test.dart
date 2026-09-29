// Reads files from the repository, so it runs on the VM only.
@TestOn('vm')
library;

import 'dart:convert';
import 'dart:io';

import 'package:get_time_ago/src/locales/cldr/ar.g.dart';
import 'package:get_time_ago/src/locales/cldr/de.g.dart';
import 'package:get_time_ago/src/locales/cldr/en.g.dart';
import 'package:get_time_ago/src/locales/cldr/es.g.dart';
import 'package:get_time_ago/src/locales/cldr/fa.g.dart';
import 'package:get_time_ago/src/locales/cldr/fr.g.dart';
import 'package:get_time_ago/src/locales/cldr/hi.g.dart';
import 'package:get_time_ago/src/locales/cldr/hr.g.dart';
import 'package:get_time_ago/src/locales/cldr/id.g.dart';
import 'package:get_time_ago/src/locales/cldr/it.g.dart';
import 'package:get_time_ago/src/locales/cldr/ja.g.dart';
import 'package:get_time_ago/src/locales/cldr/ko.g.dart';
import 'package:get_time_ago/src/locales/cldr/ne.g.dart';
import 'package:get_time_ago/src/locales/cldr/nl.g.dart';
import 'package:get_time_ago/src/locales/cldr/pt.g.dart';
import 'package:get_time_ago/src/locales/cldr/ro.g.dart';
import 'package:get_time_ago/src/locales/cldr/tr.g.dart';
import 'package:get_time_ago/src/locales/cldr/ur.g.dart';
import 'package:get_time_ago/src/locales/cldr/vi.g.dart';
import 'package:get_time_ago/src/locales/cldr/zh.g.dart';
import 'package:get_time_ago/src/locales/cldr/zh_tw.g.dart';
import 'package:get_time_ago/src/messages/time_ago_locale.dart';
import 'package:get_time_ago/src/time_unit.dart';
import 'package:test/test.dart';

import '../tool/cldr/generate.dart' as gen;

typedef Generated = (
  TimeAgoPatterns? long,
  Map<TimeUnit, RelativePatterns>? longUnits,
  TimeAgoPatterns short,
  TimeAgoPatterns narrow,
);

const generated = <String, Generated>{
  'ar': (arLong, null, arShort, arNarrow),
  'de': (null, deLongUnits, deShort, deNarrow),
  'en': (null, null, enShort, enNarrow),
  'es': (null, esLongUnits, esShort, esNarrow),
  'fa': (null, faLongUnits, faShort, faNarrow),
  'fr': (null, frLongUnits, frShort, frNarrow),
  'hi': (null, hiLongUnits, hiShort, hiNarrow),
  'hr': (hrLong, null, hrShort, hrNarrow),
  'id': (null, idLongUnits, idShort, idNarrow),
  'it': (null, itLongUnits, itShort, itNarrow),
  'ja': (null, jaLongUnits, jaShort, jaNarrow),
  'ko': (null, koLongUnits, koShort, koNarrow),
  'ne': (null, neLongUnits, neShort, neNarrow),
  'nl': (null, nlLongUnits, nlShort, nlNarrow),
  'pt': (null, ptLongUnits, ptShort, ptNarrow),
  'ro': (null, roLongUnits, roShort, roNarrow),
  'tr': (null, trLongUnits, trShort, trNarrow),
  'ur': (null, urLongUnits, urShort, urNarrow),
  'vi': (null, viLongUnits, viShort, viNarrow),
  'zh': (null, zhLongUnits, zhShort, zhNarrow),
  'zh_TW': (null, zhTwLongUnits, zhTwShort, zhTwNarrow),
};

Map<String, dynamic> snapshot(String code) =>
    jsonDecode(File('tool/cldr/${gen.version}/$code.json').readAsStringSync())
        as Map<String, dynamic>;

void expectPlural(
  Plural plural,
  Map<String, dynamic> forms,
  (String, String)? wording,
  String where,
) {
  final actual = {
    'zero': plural.zero,
    'one': plural.one,
    'two': plural.two,
    'few': plural.few,
    'many': plural.many,
    'other': plural.other,
  }..removeWhere((_, value) => value == null);
  final expected = <String, String>{};
  for (final MapEntry(:key, :value) in forms.entries) {
    final category = key.replaceFirst('relativeTimePattern-count-', '');
    expected[category] =
        gen.errata['$where $category'] ??
        (wording == null
            ? value as String
            : (value as String).replaceAll(wording.$1, wording.$2));
  }
  expect(actual, expected, reason: where);
}

void expectUnits(
  Map<TimeUnit, RelativePatterns> table,
  Map<String, dynamic> data,
  String suffix,
  List<String> units,
  (String, String)? wording,
  String code,
) {
  expect(
    table.keys.map((unit) => unit.name).toList(),
    units,
    reason: '$code$suffix units',
  );
  for (final unit in units) {
    final patterns = table[TimeUnit.values.byName(unit)]!;
    final fields = data['$unit$suffix'] as Map<String, dynamic>;
    expectPlural(
      patterns.past,
      fields['relativeTime-type-past'] as Map<String, dynamic>,
      null,
      '$code $unit$suffix past',
    );
    expectPlural(
      patterns.future,
      fields['relativeTime-type-future'] as Map<String, dynamic>,
      wording,
      '$code $unit$suffix future',
    );
  }
}

void main() {
  test('every non-skipped CLDR locale has a generated table', () {
    expect(
      generated.keys.toSet(),
      gen.cldrIds.keys.toSet().difference(gen.skipped),
    );
  });

  for (final MapEntry(key: code, value: (long, longUnits, short, narrow))
      in generated.entries) {
    test('$code matches CLDR ${gen.version}', () {
      final data = snapshot(code);
      for (final (suffix, patterns) in [
        ('-short', short),
        ('-narrow', narrow),
      ]) {
        expect(
          patterns.justNow,
          data['second$suffix']['relative-type-0'],
          reason: '$code$suffix now',
        );
        expectUnits(patterns.units, data, suffix, gen.units, null, code);
      }
      final wanted = gen.longUnitsFor(code);
      final wording = gen.futureWording[code];
      if (long != null) {
        expect(long.justNow, data['second']['relative-type-0']);
        expectUnits(long.units, data, '', wanted, wording, code);
      } else if (longUnits != null) {
        expectUnits(longUnits, data, '', wanted, wording, code);
      } else {
        expect(wanted, isEmpty, reason: '$code should generate no long units');
      }
    });
  }

  test('every erratum still corrects CLDR', () {
    // Fails once CLDR fixes one, which is the cue to drop it from the list.
    for (final MapEntry(:key, :value) in gen.errata.entries) {
      final [code, field, direction, category] = key.split(' ');
      final forms = snapshot(code)[field]['relativeTime-type-$direction'];
      final cldr = forms['relativeTimePattern-count-$category'];
      expect(cldr, allOf(isNotNull, isNot(value)), reason: key);
    }
  });

  test('Occitan is still CLDR root placeholders, so it stays skipped', () {
    // Fails the day CLDR ships real Occitan data, which is the cue to generate it.
    Map<String, Object?> relative(Map<String, dynamic> data) => {
      for (final MapEntry(:key, :value) in data.entries) ...{
        '$key.past': value['relativeTime-type-past'],
        '$key.future': value['relativeTime-type-future'],
        '$key.now': value['relative-type-0'],
      },
    };
    expect(relative(snapshot('oc')), relative(snapshot('und')));
  });
}
