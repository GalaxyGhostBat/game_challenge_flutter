// ignore_for_file: sort_constructors_first

import 'package:flame/components.dart';
import '../entities/projectile/projectile.dart';

class ProjectilePool extends Component {
  final List<Projectile> _pool = [];
  
  ProjectilePool();
  
  Projectile obtain({
    required Vector2 position,
    required Vector2 velocity,
    required bool isEnemy,
    required Vector2 size,
  }) {
    Projectile projectile;
    
    if (_pool.isEmpty) {
      projectile = Projectile(
        position: position,
        velocity: velocity,
        isEnemy: isEnemy,
        size: size,
      );
    } else {
      projectile = _pool.removeLast();
      projectile.position = position;
      projectile.velocity = velocity; 
    }
    
    return projectile;
  }
  
  void release(Projectile projectile) {
    if (!_pool.contains(projectile)) {
      _pool.add(projectile);
      projectile.removeFromParent();
    }
  }
}