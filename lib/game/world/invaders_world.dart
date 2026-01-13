import 'dart:ui';
import 'package:flame/components.dart';
import '../bloc/game_bloc.dart';
import '../bloc/game_event.dart';
import '../entities/player/player.dart';
import '../entities/enemy/invader.dart';
import '../pool/projectile_pool.dart';
import '../effects/explosion_particle.dart';
import '../utils/audio_manager.dart';
import '../space_invaders_game.dart';

class InvadersWorld extends World with HasGameReference, HasCollisionDetection {
  InvadersWorld({required this.gameBloc}) : super();

  final GameBloc gameBloc;
  late Player player;
  final List<Invader> enemies = [];
  late ProjectilePool projectilePool;
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Initialize projectile pool
    projectilePool = ProjectilePool();
    projectilePool.initialize(this);
    
    // Create player
    player = Player(
      position: Vector2(game.size.x / 2, game.size.y - 80),
      world: this,
    );
    add(player);
    
    // Create invaders
    _createInvaderGrid();
    
    // Setup collision detection
    _setupCollisions();
    
    // Start background music
    AudioManager.playBackgroundMusic();
  }
  
  void _createInvaderGrid() {
    const rows = 5;
    const cols = 11;
    const spacing = 55.0;
    
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final invader = Invader(
          position: Vector2(
            100.0 + col * spacing,
            60.0 + row * spacing,
          ),
          world: this,
        );
        enemies.add(invader);
        add(invader);
      }
    }
  }
  
  void _setupCollisions() {
    // Collision detection is handled by Flame's HasCollisionDetection
  }
  
  void removeInvader(Invader invader) {
    enemies.remove(invader);
    remove(invader);
    
    // Add explosion effect
    add(ExplosionParticle(
      position: invader.position,
      color: const Color(0xFF00FF00),
    ));
    
    // Update score
    gameBloc.add(const InvaderDestroyed());
    
    // Play explosion sound
    AudioManager.playExplosion();
  }
  
  void playerHit() {
    gameBloc.add(const PlayerHit());
    
    // Trigger screen shake
    if (game is SpaceInvadersGame) {
      (game as SpaceInvadersGame).triggerScreenShake(0.5);
    }
    
    // Add hit effect
    add(ExplosionParticle(
      position: player.position,
      color: const Color(0xFFFF0000),
      scaleFactor: 2.0,
    ));
    
    // Play hit sound
    AudioManager.playExplosion();
  }
  
  void spawnExplosion(Vector2 position, {Color color = const Color(0xFFFFFF00)}) {
    add(ExplosionParticle(position: position, color: color));
  }
}