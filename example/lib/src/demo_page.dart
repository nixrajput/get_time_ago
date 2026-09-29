import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';

import 'app_theme.dart';
import 'collapsible_section.dart';
import 'demo_layout.dart';
import 'live_time_ago.dart';
import 'logo_mark.dart';
import 'moment_card.dart';
import 'samples.dart';
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
  /// Below these heights the preview drops its subtitle and some spacing,
  /// then its date and the three styles too.
  static const _roomyPreview = 320.0;
  static const _shortPreview = 250.0;

  final _openedAt = DateTime.now();
  final _pattern = TextEditingController();
  var _timeAgo = const GetTimeAgo();

  /// Bumped by a reset, so the menus rebuild with the defaults selected.
  var _generation = 0;

  void _update(GetTimeAgo next) => setState(() => _timeAgo = next);

  void _reset() => setState(() {
    _timeAgo = const GetTimeAgo();
    _pattern.clear();
    _generation++;
  });

  @override
  void dispose() {
    _pattern.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DemoLayout(
    title: 'get_time_ago',
    logo: const LogoMark(size: 28),
    themeMode: widget.themeMode,
    onThemeModeChanged: widget.onThemeModeChanged,
    preview: (context, maxHeight) => MomentCard(
      timeAgo: _timeAgo,
      compact: maxHeight < _roomyPreview,
      minimal: maxHeight < _shortPreview,
    ),
    onReset: _reset,
    options: [
      DemoSection(
        title: 'Locale and style',
        summary:
            '${_localeName(_timeAgo.locale)} · ${_timeAgo.style.name} · '
            'up to ${_timeAgo.maxUnit.name}',
        child: KeyedSubtree(key: ValueKey(_generation), child: _format()),
      ),
      DemoSection(
        title: 'Date',
        summary:
            _timeAgo.datePattern ??
            '${GetTimeAgo.defaultDatePattern} (default)',
        subtitle: 'Shown once a time is past the largest unit.',
        child: _date(),
      ),
    ],
    explore: [
      DemoSection(
        title: 'Samples',
        summary: 'Fixed offsets from when this page opened',
        subtitle: 'Fixed offsets from the moment this page opened.',
        flush: true,
        child: _samples(),
      ),
      DemoSection(
        title: 'Live',
        summary: 'Refreshed by nextChange',
        subtitle:
            'Refreshed by nextChange, exactly when the text changes, '
            'with no ticking timer.',
        child: _live(),
      ),
    ],
  );

  String _localeName(String? code) {
    final c = code ?? 'en';
    return localeNames.containsKey(c) ? '${localeNames[c]} ($c)' : c;
  }

  Widget _format() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      DropdownMenu<String>(
        label: const Text('Locale'),
        leadingIcon: const Icon(Icons.translate),
        expandedInsets: EdgeInsets.zero,
        initialSelection: _timeAgo.locale,
        dropdownMenuEntries: [
          for (final code in GetTimeAgo.supportedLocales)
            DropdownMenuEntry(value: code, label: _localeName(code)),
        ],
        onSelected: (code) => _update(_timeAgo.copyWith(locale: code)),
      ),
      const SizedBox(height: Gaps.m),
      _Labelled(
        label: 'Style',
        child: SegmentedButton<TimeAgoStyle>(
          segments: [
            for (final s in TimeAgoStyle.values)
              ButtonSegment(value: s, label: segmentLabel(s.name)),
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
              ButtonSegment(value: u, label: segmentLabel(u.name)),
          ],
          selected: {_timeAgo.maxUnit},
          onSelectionChanged: (u) =>
              _update(_timeAgo.copyWith(maxUnit: u.single)),
        ),
      ),
    ],
  );

  Widget _date() => TextField(
    controller: _pattern,
    decoration: const InputDecoration(
      labelText: 'Date pattern',
      hintText: GetTimeAgo.defaultDatePattern,
      helperText: 'Press enter to apply.',
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
  );

  Widget _live() {
    final theme = Theme.of(context);
    return Row(
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
    );
  }

  Widget _samples() {
    final theme = Theme.of(context);
    // A frozen clock, so each row shows its offset exactly however long the
    // page stays open.
    final frozen = _timeAgo.copyWith(clock: () => _openedAt);
    return Column(
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
