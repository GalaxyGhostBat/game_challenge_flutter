import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();
  
  @override
  List<Object?> get props => [];
}

class PlayerHit extends GameEvent {
  const PlayerHit();
  
  @override
  List<Object?> get props => [];
}

class InvaderDestroyed extends GameEvent {
  const InvaderDestroyed();
  
  @override
  List<Object?> get props => [];
}

class ResetGame extends GameEvent {
  const ResetGame();
  
  @override
  List<Object?> get props => [];
}

class GameWon extends GameEvent {
  const GameWon();
  
  @override
  List<Object?> get props => [];
}

class KeyPressed extends GameEvent {
    const KeyPressed(this.key);
    
  final String key;

  @override
  List<Object?> get props => [key];
}