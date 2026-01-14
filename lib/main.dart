import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'game/space_invaders_game.dart';
import 'game/bloc/game_bloc.dart';
import 'game/bloc/game_event.dart';
import 'game/bloc/game_state.dart';
import 'game/ui/hud.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Space Invaders',
      theme: ThemeData.dark(),
      home: BlocProvider(
        create: (context) => GameBloc(),
        child: const GameScreen(),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final SpaceInvadersGame _game;

  @override
  void initState() {
    super.initState();
    _game = SpaceInvadersGame(gameBloc: context.read<GameBloc>());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _game.startBackgroundMusic();
        },
        child: GameWidget(
          game: _game,
          overlayBuilderMap: {
            'hud': (context, game) {
              return BlocBuilder<GameBloc, GameState>(
                builder: (context, state) {
                  return HUD(
                    state: state,
                    onReset: () {
                      context.read<GameBloc>().add(const ResetGame());
                    },
                  );
                },
              );
            },
          },
          initialActiveOverlays: const ['hud'],
        ),
      ),
    );
  }
}