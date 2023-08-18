import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _isExpanded = false;

  void _onExpand() {
    setState(() {
      _isExpanded = true;
    });
  }

  void _onShrink() {
    setState(() {
      _isExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallet"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GestureDetector(
          onVerticalDragEnd: (_) => _onShrink(),
          onTap: _onExpand,
          child: Column(
            // children: AnimateList(
            //   interval: 500.milliseconds,
            //   effects: [
            //     const SlideEffect(
            //       begin: Offset(-1, 0),
            //       end: Offset.zero,
            //     ),
            //     const FadeEffect(
            //       begin: 0,
            //       end: 1,
            //     )
            //   ],
            //   children: [
            //     const CreditCard(bgColor: Colors.purple),
            //     const CreditCard(bgColor: Colors.black),
            //     const CreditCard(bgColor: Colors.blue),
            //   ],
            // ),
            children: [
              const CreditCard(bgColor: Colors.purple)
                  .animate(
                    // 애니메이션 목표치에 대해 0~1 사이
                    target: _isExpanded ? 0 : 1,
                    delay: 1.5.seconds,
                  )
                  .flipV(
                    end: 0.1,
                  ),
              const CreditCard(bgColor: Colors.black)
                  .animate(
                    target: _isExpanded ? 0 : 1,
                    delay: 1.5.seconds,
                  )
                  .flipV(
                    end: 0.1,
                  )
                  .slideY(
                    end: -0.8,
                  ),
              const CreditCard(bgColor: Colors.blue)
                  .animate(
                    target: _isExpanded ? 0 : 1,
                    delay: 1.5.seconds,
                  )
                  .flipV(
                    end: 0.1,
                  )
                  .slideY(
                    end: -0.8 * 2,
                  ),
            ]
                .animate(
                  interval: 500.milliseconds,
                )
                .fadeIn(
                  begin: 0,
                )
                .slideX(
                  begin: -1,
                  end: 0,
                ),
          ),
        ),
      ),
    );
  }
}

class CreditCard extends StatelessWidget {
  final Color bgColor;

  const CreditCard({
    super.key,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: bgColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 40,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Camel Crush",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "**** **** **99",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 20,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.amber,
                        ),
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
