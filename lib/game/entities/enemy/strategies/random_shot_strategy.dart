// ignore_for_file: sort_constructors_first

import 'dart:math';
import 'shooting_strategy.dart';

class RandomShotStrategy extends ShootingStrategy {
  final Random random = Random();
  final double chancePerSecond;
  
  RandomShotStrategy(this.chancePerSecond);
  
  @override
  bool shouldShoot(double dt) {
    return random.nextDouble() < chancePerSecond * dt;
  }
  
  @override
  void update(double dt) {}
}