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
  late final size = MediaQuery.of(context).size;

  // Progress Animtaion
  late final AnimationController _progressController = AnimationController(
    vsync: this,
    duration: Duration(seconds: _totalPlayTime),
  )..forward();

  // Marquee Animation
  late final AnimationController _marqueeController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  )..repeat(reverse: true);

  late final Animation<Offset> _marqueeTween = Tween(
    begin: const Offset(0.1, 0),
    end: const Offset(-0.6, 0),
  ).animate(_marqueeController);

  // Play & Pause Aniamatino
  late final AnimationController _playPauseController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  // Menu Animation (Staggered Animation)
  late final AnimationController _menuController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  );

  final Curve _menuCurve = Curves.easeInOutCubic;

  late final Animation<double> _screenScale = Tween(
    begin: 1.0,
    end: 0.7,
  ).animate(
    // CurvedAnimation을 통해 컨트롤러와 Interval을 연결할 수 있음
    CurvedAnimation(
      parent: _menuController,
      curve: Interval(
        0.0,
        0.3,
        curve: _menuCurve,
      ),
    ),
  );

  late final Animation<Offset> _screenOffset = Tween(
    begin: Offset.zero,
    end: const Offset(0.5, 0),
  ).animate(
    CurvedAnimation(
      parent: _menuController,
      curve: Interval(
        0.2,
        0.4,
        curve: _menuCurve,
      ),
    ),
  );

  late final Animation<double> _closeButtonOpacity = Tween(
    begin: 0.0,
    end: 1.0,
  ).animate(
    CurvedAnimation(
      parent: _menuController,
      curve: Interval(0.3, 0.5, curve: _menuCurve),
    ),
  );

  late final Animation<Offset> _profileOffset = Tween<Offset>(
    begin: const Offset(-1, 0),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(
      parent: _menuController,
      curve: Interval(0.4, 0.7, curve: _menuCurve),
    ),
  );

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
    _playPauseController.dispose();
    _menuController.dispose();
    super.dispose();
  }

  void _onPlayPauseTap() {
    if (_playPauseController.isCompleted) {
      _playPauseController.reverse();
    } else {
      _playPauseController.forward();
    }
  }

  bool _dragging = false;

  void _toggleDragging() {
    setState(() {
      _dragging = !_dragging;
    });
  }

  final ValueNotifier<double> _volume = ValueNotifier(0.0);

  void _onVolumeDragUpdate(DragUpdateDetails details) {
    _volume.value += details.delta.dx;

    // clamp : 값으 범위를 제한하는 함수
    // 볼륨조절을 화면상에 보이는 볼륨바만큼간 제한하기 위해
    _volume.value = _volume.value.clamp(
      0.0,
      size.width - 80,
    );
  }

  void _openMenu() {
    _menuController.forward();
  }

  void _closeMenu() {
    _menuController.reverse();
  }

  final List<Map<String, dynamic>> _menus = [
    {
      "icon": Icons.person,
      "text": "Profile",
    },
    {
      "icon": Icons.notifications,
      "text": "Notifications",
    },
    {
      "icon": Icons.settings,
      "text": "Settings",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            leading: FadeTransition(
              opacity: _closeButtonOpacity,
              child: IconButton(
                onPressed: _closeMenu,
                icon: const Icon(Icons.close),
              ),
            ),
          ),
          body: Column(
            children: [
              const SizedBox(height: 30),
              for (var menu in _menus) ...[
                SlideTransition(
                  position: _profileOffset,
                  child: Row(
                    children: [
                      Icon(
                        menu["icon"],
                        color: Colors.grey.shade200,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        menu["text"],
                        style: TextStyle(
                          color: Colors.grey.shade200,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
              const Spacer(),
              const Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Log out",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
        SlideTransition(
          position: _screenOffset,
          child: ScaleTransition(
            scale: _screenScale,
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Interstella"),
                actions: [
                  IconButton(
                    onPressed: _openMenu,
                    icon: const Icon(Icons.menu),
                  ),
                ],
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
                            image:
                                AssetImage("assets/covers/${widget.index}.jpg"),
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
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: _onPlayPauseTap,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedIcon(
                          icon: AnimatedIcons.play_pause,
                          progress: _playPauseController,
                          size: 80,
                        ),
                        // LottieBuilder.asset(
                        //   "assets/animations/play-lottie.json",
                        //   controller: _playPauseController,
                        //   width: 200,
                        //   height: 200,
                        //   // onLoaded : 개발자가 의도하는 애니메이션 성질을 반영(필요 시)
                        //   // _반영안해도 무관
                        //   onLoaded: (composition) {
                        //     _playPauseController.duration = composition.duration;
                        //   },
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onHorizontalDragUpdate: _onVolumeDragUpdate,
                    onHorizontalDragStart: (_) => _toggleDragging(),
                    onHorizontalDragEnd: (_) => _toggleDragging(),
                    child: AnimatedScale(
                      scale: _dragging ? 1.1 : 1,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.bounceOut,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: ValueListenableBuilder(
                          valueListenable: _volume,
                          builder: (context, value, child) => CustomPaint(
                            size: Size(size.width - 80, 50),
                            painter: VolumePainter(volume: value),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
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

class VolumePainter extends CustomPainter {
  final double volume;

  VolumePainter({
    required this.volume,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = Colors.grey.shade300;

    final bgRect = Rect.fromLTWH(
      0,
      0,
      size.width,
      size.height,
    );

    canvas.drawRect(bgRect, bgPaint);

    final volumePaint = Paint()..color = Colors.grey.shade500;

    final volumeRect = Rect.fromLTWH(
      0,
      0,
      volume,
      size.height,
    );

    canvas.drawRect(volumeRect, volumePaint);
  }

  @override
  bool shouldRepaint(covariant VolumePainter oldDelegate) {
    return oldDelegate.volume != volume;
  }
}
