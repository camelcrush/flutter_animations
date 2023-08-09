import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveScreen extends StatefulWidget {
  const RiveScreen({super.key});

  @override
  State<RiveScreen> createState() => _RiveScreenState();
}

class _RiveScreenState extends State<RiveScreen> {
  late final StateMachineController _stateMachineController;

  // Artboard에 controller 초기화
  void _onInit(Artboard artboard) {
    _stateMachineController = StateMachineController.fromArtboard(
      artboard,
      "state",
      onStateChange: (stateMachineName, stateName) {
        print(stateMachineName);
        print(stateName);
      },
    )!;
    artboard.addController(_stateMachineController);
  }

  void _togglePanel() {
    final input = _stateMachineController.findInput<bool>("panelActive")!;
    input.change(!input.value);
  }

  @override
  void dispose() {
    _stateMachineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            width: size.width,
            height: size.height / 2,
            child: const RiveAnimation.asset(
              "assets/animations/balls-animation.riv",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 0,
            width: size.width,
            height: size.height / 2,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 50,
                sigmaY: 50,
              ),
              child: const Center(
                widthFactor: 1,
                heightFactor: 1,
                child: Text(
                  "Welcome",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
          Positioned(
            top: (size.height / 2) - 270,
            width: size.width,
            height: size.height / 2,
            child: const RiveAnimation.asset(
              "assets/animations/custom-button-animation.riv",
              stateMachines: ["state"],
            ),
          ),
          Positioned(
            top: (size.height / 2) - 270,
            width: size.width,
            height: size.height / 2,
            child: const Center(
                child: Text(
              "Log in",
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )),
          ),
          Positioned(
            top: size.height / 2,
            width: size.width,
            height: size.height / 2,
            child: Center(
              child: Container(
                color: const Color(0xFFFF2ECC),
                width: double.infinity,
                child: RiveAnimation.asset(
                  "assets/animations/stars-animation.riv",
                  // artboard: 캔버스
                  artboard: "artboard",
                  // stateMachines: 가지고 있는 Animation set
                  stateMachines: const ["state"],
                  // Controller 초기화 funtion
                  onInit: _onInit,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
