// Reads files from the repository, so it runs on the VM only.
@TestOn('vm')
library;

import 'dart:io';

import 'package:get_time_ago/get_time_ago.dart';
import 'package:test/test.dart';

/// Guards the README's internal consistency, which drifts silently otherwise.
void main() {
  final raw = File('README.md').readAsStringSync();
  // A '#' inside a fence is a shell comment or a hex colour, not a heading.
  final body = raw.replaceAll(RegExp(r'```[\s\S]*?```'), '');

  String slug(String heading) => heading
      .toLowerCase()
      .replaceAll(RegExp('[^a-z0-9 -]'), '')
      .trim()
      .replaceAll(RegExp(r'\s+'), '-');

  final headings = RegExp(
    r'^##+ (.+)$',
    multiLine: true,
  ).allMatches(body).map((m) => slug(m.group(1)!)).toSet();

  final tocLinks = RegExp(
    r'^\s*- \[[^\]]+\]\(#([^)]+)\)',
    multiLine: true,
  ).allMatches(body).map((m) => m.group(1)!).toSet();

  test('every table-of-contents entry points at a real heading', () {
    expect(
      tocLinks.difference(headings),
      isEmpty,
      reason: 'TOC entries with no matching heading',
    );
  });

  test('every heading appears in the table of contents', () {
    const exempt = {'table-of-contents'};
    expect(
      headings.difference(tocLinks).difference(exempt),
      isEmpty,
      reason: 'headings missing from the TOC',
    );
  });

  test('every link reference is defined and used', () {
    final defined = RegExp(
      r'^\[([^\]]+)\]:',
      multiLine: true,
    ).allMatches(raw).map((m) => m.group(1)!).toSet();
    final used = RegExp(r'\]\[([^\]]+)\]')
        .allMatches(raw)
        .map((m) => m.group(1)!)
        .toSet();

    expect(used.difference(defined), isEmpty, reason: 'undefined references');
    expect(defined.difference(used), isEmpty, reason: 'unused references');
  });

  test('no em-dashes', () {
    expect(raw.contains('\u2014'), isFalse);
  });

  test('the claimed locale count matches the registry', () {
    final claimed = RegExp(r'<b>(\d+) locales</b>').firstMatch(raw);
    expect(claimed, isNotNull, reason: 'claim row lost its locale count');
    expect(int.parse(claimed!.group(1)!), 22);
    expect(TimeAgoLocales.zhTW.intlLocale, 'zh_TW');
  });

  test('the claimed test count matches the suite', () {
    // The claim row is the only place this number lives. It counts `test(`
    // declarations, so a test inside a loop counts once.
    final declared = Directory('test')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .map(
          (f) => RegExp(
            r'^\s*test\(',
            multiLine: true,
          ).allMatches(f.readAsStringSync()).length,
        )
        .fold<int>(0, (a, b) => a + b);

    final claimed = RegExp(r'<b>(\d+) tests</b>').firstMatch(raw);
    expect(claimed, isNotNull, reason: 'claim row lost its test count');
    expect(int.parse(claimed!.group(1)!), declared);
  });

  test('the migration guide it links to exists', () {
    expect(File('MIGRATION.md').existsSync(), isTrue);
  });
}
