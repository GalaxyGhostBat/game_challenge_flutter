import 'shooting_strategy.dart';

class TimedShotStrategy implements ShootingStrategy {
  
  TimedShotStrategy({required this.interval});
  
  final double interval;
  double _timeSinceLastShot = 0;
  
  @override
  bool shouldShoot() {
    _timeSinceLastShot += 1/60; // Assuming 60 FPS
    if (_timeSinceLastShot >= interval) {
      _timeSinceLastShot = 0;
      return true;
    }
    return false;
  }
  
  @override
  double getCooldown() {
    return interval;
  }
}