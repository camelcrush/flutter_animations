import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 350,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/covers/${index + 1}.jpg"),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Interstellar",
                    style: TextStyle(fontSize: 26),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Hans Zimmer",
                    style: TextStyle(fontSize: 18),
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
