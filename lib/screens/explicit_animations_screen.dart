import 'package:flutter/material.dart';

class ExplicitAnimationsScreen extends StatefulWidget {
  const ExplicitAnimationsScreen({super.key});

  @override
  State<ExplicitAnimationsScreen> createState() =>
      _ExplicitAnimationsScreenState();
}

class _ExplicitAnimationsScreenState extends State<ExplicitAnimationsScreen>
    with SingleTickerProviderStateMixin {
  // Ticker란 초당 60프레임 단위로 콜백을 실행하는 함수
  // SingleTickerProviderStateMixin은 Ticker를 제공해주고, 화면이 Out되면 Ticker를 제거해 주는 Mixin
  // AnimationController는 Minxin이 제공하는 Ticker를 활용하여 Animation을 만듦
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
    reverseDuration: const Duration(seconds: 1),
  );

  // Animation Valu를 만들어서 Controller에 연결해주기
  late final Animation<Color?> _color =
      ColorTween(begin: Colors.amber, end: Colors.red).animate(_curve);

  late final Animation<Decoration> _decoration = DecorationTween(
    begin: BoxDecoration(
      color: Colors.amber,
      borderRadius: BorderRadius.circular(20),
    ),
    end: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(120),
    ),
  ).animate(_curve);

  late final Animation<double> _rotation =
      Tween(begin: 0.0, end: 0.5).animate(_curve);

  late final Animation<double> _scale =
      Tween(begin: 1.0, end: 1.1).animate(_curve);

  late final Animation<Offset> _position = Tween(
    begin: Offset.zero,
    end: const Offset(0, -0.2),
  ).animate(_curve);

  // CurvedAnimation을 AnimationController에 연결하면 나머지 Animation들을 _curve로 연결
  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _animationController,
    curve: Curves.elasticOut,
    reverseCurve: Curves.bounceInOut,
  );

  void _play() {
    _animationController.forward();
  }

  void _pause() {
    _animationController.stop();
  }

  void _rewind() {
    _animationController.reverse();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explicit Animations"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _position,
              child: ScaleTransition(
                scale: _scale,
                child: RotationTransition(
                  turns: _rotation,
                  child: DecoratedBoxTransition(
                    decoration: _decoration,
                    child: const SizedBox(
                      width: 300,
                      height: 300,
                    ),
                  ),
                ),
              ),
            ),
            // // xxTransition 위젯이 없을 경우 AnimatedBuilder를 사용해아함
            // // AnimatedBuilder : AnimationController가 변하는동안 UI에 표시해주는 특수한 빌더
            // // child 위젯만 state를 업데이트 해줌(오직 하나의 Child에서만 적용)
            // AnimatedBuilder(
            //   animation: _color,
            //   builder: (context, child) {
            //     return Container(
            //       color: _color.value,
            //       width: 400,
            //       height: 400,
            //     );
            //   },
            // ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _play,
                  child: const Text("Go"),
                ),
                ElevatedButton(
                  onPressed: _pause,
                  child: const Text("Pause"),
                ),
                ElevatedButton(
                  onPressed: _rewind,
                  child: const Text("Rewind"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
