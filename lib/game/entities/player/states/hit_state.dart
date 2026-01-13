import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import '../player.dart';
import '../player_state.dart';
import 'alive_state.dart';

class HitState implements PlayerState {
  double _invincibilityTime = 2.0;
  
  @override
  void enter(Player player) {
    player.isInvincible = true;
    
    // Add blink effect
    player.add(
      OpacityEffect.fadeOut(
        EffectController(
          duration: 0.15,
          alternate: true,
          repeatCount: 8,
        ),
      ),
    );
  }

  @override
  void exit(Player player) {
    // Restore normal appearance
  }

  @override
  void update(Player player, double dt) {
    _invincibilityTime -= dt;
    if (_invincibilityTime <= 0) {
      player.setState(AliveState());
    }
  }

  @override
  void takeHit(Player player) {
    // No damage while invincible
  }

  @override
  void shoot(Player player) {
    // Can still shoot while invincible
    final projectile = player.world.projectilePool.acquire(
      position: player.position + Vector2(player.size.x / 2 - 4, -20),
      velocity: Vector2(0, -700),
      isFromPlayer: true,
    );
    player.world.add(projectile);
  }

  @override
  void move(Player player, double direction) {
    final newX = player.position.x + direction * player.speed * 1.2;
    player.position.x = newX.clamp(20, player.game.size.x - player.size.x - 20);
  }
}