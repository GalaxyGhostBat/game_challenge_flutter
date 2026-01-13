import 'shooting_strategy.dart';
import 'dart:math';

class RandomShotStrategy implements ShootingStrategy {

  RandomShotStrategy({
    this.probability = 0.01,
    this.minCooldown = 1.0,
    this.maxCooldown = 3.0,
  });
  
  final Random _random = Random();
  final double probability;
  final double minCooldown;
  final double maxCooldown;

  @override
  bool shouldShoot() {
    return _random.nextDouble() < probability;
  }
  
  @override
  double getCooldown() {
    return minCooldown + _random.nextDouble() * (maxCooldown - minCooldown);
  }
}