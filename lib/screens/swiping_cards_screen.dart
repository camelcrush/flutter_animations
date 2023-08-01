import 'dart:math';

import 'package:flutter/material.dart';

class SwipingCardsScreen extends StatefulWidget {
  const SwipingCardsScreen({super.key});

  @override
  State<SwipingCardsScreen> createState() => _SwipingCardsScreenState();
}

class _SwipingCardsScreenState extends State<SwipingCardsScreen>
    with SingleTickerProviderStateMixin {
  late final size = MediaQuery.of(context).size;
  int _index = 1;

  late final AnimationController _position = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
    // 기본적으로 AnimationController의 값 범위는 [0,1]이므로 아래와 같이 설정해줘야 함
    upperBound: (size.width + 100),
    lowerBound: (size.width + 100) * -1,
    value: 0,
  );

// Tween : 값의 상하한을 정할 때 사용, 여기서는 animation을 사용하지 않기 때문에 .animate()를 하지않음
  late final Tween<double> _rotation = Tween(
    begin: -15,
    end: 15,
  );

  late final Tween<double> _scale = Tween(
    begin: 0.8,
    end: 1.0,
  );

  void _whenComplete() {
    // Animation이 종료되면 value를 0값으로 초기화
    _position.value = 0;
    setState(() {
      _index = _index == 5 ? 1 : _index + 1;
    });
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _position.value += details.delta.dx;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final bound = size.width - 200;
    final dropZone = size.width + 100;
    if (_position.value.abs() >= bound) {
      final factor = _position.value.isNegative ? -1 : 1;
      _position
          .animateTo(
            (dropZone) * factor,
            curve: Curves.easeOut,
          )
          .whenComplete(_whenComplete);
    } else {
      _position.animateTo(
        0,
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _position.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Swiping Cards"),
      ),
      body: AnimatedBuilder(
        animation: _position,
        builder: (context, child) {
          // transform : _position값을 interpolation하여 angle값의 상하한을 결정
          // 즉, transform(animationValue)에서 animationValue가 0이면 -15, 1이면 15를 반환
          // AnimationValue를 0~1사이로 만들고 아래와 같이 중간값인 0을 가지기 위해 0으로 만들어주어야 함
          // 따라서 아래와 같은 계산식을 통해 angle값을 0으로 초기화하기 위해 추가 보정해야 함
          // pi / 180은 래디안으로 변환공식
          final angle = _rotation
                  .transform((_position.value + size.width / 2) / size.width) *
              pi /
              180;
          final scale = _scale.transform(_position.value.abs() / size.width);
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 50,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onHorizontalDragUpdate,
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                  child: Transform.scale(
                    // AnimationContoller.value가 1을 넘어가기 때문에 min()으로 최소값으로 제한
                    scale: min(scale, 1.0),
                    child: Card(
                      index: _index == 5 ? 1 : _index + 1,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 50,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onHorizontalDragUpdate,
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                  child: Transform.translate(
                    offset: Offset(_position.value, 0),
                    child: Transform.rotate(
                      angle: angle,
                      // angle: angle,
                      child: Card(index: _index),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Card extends StatelessWidget {
  final int index;

  const Card({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: size.width * 0.8,
          height: size.height * 0.6,
          child: Image.asset(
            'assets/covers/$index.jpg',
            fit: BoxFit.cover,
          ),
        ));
  }
}
