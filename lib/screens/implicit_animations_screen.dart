import 'package:flutter/material.dart';

class ImplicitAnimationsScreen extends StatefulWidget {
  const ImplicitAnimationsScreen({super.key});

  @override
  State<ImplicitAnimationsScreen> createState() =>
      _ImplicitAnimationsScreenState();
}

class _ImplicitAnimationsScreenState extends State<ImplicitAnimationsScreen> {
  bool _visible = true;

  void _trigger() {
    setState(() {
      _visible = !_visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Implicit Animations"),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            curve: Curves.elasticInOut,
            duration: const Duration(seconds: 2),
            transform: Matrix4.rotationZ(_visible ? 1 : 0),
            transformAlignment: Alignment.center,
            width: size.width * 0.8,
            height: size.width * 0.8,
            decoration: BoxDecoration(
              color: _visible ? Colors.red : Colors.amber,
              borderRadius: BorderRadius.circular(_visible ? 100 : 0),
            ),
          ),
          // // Implicit Animation
          // TweenAnimationBuilder(
          //   tween: ColorTween(
          //     begin: Colors.yellow,
          //     end: Colors.red,
          //   ),
          //   curve: Curves.bounceIn,
          //   duration: const Duration(seconds: 3),
          //   builder: (context, value, child) {
          //     return Image.network(
          //       "https://upload.wikimedia.org/wikipedia/commons/4/4f/Dash%2C_the_mascot_of_the_Dart_programming_language.png",
          //       color: value,
          //       // BlendMode : 색상조합설정
          //       colorBlendMode: BlendMode.colorBurn,
          //     );
          //   },
          // ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: _trigger,
            child: const Text("Go"),
          ),
        ],
      )),
    );
  }
}
