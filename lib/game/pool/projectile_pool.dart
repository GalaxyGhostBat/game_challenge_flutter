// Object Pool Pattern Implementation
import 'dart:math';
import 'package:flame/components.dart';
import '../entities/projectile/projectile.dart';
import '../world/invaders_world.dart';

class ProjectilePool {

  ProjectilePool({int maxSize = 100}) : _maxSize = maxSize;

  final List<Projectile> _pool = [];
  final int _maxSize;
  late InvadersWorld _world;
  
  void initialize(InvadersWorld world) {
    _world = world;
  }
  
  Projectile acquire({
    required Vector2 position,
    required Vector2 velocity,
    required bool isFromPlayer,
  }) {
    // Try to find an inactive projectile
    for (final projectile in _pool) {
      if (!projectile.isActive) {
        projectile.reset(position: position, velocity: velocity);
        projectile.isFromPlayer = isFromPlayer;
        projectile.isActive = true;
        return projectile;
      }
    }
    
    // Create new projectile if pool not full
    if (_pool.length < _maxSize) {
      final projectile = Projectile(
        position: position,
        velocity: velocity,
        isFromPlayer: isFromPlayer,
        world: _world,
      );
      _pool.add(projectile);
      return projectile;
    }
    
    // Reuse random projectile if pool is full
    final random = Random();
    final projectile = _pool[random.nextInt(_pool.length)];
    projectile.reset(position: position, velocity: velocity);
    projectile.isFromPlayer = isFromPlayer;
    projectile.isActive = true;
    return projectile;
  }
  
  void release(Projectile projectile) {
    projectile.isActive = false;
    projectile.removeFromParent();
  }
}