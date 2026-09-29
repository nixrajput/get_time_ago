import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:get_time_ago_example/main.dart';

/// The preview card's title, which every check below finds it by.
const previewTitle = 'Try it';

/// Every card on the page, options first.
const optionCards = ['Locale and style', 'Date'];
const exploreCards = ['Samples', 'Live'];

/// The test font's glyphs are wider than Roboto's, which would report
/// overflows no user sees; load the fonts the app really renders with.
Future<void> loadRealFonts() async {
  final root = Platform.environment['FLUTTER_ROOT'];
  if (root == null) {
    throw StateError(
      'FLUTTER_ROOT is not set. Run these tests with `flutter test`, which '
      'sets it, so the real fonts can be found.',
    );
  }
  final fonts = '$root/bin/cache/artifacts/material_fonts';
  Future<ByteData> read(String name) async =>
      ByteData.sublistView(await File('$fonts/$name').readAsBytes());
  await (FontLoader('Roboto')
        ..addFont(read('Roboto-Regular.ttf'))
        ..addFont(read('Roboto-Medium.ttf')))
      .load();
  await (FontLoader(
    'MaterialIcons',
  )..addFont(read('MaterialIcons-Regular.otf'))).load();
}

/// Name, logical size, bottom inset (a phone's home indicator) and text scale,
/// from a 320px phone to an ultrawide, across every layout boundary.
const screens = <(String, Size, double, double)>[
  ('smallest phone', Size(320, 568), 0, 1),
  ('small phone', Size(360, 640), 0, 1),
  ('narrow tall phone', Size(360, 740), 0, 1),
  ('phone portrait', Size(390, 844), 34, 1),
  ('short phone, large text', Size(390, 600), 0, 1.3),
  ('android, large text', Size(412, 915), 48, 1.3),
  ('phone, 200% text', Size(390, 844), 34, 2),
  ('small phone landscape', Size(667, 375), 21, 1),
  ('phone landscape', Size(844, 390), 21, 1),
  ('narrow landscape window', Size(599, 400), 0, 1),
  ('medium boundary', Size(600, 960), 0, 1),
  ('tablet portrait', Size(820, 1180), 20, 1),
  ('two-pane boundary', Size(840, 700), 0, 1),
  ('small laptop', Size(1024, 600), 0, 1),
  ('laptop', Size(1280, 800), 0, 1),
  ('laptop, large text', Size(1366, 768), 0, 1.5),
  ('desktop', Size(1440, 900), 0, 1),
  ('full HD', Size(1920, 1080), 0, 1),
  ('QHD', Size(2560, 1440), 0, 1),
  ('ultrawide', Size(3440, 1440), 0, 1),
];

/// The layout rule the page follows, restated so the tests pin it down.
bool sideBySide(Size size) =>
    size.width >= 840 || (size.width >= 560 && size.height < 480);

Future<void> pumpAt(
  WidgetTester tester,
  Size size, {
  double bottomInset = 0,
  double textScale = 1,
}) async {
  tester.view.devicePixelRatio = 2;
  tester.view.physicalSize = size * 2;
  tester.view.padding = FakeViewPadding(bottom: bottomInset * 2);
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  await tester.pumpWidget(const ExampleApp());
  await tester.pumpAndSettle();
}

/// The pinned area the preview is kept to.
Finder previewArea() => find
    .ancestor(
      of: find.text(previewTitle),
      matching: find.byType(SingleChildScrollView),
    )
    .first;

Rect previewRect(WidgetTester tester) => tester.getRect(previewArea());

/// The preview's texts that end in an ellipsis.
Iterable<RenderParagraph> cutShort(WidgetTester tester) => tester
    .renderObjectList<RenderParagraph>(
      find.descendant(of: previewArea(), matching: find.byType(RichText)),
    )
    .where((p) => p.didExceedMaxLines);

/// The page's own lists, one per pane, without the scroll views inside
/// their cards.
List<ScrollableState> lists(WidgetTester tester) => [
  for (final view in find.byType(CustomScrollView).evaluate())
    tester.state<ScrollableState>(
      find
          .descendant(
            of: find.byWidget(view.widget),
            matching: find.byType(Scrollable),
          )
          .first,
    ),
];

