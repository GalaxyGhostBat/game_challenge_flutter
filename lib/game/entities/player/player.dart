// ignore_for_file: sort_constructors_first

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import '../../space_invaders_game.dart';

class Player extends SpriteComponent 
    with HasGameReference<SpaceInvadersGame>, KeyboardHandler {
  double speed = 300;
  bool canShoot = true;
  double shootCooldown = 0.3;
  double timeSinceLastShot = 0;
  bool moveLeft = false;
  bool moveRight = false;
  
  Player({
    required super.position,
    required super.size,
  });
  
  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Load sprite from cache
    sprite = Sprite(game.images.fromCache('player.png'));
    anchor = Anchor.center;
    
    print('Player loaded at position: $position');
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Movement based on key states
    if (moveLeft) {
      position.x -= speed * dt;
    }
    if (moveRight) {
      position.x += speed * dt;
    }
    
    // Keep player within screen bounds
    position.x = position.x.clamp(size.x / 2, game.size.x - size.x / 2);
    
    // Update shoot cooldown
    if (!canShoot) {
      timeSinceLastShot += dt;
      if (timeSinceLastShot >= shootCooldown) {
        canShoot = true;
        timeSinceLastShot = 0;
      }
    }
  }
  
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // Update movement states
    moveLeft = keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    moveRight = keysPressed.contains(LogicalKeyboardKey.arrowRight);
    
    // Shooting
    if (keysPressed.contains(LogicalKeyboardKey.space) && canShoot) {
      shoot();
    }
    
    return true;
  }
  
  void shoot() {
    game.shootProjectile(
      Vector2(position.x, position.y - size.y / 2),
      false,
    );
    canShoot = false;
  }
}