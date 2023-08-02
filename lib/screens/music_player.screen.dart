import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animations/screens/music_player_detail.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  // PageController로 PageView 컨트럴로로 사용할 수 있으며 viewportFraction을 통해 사이즈 비율 조절 가능
  late final PageController _pageController = PageController(
    viewportFraction: 0.8,
  );

  int _currentPage = 0;
  // ValueNotifier를 통해 _pageController.value을 저장하고
  // UI위젯(ValueListenableBuiler)에 해당 value를 사용할 예정.
  final ValueNotifier<double> _scroll = ValueNotifier(0.0);

  void _onChanged(int newPage) {
    setState(() {
      _currentPage = newPage;
    });
  }

  @override
  void initState() {
    super.initState();
    // PageController에 Listener를 추가하여 ValueNotifier에 page값을 저장
    _pageController.addListener(() {
      if (_pageController.page == null) return;
      _scroll.value = _pageController.page!;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MusicPlayerDetailScreen(index: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // AnimatedSwitcher : child가 변할 때마다 애니메이션을 실행해주는 위젯
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Container(
              // Container가 완전히 봐뀌는 것이 아니라서(배경만 바뀜) 고유 key를 부여해줘야
              // flutter가 변화를 인지하고 AnimatedSwitcher가 애니메이션을 실행함
              key: ValueKey(_currentPage),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/covers/${_currentPage + 1}.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              // BackdropFilter : Child를 대상으로 filter를 적용해주는 위젯
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 20,
                  sigmaY: 20,
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          ),
          PageView.builder(
            onPageChanged: _onChanged,
            controller: _pageController,
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ValueListenableBuilder는 화면에 필요한 위젯만 선택적으로 빌드함
                  ValueListenableBuilder(
                    valueListenable: _scroll,
                    builder: (context, scroll, child) {
                      // scroll(value) : ValueNotifier에 저장된 PageController.page
                      // scroll값과 현재 index값의 차이
                      final difference = (scroll - index).abs();
                      // scale값은 difference 기준으로 양 옆, 가운데 위젯에 다르게 적용됨
                      final scale = 1 - difference * 0.1;
                      return GestureDetector(
                        onTap: () => _onTap(index + 1),
                        // Hero : 페이지 이동시 대상 위젯을 그대로 옮겨주는 듯한 애니효과를 줌
                        child: Hero(
                          tag: "${index + 1}",
                          child: Transform.scale(
                            scale: scale,
                            child: Container(
                              height: 350,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/covers/${index + 1}.jpg"),
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
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Interstellar",
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Hans Zimmer",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  )
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