/// Finds a list by its state, which outlives the widgets rebuilt around it.
Finder listOf(ScrollableState list) =>
    find.byElementPredicate((e) => e is StatefulElement && e.state == list);

/// Scrolls [finder] into the middle of [list]. Flutter's own reveal stops
/// short inside a card with a pinned header, which the page corrects for
/// focus, so a test that taps or drags centres its target first.
Future<void> centre(
  WidgetTester tester,
  Finder finder,
  ScrollableState list,
) async {
  await tester.scrollUntilVisible(finder, 200, scrollable: listOf(list));
  await Scrollable.ensureVisible(tester.element(finder), alignment: 0.5);
  await tester.pumpAndSettle();
}

/// A card's header, found inside the pinned headers so that an option with
/// the same label does not match.
Finder header(String title) => find.ancestor(
  of: find.descendant(
    of: find.byType(PinnedHeaderSliver),
    matching: find.text(title),
  ),
  matching: find.byType(InkWell),
);

/// Taps every group's "Expand all", scrolling each list to find them.
Future<void> expandAll(WidgetTester tester) async {
  for (final list in lists(tester)) {
    final position = list.position;
    position.jumpTo(0);
    await tester.pumpAndSettle();
    while (true) {
      final button = find
          .descendant(of: listOf(list), matching: find.byTooltip('Expand all'))
          .hitTestable();
      if (button.evaluate().isNotEmpty) {
        await tester.tap(button.first);
        await tester.pumpAndSettle();
        continue;
      }
      if (position.pixels >= position.maxScrollExtent) break;
      position.jumpTo(
        (position.pixels + position.viewportDimension / 2).clamp(
          0,
          position.maxScrollExtent,
        ),
      );
      await tester.pumpAndSettle();
    }
    position.jumpTo(0);
    await tester.pumpAndSettle();
  }
}

bool isOpen(WidgetTester tester, String title) =>
    tester
        .getSemantics(header(title).first)
        .getSemanticsData()
        .flagsCollection
        .isExpanded ==
    Tristate.isTrue;

/// Whether each card is open, read by scrolling every list from top to
/// bottom, since a list only builds the cards near its viewport.
Future<Map<String, bool>> cardStates(WidgetTester tester) async {
  final states = <String, bool>{};
  for (final list in lists(tester)) {
    final position = list.position;
    position.jumpTo(0);
    await tester.pumpAndSettle();
    while (true) {
      for (final title in [...optionCards, ...exploreCards]) {
        if (header(title).evaluate().isNotEmpty) {
          states[title] = isOpen(tester, title);
        }
      }
      if (position.pixels >= position.maxScrollExtent) break;
      position.jumpTo(
        (position.pixels + position.viewportDimension / 2).clamp(
          0,
          position.maxScrollExtent,
        ),
      );
      await tester.pumpAndSettle();
    }
  }
  return states;
}

