import 'player.dart';

abstract class PlayerState {
  void enter(Player player);
  void exit(Player player);
  void update(Player player, double dt);
  void takeHit(Player player);
  void shoot(Player player);
  void move(Player player, double direction);
}