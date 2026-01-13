import 'package:flutter/material.dart';
import '../bloc/game_state.dart';

class HUD extends StatelessWidget {
  final GameState state;
  final VoidCallback onReset;
  
  const HUD({
    Key? key,  // Added Key parameter
    required this.state,
    required this.onReset,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final score = state is GameRunning ? (state as GameRunning).score : 0;
    final lives = state is GameRunning ? (state as GameRunning).lives : 3;
    final isGameOver = state is GameRunning ? (state as GameRunning).isGameOver : false;
    final hasWon = state is GameRunning ? (state as GameRunning).hasWon : false;
    
    return Stack(
      children: [
        // Score
        Positioned(
          top: 20,
          left: 20,
          child: Text(
            'Score: $score',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: 'PressStart2P',
            ),
          ),
        ),
        
        // Lives
        Positioned(
          top: 20,
          right: 20,
          child: Row(
            children: [
              const Text(
                'Lives: ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'PressStart2P',
                ),
              ),
              ...List.generate(lives, (index) => const Padding(
                padding: EdgeInsets.only(left: 5),
                child: Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 24,
                ),
              )),
            ],
          ),
        ),
        
        // Game Over Overlay
        if (isGameOver)
          Container(
            color: Colors.black.withAlpha(150),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    hasWon ? 'YOU WIN!' : 'GAME OVER',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontFamily: 'PressStart2P',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Final Score: $score',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'PressStart2P',
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: onReset,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: const Text(
                      'PLAY AGAIN',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'PressStart2P',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}