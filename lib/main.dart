import 'package:flutter/material.dart';

import 'reel.dart';

void main() => runApp(const VegasSlotApp());

class VegasSlotApp extends StatelessWidget {
  const VegasSlotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VegasSlotMachine(),
    );
  }
}

class VegasSlotMachine extends StatefulWidget {
  const VegasSlotMachine({super.key});

  @override
  State<VegasSlotMachine> createState() => _VegasSlotMachineState();
}

class _VegasSlotMachineState extends State<VegasSlotMachine> {
  final List<String> symbols = [
    "assets/file/doge.jpg",
    "assets/file/pepe.png",
    "assets/file/troll.png",
    "assets/file/wojak.png",
    "assets/file/chad.jpg",
  ];

  int coins = 500;
  int betAmount = 5;

  late String reel1;
  late String reel2;
  late String reel3;

  bool isSpinning = false;
  bool betPanelExpanded = false;

  int lastWin = 0;

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
      betPanelExpanded = false;
      lastWin = 0;
    });

    ReelWidget.spinReel(
      symbols,
      (s1, s2, s3) {
        setState(() {
          reel1 = s1;
          reel2 = s2;
          reel3 = s3;
        });
      },
      (s1, s2, s3) {
        setState(() {
          reel1 = s1;
          reel2 = s2;
          reel3 = s3;
        });

        final result = checkWin();
        lastWin = result["reward"];
        showResultDialog(result["message"], result["reward"]);
      },
    );
  }

  Map<String, dynamic> checkWin() {
    int reward = 0;
    String message = "💀 YOU LOSE";

    // JACKPOT (3 matching symbols)
    if (reel1 == reel2 && reel2 == reel3) {
      reward = betAmount * 6;
      message = "🎉 JACKPOT!";
    }
    // SMALL WIN (2 matching symbols)
    else if (reel1 == reel2 || reel2 == reel3 || reel1 == reel3) {
      reward = betAmount * 2;
      message = "✨ SMALL WIN!";
    }
    // SPECIAL SYMBOL BONUS (any Chad)
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

  Widget chipButton(int amount) {
    bool selected = betAmount == amount;

    return GestureDetector(
      onTap:
          isSpinning
              ? null
              : () {
                setState(() {
                  betAmount = amount;
                });
              },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: selected ? 70 : 50,
        height: selected ? 70 : 50,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.orange : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(selected ? 0.8 : 0.3),
              blurRadius: selected ? 12 : 4,
              spreadRadius: selected ? 2 : 1,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          "$amount",
          style: TextStyle(
            color: selected ? Colors.black : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: selected ? 22 : 18,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f0f14),
      body: Stack(
        children: [
          // Main slot UI
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                "VEGAS SLOT",
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
                  if (lastWin > 0) ...[
                    const SizedBox(width: 20),
                    Text(
                      "Last Win: $lastWin",
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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

          // Bottom sliding chip panel
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: betPanelExpanded ? 180 : 60,
              decoration: BoxDecoration(
                color: const Color(0xff1c1c25),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        betPanelExpanded = !betPanelExpanded;
                      });
                    },
                    child: Container(
                      width: 60,
                      height: 6,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white30,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  if (betPanelExpanded)
                    Column(
                      children: [
                        const Text(
                          "CHOOSE BET",
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              chipButton(5),
                              chipButton(10),
                              chipButton(20),
                              chipButton(50),
                              chipButton(100),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Potential Win: ${betAmount * 6} coins",
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
