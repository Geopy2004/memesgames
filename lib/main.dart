import 'package:flutter/material.dart';

import 'reel.dart';

void main() => runApp(const MemeSlotApp());

class MemeSlotApp extends StatelessWidget {
  const MemeSlotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MemeSlotMachine(),
    );
  }
}

class MemeSlotMachine extends StatefulWidget {
  const MemeSlotMachine({super.key});

  @override
  State<MemeSlotMachine> createState() => _MemeSlotMachineState();
}

class _MemeSlotMachineState extends State<MemeSlotMachine> {
  final List<String> symbols = [
    "assets/file/doge.jpg",
    "assets/file/pepe.png",
    "assets/file/troll.png",
    "assets/file/wojak.png",
    "assets/file/chad.jpg",
  ];

  int coins = 100;
  int betAmount = 5;

  late String reel1;
  late String reel2;
  late String reel3;

  bool isSpinning = false;

  @override
  void initState() {
    super.initState();
    reel1 = symbols[0];
    reel2 = symbols[1];
    reel3 = symbols[2];
  }

  void spin() {
    if (coins < betAmount || isSpinning) return;

    setState(() {
      coins -= betAmount;
      isSpinning = true;
    });

    ReelWidget.spinReel(
      symbols,

      // Animation frames
      (s1, s2, s3) {
        setState(() {
          reel1 = s1;
          reel2 = s2;
          reel3 = s3;
        });
      },

      // Final result
      (s1, s2, s3) {
        setState(() {
          reel1 = s1;
          reel2 = s2;
          reel3 = s3;
        });

        final result = checkWin();

        showResultDialog(result["message"], result["reward"]);
      },
    );
  }

  Map<String, dynamic> checkWin() {
    int reward = 0;
    String message = "💀 YOU LOSE";

    // JACKPOT
    if (reel1 == reel2 && reel2 == reel3) {
      reward = betAmount * 6;
      message = "🎉 JACKPOT!";
    }
    // TWO MATCH
    else if (reel1 == reel2 || reel2 == reel3 || reel1 == reel3) {
      reward = betAmount * 2;
      message = "✨ SMALL WIN!";
    }
    // CHAD BONUS
    else if (reel1.contains("chad") ||
        reel2.contains("chad") ||
        reel3.contains("chad")) {
      reward = betAmount;
      message = "🗿 CHAD BONUS!";
    }

    coins += reward;

    return {"reward": reward, "message": message};
  }

  void showResultDialog(String message, int reward) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xff1c1c25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  reward > 0 ? Icons.emoji_events : Icons.close,
                  color: reward > 0 ? Colors.amber : Colors.redAccent,
                  size: 60,
                ),
                const SizedBox(height: 20),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: reward > 0 ? Colors.greenAccent : Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  reward > 0 ? "+$reward coins!" : "Better luck next spin!",
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);

                    setState(() {
                      isSpinning = false;
                    });
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget betButton(int amount) {
    bool selected = betAmount == amount;

    return ElevatedButton(
      onPressed:
          isSpinning
              ? null
              : () {
                setState(() {
                  betAmount = amount;
                });
              },
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? Colors.orange : const Color(0xff6c63ff),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text("$amount", style: const TextStyle(fontSize: 18)),
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
              "MEME SLOT",
              style: TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  "$coins",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ReelWidget(symbol: reel1),
                ReelWidget(symbol: reel2),
                ReelWidget(symbol: reel3),
              ],
            ),

            const SizedBox(height: 30),

            const Text("BET AMOUNT", style: TextStyle(color: Colors.white70)),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                betButton(5),
                const SizedBox(width: 10),
                betButton(10),
                const SizedBox(width: 10),
                betButton(20),
              ],
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: isSpinning ? null : spin,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 80,
                  vertical: 20,
                ),
                backgroundColor: const Color(0xff6c63ff),
              ),
              child: const Text(
                "SPIN",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
