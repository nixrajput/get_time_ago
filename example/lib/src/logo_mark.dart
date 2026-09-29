import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// The package logo, drawn on the same 32 x 32 grid as `assets/logo.svg` so
/// the example needs no SVG dependency.
class LogoMark extends StatelessWidget {
  const LogoMark({super.key, this.size = 32});

  final double size;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'get_time_ago logo',
    image: true,
    child: SizedBox.square(
      dimension: size,
      child: const CustomPaint(painter: _LogoPainter()),
    ),
  );
}

class _LogoPainter extends CustomPainter {
  const _LogoPainter();

  static const _tile = Color(0xFF141118);
  static const _ring = Color(0xFF6B6478);
  static const _amber = Color(0xFFF0A868);
  static const _violet = Color(0xFF9B8CFF);
  static const _centre = Offset(16, 16);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 32);
    canvas.drawRRect(
      RRect.fromLTRBR(0, 0, 32, 32, const Radius.circular(7)),
      Paint()..color = _tile,
    );
    Paint stroke(Color color, double width) => Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(_centre, 9.5, stroke(_ring, 2.2));
    // From nine o'clock clockwise to twelve: the elapsed span.
    canvas.drawArc(
      Rect.fromCircle(center: _centre, radius: 9.5),
      math.pi,
      math.pi / 2,
      false,
      stroke(_amber, 2.8),
    );
    canvas.drawCircle(const Offset(6.5, 16), 2.1, Paint()..color = _amber);
    canvas.drawLine(_centre, const Offset(16, 9.8), stroke(_violet, 2.4));
    canvas.drawCircle(_centre, 1.9, Paint()..color = _violet);
  }

  @override
  bool shouldRepaint(_LogoPainter oldDelegate) => false;
}
