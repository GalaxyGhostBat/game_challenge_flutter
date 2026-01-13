// ignore_for_file: sort_constructors_first

import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../space_invaders_game.dart';

class Projectile extends SpriteComponent with HasGameReference<SpaceInvadersGame> {
  Vector2 velocity; // Changed from final so pool can modify it
  final bool isEnemy;
  
  Projectile({
    required super.position,
    required this.velocity,
    required this.isEnemy,
    required super.size,
  });
  
  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Load the projectile image
    sprite = Sprite(game.images.fromCache('ProjectileB_1.png'));
    anchor = Anchor.center;
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    position += velocity * dt;
    
    // Remove if out of bounds
    if (position.y < -size.y || position.y > (game.size.y) + size.y) {
      removeFromParent();
    }
  }
  
  @override
  void render(Canvas canvas) {
    // Change color based on owner
    final paint = Paint()
      ..colorFilter = ColorFilter.mode(
        isEnemy ? const Color(0xFFFF0000) : const Color(0xFF00FF00),
        BlendMode.srcATop,
      );
    
    canvas.save();
    canvas.drawRect(size.toRect(), paint);
    super.render(canvas);
    canvas.restore();
  }
}