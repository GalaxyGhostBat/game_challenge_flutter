import 'package:flame/components.dart';
import '../player.dart';
import '../player_state.dart';
import 'hit_state.dart';

class AliveState implements PlayerState {
  @override
  void enter(Player player) {
    // Reset to normal appearance
    player.isInvincible = false;
    player.priority = 1;
  }

  @override
  void exit(Player player) {
    // Cleanup if needed
  }

  @override
  void update(Player player, double dt) {
    // Normal state updates
  }

  @override
  void takeHit(Player player) {
    player.world.playerHit();
    player.setState(HitState());
  }

  @override
  void shoot(Player player) {
    final projectile = player.world.projectilePool.acquire(
      position: player.position + Vector2(player.size.x / 2 - 4, -20),
      velocity: Vector2(0, -600),
      isFromPlayer: true,
    );
    player.world.add(projectile);
  }

  @override
  void move(Player player, double direction) {
    final newX = player.position.x + direction * player.speed;
    player.position.x = newX.clamp(20, player.game.size.x - player.size.x - 20);
  }
}