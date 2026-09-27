import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';

import 'app_theme.dart';
import 'live_time_ago.dart';
import 'logo_mark.dart';
import 'moment_card.dart';
import 'samples.dart';
import 'scroll_forwarder.dart';
import 'widgets.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final _openedAt = DateTime.now();
  final _list = ScrollController();
  var _timeAgo = const GetTimeAgo();

  void _update(GetTimeAgo next) => setState(() => _timeAgo = next);

  @override
  void dispose() {
    _list.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    // Options and preview must both stay in view. With room or in landscape
    // both are pinned side by side above one list; on a portrait phone the
    // preview is pinned and the options lead the list under it.
    final twoPane = size.width >= Gaps.twoPane || size.width > size.height;
    final maxWidth = twoPane ? Gaps.maxWideWidth : Gaps.maxWidth;
    final side = math.max(Gaps.m, (size.width - maxWidth) / 2);
    final preview = MomentCard(
      timeAgo: _timeAgo,
      compact: !twoPane || size.height < Gaps.tallEnough,
    );
    return Scaffold(
      appBar: AppBar(
        titleSpacing: side,
        // Scales down rather than overflowing beside the theme switch on a
        // narrow phone or with a large text size.
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              LogoMark(size: 28),
              SizedBox(width: Gaps.s + Gaps.s / 2),
              Text('get_time_ago'),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: side),
            child: ThemeModeSwitch(
              mode: widget.themeMode,
              onChanged: widget.onThemeModeChanged,
            ),
          ),
        ],
      ),
      // An explicit ListView padding drops the device insets, so SafeArea
      // restores them; without it the last card sits under the home bar.
      body: SafeArea(
        top: false,
        // The wheel over the pinned preview scrolls the list too.
        child: ScrollForwarder(
          controller: _list,
          child: twoPane ? _twoPane(side, preview) : _onePane(side, preview),
        ),
      ),
    );
  }

  Widget _twoPane(double side, Widget preview) => Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Expanded(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final list = EdgeInsets.fromLTRB(side, Gaps.s, Gaps.s, Gaps.l);
            // Pinned like the preview only when the options fit whole and the
            // list keeps room; a half-hidden card reads as broken.
            final room =
                Gaps.pinOptions * MediaQuery.textScalerOf(context).scale(1);
            if (constraints.maxHeight < room) return _content(list);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(side, Gaps.s, Gaps.s, Gaps.s),
                  child: _options(),
                ),
                Expanded(child: _content(list, withOptions: false)),
              ],
            );
          },
        ),
      ),
      Expanded(
        // Scrolls only when the preview is taller than the screen.
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(Gaps.s, Gaps.s, side, Gaps.l),
          child: preview,
        ),
      ),
    ],
  );

  Widget _onePane(double side, Widget preview) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: EdgeInsets.fromLTRB(side, Gaps.s, side, Gaps.s),
        child: preview,
      ),
      Expanded(
        child: _content(EdgeInsets.fromLTRB(side, Gaps.s, side, Gaps.l)),
      ),
    ],
  );

  /// Everything that is not pinned, in the one list that scrolls.
  Widget _content(EdgeInsets padding, {bool withOptions = true}) => ListView(
    controller: _list,
    padding: padding,
    children: [
      if (withOptions) ...[_options(), const SizedBox(height: Gaps.m)],
      _samples(),
      const SizedBox(height: Gaps.m),
      _live(),
    ],
  );

  Widget _options() => Section(
    title: 'Options',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownMenu<String>(
          label: const Text('Locale'),
          leadingIcon: const Icon(Icons.translate),
          expandedInsets: EdgeInsets.zero,
          initialSelection: _timeAgo.locale,
          dropdownMenuEntries: [
            for (final code in GetTimeAgo.supportedLocales)
              DropdownMenuEntry(
                value: code,
                label: localeNames.containsKey(code)
                    ? '${localeNames[code]} ($code)'
                    : code,
              ),
          ],
          onSelected: (code) => _update(_timeAgo.copyWith(locale: code)),
        ),
        const SizedBox(height: Gaps.m),
        _Labelled(
          label: 'Style',
          child: SegmentedButton<TimeAgoStyle>(
            segments: [
              for (final s in TimeAgoStyle.values)
                ButtonSegment(value: s, label: Text(s.name)),
            ],
            selected: {_timeAgo.style},
            onSelectionChanged: (s) =>
                _update(_timeAgo.copyWith(style: s.single)),
          ),
        ),
        const SizedBox(height: Gaps.m),
        _Labelled(
          label: 'Largest unit before the date',
          child: SegmentedButton<TimeUnit>(
            segments: [
              for (final u in [
                TimeUnit.day,
                TimeUnit.week,
                TimeUnit.month,
                TimeUnit.year,
              ])
                ButtonSegment(value: u, label: Text(u.name)),
            ],
            selected: {_timeAgo.maxUnit},
            onSelectionChanged: (u) =>
                _update(_timeAgo.copyWith(maxUnit: u.single)),
          ),
        ),
        const SizedBox(height: Gaps.m),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Date pattern',
            hintText: GetTimeAgo.defaultDatePattern,
            helperText: 'Used past the largest unit. Press enter to apply.',
            prefixIcon: Icon(Icons.calendar_today_outlined),
          ),
          // copyWith keeps the old pattern for null, so clearing needs a new value.
          onSubmitted: (p) => _update(
            GetTimeAgo(
              locale: _timeAgo.locale,
              style: _timeAgo.style,
              maxUnit: _timeAgo.maxUnit,
              datePattern: p.isEmpty ? null : p,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _live() {
    final theme = Theme.of(context);
    return Section(
      title: 'Live',
      subtitle:
          'Refreshed by nextChange, exactly when the text changes, '
          'with no ticking timer.',
      child: Row(
        children: [
          Icon(Icons.schedule, color: theme.colorScheme.primary),
          const SizedBox(width: Gaps.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This page opened',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: Gaps.s / 2),
                LiveTimeAgo(
                  dateTime: _openedAt,
                  timeAgo: _timeAgo,
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _samples() {
    final theme = Theme.of(context);
    // A frozen clock, so each row shows its offset exactly however long the
    // page stays open.
    final frozen = _timeAgo.copyWith(clock: () => _openedAt);
    return Section(
      title: 'Samples',
      subtitle: 'Fixed offsets from the moment this page opened.',
      flush: true,
      child: Column(
        children: [
          for (final (i, (label, offset)) in samples.indexed) ...[
            if (i > 0) const Divider(indent: Gaps.m, endIndent: Gaps.m),
            ListTile(
              title: Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              subtitle: Text(
                frozen.format(_openedAt.subtract(offset)),
                style: theme.textTheme.titleMedium,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Labelled extends StatelessWidget {
  const _Labelled({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: Gaps.s),
        child,
      ],
    );
  }
}
