import 'package:equatable/equatable.dart';

abstract class GameState extends Equatable {
  const GameState();
  
  int get score;
  int get lives;
  bool get isGameOver;
  bool get hasWon;
  
  @override
  List<Object?> get props => [];
}

class GameInitial extends GameState {
  const GameInitial();
  
  @override
  int get score => 0;
  
  @override
  int get lives => 3;
  
  @override
  bool get isGameOver => false;
  
  @override
  bool get hasWon => false;
  
  @override
  List<Object?> get props => [];
}

class GameRunning extends GameState {
  const GameRunning({
    required this.score,
    required this.lives,
    this.isGameOver = false,
    this.hasWon = false,
  });
  
  @override
  final int score;
  @override
  final int lives;
  @override
  final bool isGameOver;
  @override
  final bool hasWon;
  
  GameRunning copyWith({
    int? score,
    int? lives,
    bool? isGameOver,
    bool? hasWon,
  }) {
    return GameRunning(
      score: score ?? this.score,
      lives: lives ?? this.lives,
      isGameOver: isGameOver ?? this.isGameOver,
      hasWon: hasWon ?? this.hasWon,
    );
  }
  
  @override
  List<Object?> get props => [score, lives, isGameOver, hasWon];
}