import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

List<Color> colors = [
  Colors.purple,
  Colors.black,
  Colors.blue,
];

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
              for (var index in [0, 1, 2])
                Hero(
                  tag: "$index",
                  child: CreditCard(
                    index: index,
                    isExpanded: _isExpanded,
                  )
                      .animate(
                        // 애니메이션 목표치에 대해 0~1 사이
                        target: _isExpanded ? 0 : 1,
                        delay: 1.5.seconds,
                      )
                      .flipV(
                        end: 0.1,
                      )
                      .slideY(
                        end: -0.8 * index,
                      ),
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

class CreditCard extends StatefulWidget {
  final int index;
  final bool isExpanded;

  const CreditCard({
    super.key,
    required this.index,
    required this.isExpanded,
  });

  @override
  State<CreditCard> createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  void _onTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CardDetailScreen(
          index: widget.index,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Hero 위젯을 쓸 때 화면 이동간에 text가 깨지는 현상이 발생
    // text가 서로 다른 화면의 Scaffold를 이동하는 상황에서 잠시동안 Scaffold를 벗어나게 되어 발생
    // Material 위젯을 사용하여 text가 존재할 수 있는 조건들을 추가해 주어 버그를 해결
    return Material(
      type: MaterialType.transparency,
      // AbsorbPointer : GestureDetector 중첩현상 해결
      child: AbsorbPointer(
        absorbing: !widget.isExpanded,
        child: GestureDetector(
          onTap: _onTap,
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: colors[widget.index],
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
      ),
    );
  }
}

class CardDetailScreen extends StatelessWidget {
  final int index;

  const CardDetailScreen({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transactions"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Hero(
              tag: "$index",
              child: CreditCard(
                index: index,
                isExpanded: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
