import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/collisions.dart';
import '../../world/invaders_world.dart';
import '../player/player.dart';
import '../enemy/invader.dart';

class Projectile extends PositionComponent with CollisionCallbacks {
  Projectile({
    required Vector2 position,
    required this.velocity,
    required this.isFromPlayer,
    required this.world,
  }) : super(position: position, size: Vector2(8, 20)) {
    // Add hitbox
    add(RectangleHitbox());
  }

  Vector2 velocity;
  bool isFromPlayer;
  bool isActive = true;
  final InvadersWorld world;
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Add trail effect
    add(
      OpacityEffect.fadeOut(
        EffectController(
          duration: 0.3,
        ),
        onComplete: () {
          if (isActive) {
            world.projectilePool.release(this);
          }
        },
      ),
    );
  }
  
  void reset({required Vector2 position, required Vector2 velocity}) {
    this.position = position;
    this.velocity = velocity;
    isActive = true;
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    if (!isActive) return;
    
    // Move projectile
    position += velocity * dt;
    
    // Check bounds
    if (position.y < -50 || position.y > world.game.size.y + 50) {
      isActive = false;
      world.projectilePool.release(this);
    }
  }
  
  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    
    if (!isActive) return;
    
    if (isFromPlayer && other is Invader) {
      final invader = other;
      invader.takeHit();
      isActive = false;
      world.projectilePool.release(this);
    } else if (!isFromPlayer && other is Player) {
      final player = other;
      if (!player.isInvincible) {
        player.takeHit();
        isActive = false;
        world.projectilePool.release(this);
      }
    }
  }
  
  @override
  void render(Canvas canvas) {
    // Draw projectile
    final paint = Paint()
      ..color = isFromPlayer ? const Color(0xFF00FFFF) : const Color(0xFFFF5555)
      ..style = PaintingStyle.fill;
    
    // Custom shape for projectile
    final path = Path()
      ..moveTo(size.x / 2, 0)
      ..lineTo(size.x, size.y * 0.7)
      ..lineTo(size.x / 2, size.y)
      ..lineTo(0, size.y * 0.7)
      ..close();
    
    canvas.drawPath(path, paint);
    
    // Add glow effect
    final glowPaint = Paint()
      ..color = (isFromPlayer ? const Color(0xFF00FFFF) : const Color(0xFFFF5555))
          .withAlpha(0x30)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      size.x / 1.5,
      glowPaint,
    );
  }
}