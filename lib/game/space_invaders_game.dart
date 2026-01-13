// ignore_for_file: sort_constructors_first

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'bloc/game_bloc.dart';
import 'bloc/game_event.dart';
import 'bloc/game_state.dart';
import 'entities/player/player.dart';
import 'entities/enemy/invader.dart';
import 'entities/projectile/projectile.dart';
import 'entities/enemy/strategies/random_shot_strategy.dart';

class SpaceInvadersGame extends FlameGame with KeyboardEvents {
  final GameBloc gameBloc;
  late Player player;
  final List<Invader> invaders = [];
  final List<Projectile> projectiles = [];
  
  SpaceInvadersGame({required this.gameBloc});
  
  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    print('Starting game initialization...');
    
    try {
      // Preload audio
      await FlameAudio.audioCache.load('explosion.wav');
      await FlameAudio.audioCache.load('shoot.wav');
      
      // Load all images
      await images.loadAll([
        'player.png',
        'space__0002_B1.png',
        'space__0003_B2.png',
        'ProjectileB_1.png',
        'space__0009_EnemyExplosion.png',
      ]);
      
      print('All assets loaded successfully');
      
      // Create player
      player = Player(
        position: Vector2(size.x / 2, size.y - 100),
        size: Vector2(50, 50),
      );
      add(player);
      
      // Create invaders
      _createInvaders();
      
    } catch (e) {
      print('Error during game initialization: $e');
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
          position: Vector2(
            startX + col * spacingX,
            startY + row * spacingY,
          ),
          size: Vector2(40, 40),
          shootingStrategy: RandomShotStrategy(0.5),
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
    invader.removeFromParent();
    invaders.remove(invader);
    gameBloc.add(const InvaderDestroyed());
    FlameAudio.play('explosion.wav', volume: 0.7);
    
    if (invaders.isEmpty) {
      gameBloc.add(const GameWon());
    }
  }
  
  void hitPlayer() {
    gameBloc.add(const PlayerHit());
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Check for collisions
    _checkCollisions();
    
    // Update game state
    final state = gameBloc.state;
    if (state is GameRunning && state.isGameOver) {
      // Game over logic
    }
  }
  
  void _checkCollisions() {
    // Check player projectiles vs invaders
    for (final projectile in projectiles.where((p) => !p.isEnemy)) {
      for (final invader in invaders) {
        if (projectile.toRect().overlaps(invader.toRect())) {
          projectile.removeFromParent();
          projectiles.remove(projectile);
          destroyInvader(invader);
          break;
        }
      }
    }
    
    // Check enemy projectiles vs player
    for (final projectile in projectiles.where((p) => p.isEnemy)) {
      if (projectile.toRect().overlaps(player.toRect())) {
        projectile.removeFromParent();
        projectiles.remove(projectile);
        hitPlayer();
        break;
      }
    }
    
    // Clean up removed projectiles
    projectiles.removeWhere((p) => p.isRemoved);
  }
}