import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const BagangBagangGame());
}

class BagangBagangGame extends StatelessWidget {
  const BagangBagangGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bagang Bagang Game', // your project name in the app title
      debugShowCheckedModeBanner: false,
      home: const GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  double ballX = 0.0;
  double ballY = 0.0;
  double speed = 5;
  int score = 0;
  bool gameOver = false;

  late Timer timer;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        ballY += speed;

        // If ball reaches bottom → game over
        if (ballY > MediaQuery.of(context).size.height - 80) {
          gameOver = true;
          timer.cancel();
        }
      });
    });
  }

  void resetBall() {
    setState(() {
      ballY = 0;
      ballX = random.nextDouble() *
          (MediaQuery.of(context).size.width - 50); // random horizontal
      speed += 0.5; // make it faster
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      body: Stack(
        children: [
          Positioned(
            top: 50,
            left: 20,
            child: Text(
              'Score: $score',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          if (!gameOver)
            Positioned(
              top: ballY,
              left: ballX,
              child: GestureDetector(
                onTap: () {
                  score++;
                  resetBall();
                },
                child: const Icon(
                  Icons.circle,
                  color: Colors.red,
                  size: 50,
                ),
              ),
            ),
          if (gameOver)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Game Over!',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Score: $score',
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        score = 0;
                        speed = 5;
                        ballY = 0;
                        ballX = 0;
                        gameOver = false;
                        startGame();
                      });
                    },
                    child: const Text('Restart'),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
