import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class ExplosionParticle extends PositionComponent {
  
  ExplosionParticle({
    required Vector2 position,
    this.color = const Color(0xFFFFFF00),
    this.scaleFactor = 1.0,
  }) : super(
    position: position,
    size: Vector2(50, 50) * scaleFactor,
    priority: 10,
  );

  final Color color;
  final double scaleFactor;
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    final particleSystem = ParticleSystemComponent(
      position: Vector2.zero(),
      particle: Particle.generate(
        count: 25,
        generator: (index) {
          return AcceleratedParticle(
            acceleration: Vector2(0, 400),
            speed: Vector2(
              (Random().nextDouble() * 2 - 1) * 200 * scaleFactor,
              (Random().nextDouble() * 2 - 1.5) * 200 * scaleFactor,
            ),
            position: Vector2.zero(),
            child: CircleParticle(
              radius: 3 * scaleFactor,
              paint: Paint()..color = color,
            ),
            lifespan: 0.8,
          );
        },
      ),
    );
    
    add(particleSystem);
    
    // Remove after animation completes
    Future.delayed(const Duration(milliseconds: 800), () {
      removeFromParent();
    });
  }
}