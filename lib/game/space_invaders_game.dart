// ignore_for_file: sort_constructors_first

import 'dart:async';

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'utils/audio_manager.dart';
import 'package:flutter/foundation.dart';
import 'bloc/game_bloc.dart';
import 'bloc/game_event.dart';
import 'bloc/game_state.dart';
import 'entities/player/player.dart';
import 'entities/enemy/invader.dart';
import 'entities/projectile/projectile.dart';
import 'entities/enemy/strategies/random_shot_strategy.dart';
import 'effects/explosion_particle.dart';
import 'effects/screen_shake_effect.dart';

class SpaceInvadersGame extends FlameGame
  with KeyboardEvents, HasKeyboardHandlerComponents {
  final GameBloc gameBloc;

  late Player player;
  late final ScreenShakeEffect screenShake;
  bool playerAlive = true;
  final List<Invader> invaders = [];
  final List<Projectile> projectiles = [];

  // Invader block movement
  double invaderDirection = 1; // 1 = right, -1 = left
  double invaderSpeed = 20;
  double moveInterval = 0.5;
  double timeSinceLastMove = 0;

  SpaceInvadersGame({required this.gameBloc});

  late final StreamSubscription<GameState> gameBlocSub;
  bool bgmStarted = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    debugPrint('Starting game initialization...');

    try {
      // Preload audio
      await FlameAudio.audioCache.loadAll([
        'explosion.wav',
        'shoot.wav',
      ]);

      // Load all images
      await images.loadAll([
        'ship.png',
        'alien.png',
        'alien_2.png',
        'bullet.png',
        'explosion.png',
      ]);

      debugPrint('All assets loaded successfully');

      // Initialize audio manager (do NOT auto-play on web; wait for user gesture)
      try {
        await AudioManager.initialize();
      } catch (_) {}

      // Create player
      player = Player(
        position: Vector2(size.x / 2, size.y - 100),
        size: Vector2(50, 50),
      );
      add(player);

      // Screen shake effect
      screenShake = ScreenShakeEffect();
      add(screenShake);

      // Create invaders
      _createInvaders();

      // Listen to bloc state changes so we can pause/resume/reset the game
      gameBlocSub = gameBloc.stream.listen((state) {
        if (state is GameRunning && state.isGameOver) {
          pauseEngine();
          AudioManager.pauseBackgroundMusic();
        } else {
          // If returning to initial or running (not game over), ensure game runs
          resumeEngine();
          AudioManager.resumeBackgroundMusic();
        }

        if (state is GameInitial) {
          resetGame();
          // Restart background music only if already started by user gesture
          if (bgmStarted) {
            AudioManager.stopBackgroundMusic();
            AudioManager.playBackgroundMusic();
          }
        }
      });
    } catch (e, stackTrace) {
      debugPrint('Error during game initialization: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  @override
  void onRemove() {
    gameBlocSub.cancel();
    super.onRemove();
  }

  void startBackgroundMusic() {
    if (!bgmStarted) {
      bgmStarted = true;
      AudioManager.playBackgroundMusic();
    }
  }

  void _createInvaders() {
    const rows = 5;
    const cols = 10;
    const spacingX = 60.0;
    const spacingY = 60.0;
    const startX = 100.0;
    const startY = 100.0;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final invader = Invader(
          position: Vector2(startX + col * spacingX, startY + row * spacingY),
          size: Vector2(40, 40),
          shootingStrategy: RandomShotStrategy(1.0), // chance per second
        );
        invaders.add(invader);
        add(invader);
      }
    }
  }

  void shootProjectile(Vector2 position, bool isEnemy) {
    final projectile = Projectile(
      position: position,
      velocity: Vector2(0, isEnemy ? 300 : -300),
      isEnemy: isEnemy,
      size: Vector2(5, 15),
    );

    projectiles.add(projectile);
    add(projectile);

    if (!isEnemy) {
      FlameAudio.play('shoot.wav', volume: 0.5);
    }
  }

  void destroyInvader(Invader invader) {
    if (!invaders.contains(invader)) return;

    invader.removeFromParent();
    invaders.remove(invader);

    gameBloc.add(const InvaderDestroyed());
    FlameAudio.play('explosion.wav', volume: 0.7);

    if (invaders.isEmpty) {
      gameBloc.add(const GameWon());
    }
  }

  void hitPlayer() {
    final state = gameBloc.state;

    // If player already dead, ignore
    if (!playerAlive) return;

    // If this hit will kill the player, show explosion then send PlayerHit
    if (state is GameRunning && state.lives <= 1) {
      playerAlive = false;

      // Spawn explosion at player's position
      add(ExplosionParticle(position: player.position.clone(), scaleFactor: 1.5));
      FlameAudio.play('explosion.wav', volume: 0.9);

      // Shake the screen
      screenShake.shake(1.0, duration: 0.6);

      // Remove player sprite immediately for visual clarity
      try {
        player.removeFromParent();
      } catch (_) {}

      // Delay sending the event so explosion plays first
      Future.delayed(const Duration(milliseconds: 800), () {
        gameBloc.add(const PlayerHit());
      });
    } else {
      // Non-lethal hit: dispatch immediately
      gameBloc.add(const PlayerHit());
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Move invader block
    _updateInvaderMovement(dt);

    // Check collisions
    _checkCollisions();

    final state = gameBloc.state;
    if (state is GameRunning && state.isGameOver) {
      // Handle game over if needed
    }
  }

  void _updateInvaderMovement(double dt) {
    timeSinceLastMove += dt;
    if (timeSinceLastMove < moveInterval) return;

    double dx = invaderSpeed * invaderDirection;
    bool needMoveDown = false;

    // Check edges for all invaders
    for (final invader in invaders) {
      if ((invader.position.x + dx) < invader.size.x / 2 ||
          (invader.position.x + dx) > size.x - invader.size.x / 2) {
        needMoveDown = true;
        invaderDirection *= -1;
        break;
      }
    }

    for (final invader in invaders) {
      invader.position.x += invaderSpeed * invaderDirection;
      if (needMoveDown) invader.position.y += 20;
    }

    timeSinceLastMove = 0;
  }

  void resetGame() {
    // Remove invaders
    for (final invader in invaders) {
      invader.removeFromParent();
    }
    invaders.clear();

    // Remove projectiles
    for (final p in projectiles) {
      p.removeFromParent();
    }
    projectiles.clear();

    // Reset player: remove old and create a fresh one
    try {
      player.removeFromParent();
    } catch (_) {}
    player = Player(
      position: Vector2(size.x / 2, size.y - 100),
      size: Vector2(50, 50),
    );
    add(player);

    // Reset invader movement state
    invaderDirection = 1;
    invaderSpeed = 20;
    moveInterval = 0.5;
    timeSinceLastMove = 0;

    // Recreate invaders
    _createInvaders();

    playerAlive = true;
  }

  void _checkCollisions() {
    // Player bullets vs invaders
    for (final projectile in projectiles.where((p) => !p.isEnemy).toList()) {
      for (final invader in invaders.toList()) {
        if (projectile.toRect().overlaps(invader.toRect())) {
          projectile.removeFromParent();
          projectiles.remove(projectile);
          destroyInvader(invader);
          break;
        }
      }
    }

    // Enemy bullets vs player (only if player alive)
    if (playerAlive) {
      for (final projectile in projectiles.where((p) => p.isEnemy).toList()) {
        if (projectile.toRect().overlaps(player.toRect())) {
          projectile.removeFromParent();
          projectiles.remove(projectile);
          hitPlayer();
          break;
        }
      }
    }

    // Cleanup removed projectiles
    projectiles.removeWhere((p) => p.isRemoved);
  }
}
