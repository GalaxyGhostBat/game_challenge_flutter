import 'shooting_strategy.dart';

class TimedShootingStrategy extends ShootingStrategy {
  
  TimedShootingStrategy(this.interval);
  
  final double interval;
  double timeSinceLastShot = 0;

  @override
  bool shouldShoot(double dt) {
    timeSinceLastShot += dt;
    if (timeSinceLastShot >= interval) {
      timeSinceLastShot = 0;
      return true;
    }
    return false;
  }
  
  @override
  void update(double dt) {
    // Update logic goes here if needed
  }
}