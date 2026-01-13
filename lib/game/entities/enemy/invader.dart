import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/sprite.dart';
import '../../world/invaders_world.dart';
import 'strategies/shooting_strategy.dart';
import 'strategies/timed_shooting_strategy.dart';

class Invader extends SpriteAnimationComponent with HasGameReference {
  
  Invader({
    required super.position,
    required this.world,
  }) : super(size: Vector2(32, 32));
  
final InvadersWorld world;
  late ShootingStrategy shootingStrategy;
  double _moveDirection = 1;
  final double _moveSpeed = 40;
  double _shotCooldown = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Load spritesheet animation
    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: await game.images.load('invader_sheet.png'),
      columns: 2,
      rows: 1,
    );
    
    animation = spriteSheet.createAnimation(
      row: 0,
      from: 0,
      to: 1,
      stepTime: 0.5,
    );
    
    // Add move effect for bobbing animation
    add(
      MoveEffect.by(
        Vector2(0, 5),
        EffectController(
          duration: 0.8,
          alternate: true,
          infinite: true,
        ),
      ),
    );
    
    // Set shooting strategy
    shootingStrategy = TimedShotStrategy(interval: 2.0 + (position.y / 100));
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Horizontal movement
    position.x += _moveDirection * _moveSpeed * dt;
    
    // Check bounds for direction change
    if (position.x <= 30 || position.x >= game.size.x - size.x - 30) {
      _moveDirection *= -1;
      position.y += 20; // Move down
    }
    
    // Shooting logic using strategy pattern
    _shotCooldown -= dt;
    if (_shotCooldown <= 0 && shootingStrategy.shouldShoot()) {
      shoot();
      _shotCooldown = shootingStrategy.getCooldown();
    }
  }
  
  void shoot() {
    final projectile = world.projectilePool.acquire(
      position: position + Vector2(size.x / 2 - 4, size.y + 10),
      velocity: Vector2(0, 300),
      isFromPlayer: false,
    );
    world.add(projectile);
  }
  
  void takeHit() {
    world.removeInvader(this);
  }
}