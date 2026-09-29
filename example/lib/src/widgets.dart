import 'package:flutter/material.dart';

import 'app_theme.dart';

/// A titled card. Every block on the page is one, so spacing stays uniform.
class Section extends StatelessWidget {
  const Section({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.flush = false,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  /// Lets list rows run edge to edge inside the card.
  final bool flush;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final header = Padding(
      padding: const EdgeInsets.fromLTRB(Gaps.m, Gaps.m, Gaps.m, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: Gaps.s / 2),
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header,
          Padding(
            padding: flush
                ? const EdgeInsets.only(top: Gaps.s, bottom: Gaps.s)
                : const EdgeInsets.all(Gaps.m),
            child: child,
          ),
        ],
      ),
    );
  }
}

/// A caption over a value, the pairing the page uses for every reading.
class Reading extends StatelessWidget {
  const Reading({super.key, required this.caption, required this.value});

  final String caption;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          caption,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: Gaps.s / 2),
        Text(value, style: theme.textTheme.titleMedium),
      ],
    );
  }
}

/// A segment's label, which shrinks rather than breaking a word over lines
/// when a narrow panel leaves the segment too little room.
Widget segmentLabel(String text) =>
    FittedBox(fit: BoxFit.scaleDown, child: Text(text, maxLines: 1));

/// Device, light or dark, as three icon segments.
class ThemeModeSwitch extends StatelessWidget {
  const ThemeModeSwitch({
    super.key,
    required this.mode,
    required this.onChanged,
  });

  final ThemeMode mode;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) => SegmentedButton<ThemeMode>(
    showSelectedIcon: false,
    segments: const [
      ButtonSegment(
        value: ThemeMode.system,
        icon: Icon(Icons.brightness_auto_outlined),
        tooltip: 'Device theme',
      ),
      ButtonSegment(
        value: ThemeMode.light,
        icon: Icon(Icons.light_mode_outlined),
        tooltip: 'Light theme',
      ),
      ButtonSegment(
        value: ThemeMode.dark,
        icon: Icon(Icons.dark_mode_outlined),
        tooltip: 'Dark theme',
      ),
    ],
    selected: {mode},
    onSelectionChanged: (s) => onChanged(s.single),
  );
}
