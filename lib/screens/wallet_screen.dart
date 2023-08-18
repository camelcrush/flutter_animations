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
              CreditCard(
                bgColor: Colors.purple,
                isExpanded: _isExpanded,
              )
                  .animate(
                    // 애니메이션 목표치에 대해 0~1 사이
                    target: _isExpanded ? 0 : 1,
                    delay: 1.5.seconds,
                  )
                  .flipV(
                    end: 0.1,
                  ),
              CreditCard(
                bgColor: Colors.black,
                isExpanded: _isExpanded,
              )
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
              CreditCard(
                bgColor: Colors.blue,
                isExpanded: _isExpanded,
              )
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

void _onTap() {
  print("hello");
}

class CreditCard extends StatelessWidget {
  final Color bgColor;
  final bool isExpanded;

  const CreditCard({
    super.key,
    required this.bgColor,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    // AbsorbPointer : GestureDetector 중첩현상 해결
    return AbsorbPointer(
      absorbing: !isExpanded,
      child: GestureDetector(
        onTap: _onTap,
        child: Container(
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
        ),
      ),
    );
  }
}
