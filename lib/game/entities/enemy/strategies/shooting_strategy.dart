// Strategy Pattern Interface
abstract class ShootingStrategy {
  bool shouldShoot();
  double getCooldown();
}