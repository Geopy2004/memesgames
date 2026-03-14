import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const RainbetSlot());
}

class RainbetSlot extends StatelessWidget {
  const RainbetSlot({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SlotPage(),
    );
  }
}

class SlotPage extends StatefulWidget {
  const SlotPage({super.key});

  @override
  State<SlotPage> createState() => _SlotPageState();
}

class _SlotPageState extends State<SlotPage> {
  final symbols = ["7", "💎", "🍒", "⭐", "🔔"];
  final Random random = Random();

  String r1 = "7";
  String r2 = "7";
  String r3 = "7";

  int coins = 100;
  String result = "";

  void spin() {
    if (coins < 5) return;

    coins -= 5;

    bool win = random.nextDouble() < 0.6;

    if (win) {
      String s = symbols[random.nextInt(symbols.length)];

      r1 = s;
      r2 = s;
      r3 = s;

      coins += 20;

      result = "WIN";
    } else {
      r1 = symbols[random.nextInt(symbols.length)];
      r2 = symbols[random.nextInt(symbols.length)];
      r3 = symbols[random.nextInt(symbols.length)];

      if (r1 == r2 && r2 == r3) {
        r3 = symbols[(symbols.indexOf(r3) + 1) % symbols.length];
      }

      result = "LOSE";
    }

    setState(() {});
  }

  Widget reel(symbol) {
    return Container(
      width: 90,
      height: 90,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xff1a1a22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xff6c63ff), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff6c63ff).withOpacity(0.4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Text(symbol, style: const TextStyle(fontSize: 36)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f0f14),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "RAIN SLOT",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Coins: $coins",
              style: const TextStyle(color: Colors.white70, fontSize: 18),
            ),

            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [reel(r1), reel(r2), reel(r3)],
            ),

            const SizedBox(height: 30),

            Text(
              result,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: result == "WIN" ? Colors.greenAccent : Colors.redAccent,
              ),
            ),

            const SizedBox(height: 40),

            GestureDetector(
              onTap: spin,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 60,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [Color(0xff6c63ff), Color(0xff3f3cff)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff6c63ff).withOpacity(0.5),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: const Text(
                  "SPIN",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
