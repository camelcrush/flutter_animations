import 'dart:math';

import 'package:flutter/material.dart';

class AppleWatchScreen extends StatefulWidget {
  const AppleWatchScreen({super.key});

  @override
  State<AppleWatchScreen> createState() => _AppleWatchScreenState();
}

class _AppleWatchScreenState extends State<AppleWatchScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..forward();

  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _animationController,
    curve: Curves.bounceOut,
  );

  late List<Animation<double>> _progresses = List.generate(
    3,
    (index) => Tween(
      begin: 0.05,
      end: Random().nextDouble() * 2.0,
    ).animate(_curve),
  );

  // late Animation<double> _progress = Tween(
  //   begin: 0.005,
  //   end: 1.5,
  // ).animate(_curve);

  void _animationValues() {
    _progresses = List.generate(
      3,
      (index) => Tween(
              begin: _progresses[index].value, end: Random().nextDouble() * 2.0)
          .animate(_curve),
    );

    // final newBegin = _progress.value;
    // final newEnd = Random().nextDouble() * 2.0;
    // setState(() {
    //   _progress = Tween(
    //     begin: newBegin,
    //     end: newEnd,
    //   ).animate(_curve);
    // });
    // AnimationController value가 1로 끝나기 때문에 다시 0으로 세팅해줘야 애니메이션 작동
    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return CustomPaint(
              painter: AppleWatchPainter(
                progresses: _progresses,
              ),
              // canvas 사이즈 설정
              size: const Size(400, 400),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _animationValues,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

// CustomPainter
class AppleWatchPainter extends CustomPainter {
  final List<Animation<double>> progresses;

  AppleWatchPainter({
    required this.progresses,
  });

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
      progresses[0].value * pi,
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
      progresses[1].value * pi,
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
      progresses[2].value * pi,
      false,
      blueArcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant AppleWatchPainter oldDelegate) {
    // shouldRepaint는 페인팅 도중 문제가 생겼을 시 다시 그릴건지의 여부를 묻는 것이고,
    // 여기서는 올드버젼의 progress값이 AnimationController의 progress값과 일치하지 않으면 다시 그리라는 의미
    // return oldDelegate.progress != progress;
    return true;
  }
}
