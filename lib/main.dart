import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flame/game.dart';
import 'game/space_invaders_game.dart';
import 'game/bloc/game_bloc.dart';
import 'game/ui/hud.dart';

void main() {
  runApp(const SpaceInvadersApp());
}

class SpaceInvadersApp extends StatelessWidget {
  const SpaceInvadersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Space Invaders',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
      ),
      home: BlocProvider(
        create: (_) => GameBloc(),
        child: const GameScreen(),
      ),
    );
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Game widget
          GameWidget(
            game: SpaceInvadersGame(gameBloc: context.read<GameBloc>()),
            loadingBuilder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          // HUD overlay
          const Positioned.fill(
            child: HUD(),
          ),
        ],
      ),
    );
  }
}