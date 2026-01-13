import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/game_bloc.dart';
import '../bloc/game_event.dart';
import '../bloc/game_state.dart';

class HUD extends StatelessWidget {
  const HUD({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Score and Lives
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'SCORE: ${state.score.toString().padLeft(6, '0')}',
                    style: const TextStyle(
                      fontSize: 24,
                      color: const Color(0xFF00FFFF),
                      fontFamily: 'Courier',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Row(
                    children: [
                      const Text(
                        'LIVES: ',
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontFamily: 'Courier',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ...List.generate(
                        state.lives,
                        (index) => const Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Icon(
                            Icons.favorite,
                            color: const Color(0xFFFF5555),
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Game Over/Win Screen
              if (state.isGameOver)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(150),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: state.hasWon ? Colors.green : Colors.red,
                        width: 3,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.hasWon ? 'VICTORY!' : 'GAME OVER',
                          style: TextStyle(
                            fontSize: 48,
                            color: state.hasWon ? Colors.green : Colors.red,
                            fontFamily: 'Courier',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'FINAL SCORE: ${state.score}',
                          style: const TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontFamily: 'Courier',
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            context.read<GameBloc>().add(ResetGame());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00AAFF),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'PLAY AGAIN',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}