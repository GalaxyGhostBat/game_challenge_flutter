import '../player.dart';
import '../player_state.dart';

class DeadState implements PlayerState {
  @override
  void enter(Player player) {
    player.isInvincible = true;
    // Note: Color filter approach may need adjustment for Flame 1.34.0
  }

  @override
  void exit(Player player) {
    // Cleanup
  }

  @override
  void update(Player player, double dt) {
    // Game over state - no updates
  }

  @override
  void takeHit(Player player) {
    // Already dead
  }

  @override
  void shoot(Player player) {
    // Cannot shoot when dead
  }

  @override
  void move(Player player, double direction) {
    // Cannot move when dead
  }
}