import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';

import 'app_theme.dart';
import 'widgets.dart';

/// Two years either way, in seconds.
const _range = 2 * 365 * 86400;

/// A slider that scrubs a moment across four years, and the text for it in
/// the chosen style plus all three side by side.
class MomentCard extends StatefulWidget {
  const MomentCard({
    super.key,
    required this.timeAgo,
    this.compact = false,
    this.minimal = false,
  });

  final GetTimeAgo timeAgo;

  /// Tighter spacing and no subtitle, for when the preview has little height.
  final bool compact;

  /// Also drops the date, the track's labels and the three styles, for the
  /// shortest screens.
  final bool minimal;

  @override
  State<MomentCard> createState() => _MomentCardState();
}

class _MomentCardState extends State<MomentCard> {
  final _anchor = DateTime.now();
  var _position = -0.4;

  // Exponential, so the middle of the track covers seconds and minutes and
  // the ends cover months and years.
  DateTime get _moment {
    final seconds = (math.pow(_range + 1, _position.abs()) - 1).round();
    return _anchor.add(Duration(seconds: _position < 0 ? -seconds : seconds));
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    // A narrow card wraps its three styles over more lines, so it takes the
    // tighter form too.
    builder: (context, constraints) =>
        _card(compact: widget.compact || constraints.maxWidth < 320),
  );

  Widget _card({required bool compact}) {
    final theme = Theme.of(context);
    final at = widget.timeAgo.copyWith(clock: () => _anchor);
    final moment = _moment;
    final localizations = MaterialLocalizations.of(context);
    final caption = theme.textTheme.labelSmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    return Section(
      title: 'Try it',
      subtitle: compact
          ? null
          : 'Drag to move the moment. Now is in the middle.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            at.format(moment),
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          if (!widget.minimal) ...[
            const SizedBox(height: Gaps.s / 2),
            Text(
              '${localizations.formatMediumDate(moment)}, '
              '${localizations.formatTimeOfDay(TimeOfDay.fromDateTime(moment))}',
              textAlign: TextAlign.center,
              style: caption,
            ),
          ],
          SizedBox(height: compact ? 0 : Gaps.s),
          Slider(
            value: _position,
            min: -1,
            max: 1,
            onChanged: (v) => setState(() => _position = v),
            semanticFormatterCallback: (_) => at.format(moment),
          ),
          if (!widget.minimal)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Gaps.m),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('2 years ago', style: caption),
                  Text('now', style: caption),
                  Text('in 2 years', style: caption),
                ],
              ),
            ),
          if (!widget.minimal) ...[
            Divider(height: compact ? Gaps.l : Gaps.l * 2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final style in TimeAgoStyle.values)
                  Expanded(
                    child: Reading(
                      caption: style.name,
                      value: at.copyWith(style: style).format(moment),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
