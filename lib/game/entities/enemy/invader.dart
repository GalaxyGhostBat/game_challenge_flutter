// ignore_for_file: sort_constructors_first

import 'package:flame/components.dart';
import 'strategies/shooting_strategy.dart';
import '../../space_invaders_game.dart';

class Invader extends SpriteComponent with HasGameReference<SpaceInvadersGame> {
  final ShootingStrategy shootingStrategy;
  double moveSpeed = 50;
  double direction = 1;
  double timeSinceLastMove = 0;
  double moveInterval = 1.0;
  
  Invader({
    required super.position,
    required super.size,
    required this.shootingStrategy,
  });
  
  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Alternate between two enemy sprites for variety
    final spriteName = (position.x.toInt() + position.y.toInt()) % 2 == 0
        ? 'space__0002_B1.png'
        : 'space__0003_B2.png';
    
    sprite = Sprite(game.images.fromCache(spriteName));
    anchor = Anchor.center;
    
    print('Invader loaded at position: $position');
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    timeSinceLastMove += dt;
    
    // Move sideways
    if (timeSinceLastMove >= moveInterval) {
      position.x += moveSpeed * direction;
      timeSinceLastMove = 0;
      
      // Reverse direction at screen edges
      if (position.x <= size.x / 2 || position.x >= game.size.x - size.x / 2) {
        direction *= -1;
        position.y += 20; // Move down
      }
    }
    
    // Check if should shoot
    shootingStrategy.update(dt);
    if (shootingStrategy.shouldShoot(dt)) {
      shoot();
    }
  }
  
  void shoot() {
    game.shootProjectile(
      Vector2(position.x, position.y + size.y / 2),
      true,
    );
  }
}