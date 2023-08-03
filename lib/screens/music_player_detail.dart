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

class _MusicPlayerDetailScreenState extends State<MusicPlayerDetailScreen>
    with TickerProviderStateMixin {
  final int _totalPlayTime = 80;

  late final AnimationController _progressController = AnimationController(
    vsync: this,
    duration: Duration(seconds: _totalPlayTime),
  )..repeat(reverse: true);

  late final AnimationController _marqueeController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  )..repeat(reverse: true);

  late final Animation<Offset> _marqueeTween = Tween(
    begin: const Offset(0.1, 0),
    end: const Offset(-0.6, 0),
  ).animate(_marqueeController);

  String _formatTime({required double value, required bool reverse}) {
    int valueToSeconds = (value * 60).floor();
    int playMinutes = valueToSeconds ~/ 60;
    int playSeconds = valueToSeconds % 60;
    int remainPlaytime = _totalPlayTime - valueToSeconds;
    int remainPlayMinutes = remainPlaytime ~/ 60;
    int remainPlaySeconds = remainPlaytime % 60;
    String formattedTitme = "";
    if (reverse) {
      formattedTitme =
          "${(remainPlayMinutes).toString().padLeft(2, '0')}:${remainPlaySeconds.toString().padLeft(2, '0')}";
    } else {
      formattedTitme =
          "${playMinutes.toString().padLeft(2, '0')}:${playSeconds.toString().padLeft(2, '0')}";
    }
    return formattedTitme;
  }

  @override
  void dispose() {
    _progressController.dispose();
    _marqueeController.dispose();
    super.dispose();
  }

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
          AnimatedBuilder(
            animation: _progressController,
            builder: (context, child) {
              return CustomPaint(
                size: Size(size.width - 80, 5),
                painter: ProgressBar(
                  progressValue: _progressController.value,
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: AnimatedBuilder(
              animation: _progressController,
              builder: (context, child) {
                return Row(
                  children: [
                    Text(
                      _formatTime(
                        value: _progressController.value,
                        reverse: false,
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatTime(
                        value: _progressController.value,
                        reverse: true,
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Interstellar",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          SlideTransition(
            position: _marqueeTween,
            child: const Text(
              "A Film By Christopher Nolan - Original Motion Picture Soundtrack",
              maxLines: 1,
              // TextOverflow.visible : Container를 벗어나는 경우도 표시
              overflow: TextOverflow.visible,
              // softWrap: 텍스트가 영역을 넘어갈 경우 줄바꿈 여부
              softWrap: false,
              style: TextStyle(fontSize: 18),
            ),
          )
        ],
      ),
    );
  }
}

class ProgressBar extends CustomPainter {
  final double progressValue;

  ProgressBar({
    required this.progressValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final progress = progressValue * size.width;
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
      progress,
      size.height,
      const Radius.circular(10),
    );

    canvas.drawRRect(progressRRect, progressPaint);

    // thumb

    canvas.drawCircle(
      Offset(progress, size.height / 2),
      10,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ProgressBar oldDelegate) {
    return oldDelegate.progressValue != progressValue;
  }
}
