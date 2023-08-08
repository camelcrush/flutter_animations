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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rive"),
      ),
      body: Center(
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
    );
  }
}
