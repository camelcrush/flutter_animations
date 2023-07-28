import 'dart:math';

import 'package:flutter/material.dart';

class AppleWatchScreen extends StatefulWidget {
  const AppleWatchScreen({super.key});

  @override
  State<AppleWatchScreen> createState() => _AppleWatchScreenState();
}

class _AppleWatchScreenState extends State<AppleWatchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Apple Watch"),
      ),
      body: Center(
          child: CustomPaint(
        painter: AppleWatchPainter(),
        // canvas 사이즈 설정
        size: const Size(400, 400),
      )),
    );
  }
}

// CustomPainter
class AppleWatchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.width / 2,
    );
    const startingAngle = -0.5 * pi;

    // draw red circle
    final redCirclePaint = Paint()
      ..color = Colors.red.shade400.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;

    final redCircleRadius = (size.width / 2) * 0.9;
    canvas.drawCircle(
      center,
      redCircleRadius,
      redCirclePaint,
    );

    // draw green circle
    final greenCircle = Paint()
      ..color = Colors.green.shade400.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;

    final greenCircleRadius = (size.width / 2) * 0.76;
    canvas.drawCircle(
      center,
      greenCircleRadius,
      greenCircle,
    );

    // draw blue circle
    final blueCircle = Paint()
      ..color = Colors.cyan.shade400.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;

    final blueCircleRadius = (size.width / 2) * 0.62;
    canvas.drawCircle(
      center,
      blueCircleRadius,
      blueCircle,
    );

    // red arc
    final redArcRect = Rect.fromCircle(
      center: center,
      radius: redCircleRadius,
    );

    final redArcPaint = Paint()
      ..color = Colors.red.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      redArcRect,
      startingAngle,
      1.5 * pi,
      false,
      redArcPaint,
    );

    // green arc
    final greenArcRect = Rect.fromCircle(
      center: center,
      radius: greenCircleRadius,
    );

    final greenArcPaint = Paint()
      ..color = Colors.green.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      greenArcRect,
      startingAngle,
      1.5 * pi,
      false,
      greenArcPaint,
    );

    // blue arc
    final blueArcRect = Rect.fromCircle(
      center: center,
      radius: blueCircleRadius,
    );

    final blueArcPaint = Paint()
      ..color = Colors.cyan.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      blueArcRect,
      startingAngle,
      1.5 * pi,
      false,
      blueArcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