void main() {
  setUpAll(loadRealFonts);

  for (final (name, size, bottomInset, textScale) in screens) {
    testWidgets('fits, pins the preview and reaches every card: $name', (
      tester,
    ) async {
      await pumpAt(
        tester,
        size,
        bottomInset: bottomInset,
        textScale: textScale,
      );
      expect(tester.takeException(), isNull, reason: 'layout overflow');
      final visibleBottom = size.height - bottomInset;

      // The options sit beside the preview or under it, as the rule says.
      final preview = previewRect(tester);
      final options = tester.getRect(find.text('Options'));
      if (sideBySide(size)) {
        expect(options.right, lessThanOrEqualTo(preview.left), reason: name);
      } else {
        expect(options.top, greaterThanOrEqualTo(preview.bottom), reason: name);
      }

      await expandAll(tester);
      expect(tester.takeException(), isNull, reason: 'overflow when open');
      expect(await cardStates(tester), {
        for (final title in [...optionCards, ...exploreCards]) title: true,
      }, reason: name);

      // However far each list goes, the preview does not move, and the last
      // card of each list comes fully into view above the bottom inset.
      for (final list in lists(tester)) {
        list.position.jumpTo(list.position.maxScrollExtent);
        await tester.pumpAndSettle();
        final viewport = tester.getRect(listOf(list));
        expect(viewport.bottom, lessThanOrEqualTo(visibleBottom + 0.01));
        final lastCard = find
            .descendant(of: listOf(list), matching: find.byType(InkWell))
            .last;
        expect(
          tester.getRect(lastCard).bottom,
          lessThanOrEqualTo(viewport.bottom),
          reason: '$name: the last card ends below its list',
        );
        expect(previewRect(tester), preview, reason: '$name: preview moved');
      }
      // At the usual text size the whole preview fits its area; only a very
      // large text size may make the area scroll, which keeps it reachable.
      if (textScale == 1) {
        final area = tester.state<ScrollableState>(
          find
              .descendant(of: previewArea(), matching: find.byType(Scrollable))
              .first,
        );
        // The readings are longest at the track's ends, where they turn into
        // dates, and none of them may end in an ellipsis.
        final slider = find.descendant(
          of: previewArea(),
          matching: find.byType(Slider),
        );
        for (final end in [null, -1.0, 1.0]) {
          if (end != null) {
            await tester.drag(slider, Offset(end * size.width, 0));
            await tester.pumpAndSettle();
            expect(tester.widget<Slider>(slider).value, end, reason: name);
          }
          final at = '$name at ${end ?? 'the start'}';
          expect(area.position.maxScrollExtent, 0, reason: at);
          expect(cutShort(tester), isEmpty, reason: '$at: a reading is cut');
        }
      } else {
        // Larger text wraps freely instead of keeping to two lines.
        expect(cutShort(tester), isEmpty, reason: '$name: a reading is cut');
      }
      expect(preview.top, greaterThanOrEqualTo(0));
      expect(
        preview.bottom,
        lessThanOrEqualTo(visibleBottom),
        reason: '$name: the preview is cut off',
      );
    });
  }

  testWidgets('cards open and close by tap, Enter and Space', (tester) async {
    await pumpAt(tester, const Size(390, 844));
    expect(isOpen(tester, 'Samples'), isFalse, reason: 'closed on a phone');
    expect(find.text('Fixed offsets from when this page opened'), findsOne);

    await tester.tap(header('Samples'));
    await tester.pumpAndSettle();
    expect(isOpen(tester, 'Samples'), isTrue);
    expect(find.text('Just now'), findsOneWidget);

    Focus.of(tester.element(find.text('Samples'))).requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(isOpen(tester, 'Samples'), isFalse);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    expect(isOpen(tester, 'Samples'), isTrue);
  });

  testWidgets('expand all and collapse all', (tester) async {
    await pumpAt(tester, const Size(390, 844));
    await tester.tap(find.byTooltip('Expand all').first);
    await tester.pumpAndSettle();
    expect(await cardStates(tester), {
      for (final title in optionCards) title: true,
      for (final title in exploreCards) title: false,
    });
    lists(tester).single.position.jumpTo(0);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Collapse all').first);
    await tester.pumpAndSettle();
    expect(await cardStates(tester), {
      for (final title in [...optionCards, ...exploreCards]) title: false,
    });
  });

  testWidgets('reset puts every option back', (tester) async {
    await pumpAt(tester, const Size(1280, 800));
    await tester.tap(
      find.descendant(
        of: find.byType(SegmentedButton<TimeAgoStyle>),
        matching: find.text('narrow'),
      ),
    );
    final pattern = find.widgetWithText(TextField, 'Date pattern');
    await tester.enterText(pattern, 'yyyy');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.text('21m ago'), findsWidgets);

    await tester.tap(find.byTooltip('Reset to defaults'));
    await tester.pumpAndSettle();
    await tester.tap(header('Locale and style'));
    await tester.pumpAndSettle();
    expect(
      find.text('English (en) · long · up to day'),
      findsOneWidget,
      reason: 'the summary shows the defaults',
    );
    expect(tester.widget<TextField>(pattern).controller!.text, isEmpty);
  });

  testWidgets('open cards and the preview survive a resize', (tester) async {
    await pumpAt(tester, const Size(390, 844));
    await tester.tap(header('Samples'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(Slider).first, const Offset(80, 0));
    await tester.pumpAndSettle();
    final moved = tester.widget<Slider>(find.byType(Slider).first).value;

    tester.view.physicalSize = const Size(1440, 900) * 2;
    await tester.pumpAndSettle();
    expect(tester.widget<Slider>(find.byType(Slider).first).value, moved);
    expect(await cardStates(tester), {
      for (final title in [...optionCards, ...exploreCards])
        title: title == 'Samples',
    });
  });

  for (final (name, size) in const [
    ('laptop', Size(1366, 768)),
    ('landscape phone', Size(844, 390)),
    ('phone', Size(390, 844)),
  ]) {
    testWidgets('the wheel over the preview scrolls the page: $name', (
      tester,
    ) async {
      await pumpAt(tester, size);
      await expandAll(tester);
      // The list under or beside the preview, the one the wheel should move.
      final list = sideBySide(size) && size.height >= 480
          ? lists(tester).last
          : lists(tester).first;
      list.position.jumpTo(0);
      await tester.pumpAndSettle();

      final mouse = TestPointer(1, PointerDeviceKind.mouse);
      await tester.sendEventToBinding(
        mouse.hover(tester.getCenter(find.text(previewTitle))),
      );
      await tester.sendEventToBinding(mouse.scroll(const Offset(0, 300)));
      await tester.pumpAndSettle();
      expect(list.position.pixels, greaterThan(0));
    });
  }

  testWidgets('a touch drag scrolls the page from inside an open card', (
    tester,
  ) async {
    await pumpAt(tester, const Size(390, 844));
    await expandAll(tester);
    final list = lists(tester).single;
    await centre(tester, find.text('Seconds'), list);
    final before = list.position.pixels;
    await tester.drag(find.text('Seconds'), const Offset(0, -200));
    await tester.pumpAndSettle();
    expect(list.position.pixels, greaterThan(before));
  });

  for (final (name, size) in const [
    ('phone', Size(390, 844)),
    ('laptop', Size(1280, 800)),
  ]) {
    testWidgets('keyboard focus is never hidden by a pinned header: $name', (
      tester,
    ) async {
      await pumpAt(tester, size);
      await expandAll(tester);
      final pinned = find.descendant(
        of: find.byType(PinnedHeaderSliver),
        matching: find.byType(InkWell),
      );
      for (var i = 0; i < 40; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();
        final focus = FocusManager.instance.primaryFocus!;
        final rect = focus.rect;
        final inHeader = pinned.evaluate().any(
          (e) => tester.getRect(find.byWidget(e.widget)).contains(rect.center),
        );
        if (inHeader) continue;
        for (final e in pinned.evaluate()) {
          final h = tester.getRect(find.byWidget(e.widget));
          expect(
            h.overlaps(rect.deflate(1)),
            isFalse,
            reason: '$name: focus $rect under a pinned header $h',
          );
        }
        expect(
          rect.bottom,
          lessThanOrEqualTo(size.height + 0.01),
          reason: name,
        );
      }
    });
  }

  testWidgets('a focused field stays above the keyboard', (tester) async {
    await pumpAt(tester, const Size(390, 844));
    await expandAll(tester);
    final field = find.widgetWithText(TextField, 'Date pattern');
    await tester.scrollUntilVisible(
      field,
      100,
      scrollable: listOf(lists(tester).single),
    );
    await tester.tap(field);
    await tester.pumpAndSettle();
    tester.view.viewInsets = const FakeViewPadding(bottom: 300 * 2);
    await tester.pumpAndSettle();
    expect(tester.getRect(field).bottom, lessThanOrEqualTo(844 - 300));
    expect(
      tester.getRect(field).top,
      greaterThanOrEqualTo(previewRect(tester).bottom),
    );
  });

  testWidgets('touch targets are at least 48 pixels on a phone', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pumpAt(tester, const Size(390, 844));
    await expandAll(tester);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    handle.dispose();
  });

  testWidgets('cards open at once when motion is reduced', (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await pumpAt(tester, const Size(390, 844));
    await tester.tap(header('Samples'));
    await tester.pump();
    final opened = tester.getRect(find.text('Seconds'));
    await tester.pumpAndSettle();
    expect(
      tester.getRect(find.text('Seconds')),
      opened,
      reason: 'no animation',
    );
  });
}
