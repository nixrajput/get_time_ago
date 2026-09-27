import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get_time_ago/get_time_ago.dart';

/// Text that refreshes itself exactly when its wording changes, using
/// [GetTimeAgo.nextChange] instead of a fixed tick.
class LiveTimeAgo extends StatefulWidget {
  const LiveTimeAgo({
    super.key,
    required this.dateTime,
    required this.timeAgo,
    this.style,
  });

  final DateTime dateTime;
  final GetTimeAgo timeAgo;
  final TextStyle? style;

  @override
  State<LiveTimeAgo> createState() => _LiveTimeAgoState();
}

class _LiveTimeAgoState extends State<LiveTimeAgo> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _schedule();
  }

  @override
  void didUpdateWidget(LiveTimeAgo old) {
    super.didUpdateWidget(old);
    if (old.dateTime != widget.dateTime || old.timeAgo != widget.timeAgo) {
      _schedule();
    }
  }

  void _schedule() {
    _timer?.cancel();
    final wait = widget.timeAgo.nextChange(widget.dateTime);
    if (wait != null) {
      _timer = Timer(wait, () => setState(_schedule));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Text(widget.timeAgo.format(widget.dateTime), style: widget.style);
}
