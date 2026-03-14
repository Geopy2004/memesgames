import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class ReelWidget extends StatefulWidget {
  final String symbol;

  const ReelWidget({super.key, required this.symbol});

  @override
  State<ReelWidget> createState() => _ReelWidgetState();

  // Spin reels with animation and return FINAL result once
  static void spinReel(
    List<String> symbols,
    Function(String, String, String) onFrame,
    Function(String, String, String) onComplete,
  ) {
    final random = Random();

    int reel1 = random.nextInt(symbols.length);
    int reel2 = random.nextInt(symbols.length);
    int reel3 = random.nextInt(symbols.length);

    int frame = 0;
    const totalFrames = 18;

    Timer.periodic(const Duration(milliseconds: 80), (timer) {
      frame++;

      // reel 1 stops first
      if (frame < 12) {
        reel1 = random.nextInt(symbols.length);
      }

      // reel 2 stops second
      if (frame < 15) {
        reel2 = random.nextInt(symbols.length);
      }

      // reel 3 stops last
      if (frame < totalFrames) {
        reel3 = random.nextInt(symbols.length);
      }

      onFrame(symbols[reel1], symbols[reel2], symbols[reel3]);

      if (frame >= totalFrames) {
        timer.cancel();

        // FINAL result only once
        onComplete(symbols[reel1], symbols[reel2], symbols[reel3]);
      }
    });
  }
}

class _ReelWidgetState extends State<ReelWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController glowController;

  @override
  void initState() {
    super.initState();

    glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowController,
      builder: (context, child) {
        return Container(
          width: 110,
          height: 110,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xff1a1a22),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xff7b6cff), width: 3),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xff7b6cff,
                ).withOpacity(0.3 + glowController.value * 0.3),
                blurRadius: 15 + glowController.value * 10,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              widget.symbol,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => const Icon(
                    Icons.image_not_supported,
                    color: Colors.white54,
                    size: 40,
                  ),
            ),
          ),
        );
      },
    );
  }
}
