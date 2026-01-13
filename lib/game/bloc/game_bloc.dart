import 'package:flutter_bloc/flutter_bloc.dart';
import 'game_event.dart';
import 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(const GameInitial()) {
    on<PlayerHit>((event, emit) {
      if (state is GameRunning) {
        final currentState = state as GameRunning;
        final newLives = currentState.lives - 1;
        
        if (newLives <= 0) {
          emit(currentState.copyWith(
            lives: 0,
            isGameOver: true,
            hasWon: false,
          ));
        } else {
          emit(currentState.copyWith(lives: newLives));
        }
      } else {
        emit(const GameRunning(score: 0, lives: 2, isGameOver: false, hasWon: false));
      }
    });
    
    on<InvaderDestroyed>((event, emit) {
      if (state is GameRunning) {
        final currentState = state as GameRunning;
        emit(currentState.copyWith(score: currentState.score + 100));
      } else {
        emit(const GameRunning(score: 100, lives: 3, isGameOver: false, hasWon: false));
      }
    });
    
    on<ResetGame>((event, emit) {
      emit(const GameInitial());
    });
    
    on<GameWon>((event, emit) {
      if (state is GameRunning) {
        final currentState = state as GameRunning;
        emit(currentState.copyWith(hasWon: true, isGameOver: true));
      }
    });
  }
}