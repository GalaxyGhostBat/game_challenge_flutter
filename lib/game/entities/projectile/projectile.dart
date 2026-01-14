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
    sprite = Sprite(game.images.fromCache('bullet.png'));
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
    // Tint the sprite based on owner by compositing a layer with a color filter.
    final paint = Paint()
      ..colorFilter = ColorFilter.mode(
        isEnemy ? const Color(0xFFFF0000) : const Color(0xFF00FF00),
        BlendMode.srcATop,
      );

    // Create a layer using the paint so the sprite rendered by super.render
    // is tinted when the layer is composited back to the canvas.
    canvas.saveLayer(size.toRect(), paint);
    super.render(canvas);
    canvas.restore();
  }
}