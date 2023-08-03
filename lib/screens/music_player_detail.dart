import 'package:flutter/material.dart';

class MusicPlayerDetailScreen extends StatefulWidget {
  final int index;

  const MusicPlayerDetailScreen({
    super.key,
    required this.index,
  });

  @override
  State<MusicPlayerDetailScreen> createState() =>
      _MusicPlayerDetailScreenState();
}

class _MusicPlayerDetailScreenState extends State<MusicPlayerDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Interstella"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Align(
            alignment: Alignment.center,
            child: Hero(
              tag: "${widget.index}",
              child: Container(
                height: 350,
                width: 350,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/covers/${widget.index}.jpg"),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(2, 6),
                    )
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          CustomPaint(
            size: Size(size.width - 80, 5),
            painter: ProgressBar(),
          ),
        ],
      ),
    );
  }
}

class ProgressBar extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Track

    final trackPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;

    final trackRRect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      size.height,
      const Radius.circular(10),
    );

    canvas.drawRRect(trackRRect, trackPaint);

    // Progress

    final progressPaint = Paint()
      ..color = Colors.grey.shade500
      ..style = PaintingStyle.fill;

    final progressRRect = RRect.fromLTRBR(
      0,
      0,
      size.width / 2,
      size.height,
      const Radius.circular(10),
    );

    canvas.drawRRect(progressRRect, progressPaint);

    // thumb

    canvas.drawCircle(
      Offset(
        size.width / 2,
        size.height / 2,
      ),
      10,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ProgressBar oldDelegate) {
    return false;
  }
}
