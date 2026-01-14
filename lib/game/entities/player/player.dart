// ignore_for_file: sort_constructors_first

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import '../../space_invaders_game.dart';

class Player extends SpriteComponent
    with HasGameReference<SpaceInvadersGame>, KeyboardHandler {
  // Movement
  final double speed = 300;

  // Shooting
  bool canShoot = true;
  final double shootCooldown = 0.3;
  double timeSinceLastShot = 0;

  // Input state
  bool moveLeft = false;
  bool moveRight = false;

  Player({
    required super.position,
    required super.size,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = Sprite(game.images.fromCache('ship.png'));
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Movement
    if (moveLeft) {
      position.x -= speed * dt;
    }
    if (moveRight) {
      position.x += speed * dt;
    }

    // Keep player inside screen
    position.x = position.x.clamp(
      size.x / 2,
      game.size.x - size.x / 2,
    );

    // Shooting cooldown
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
    moveLeft = keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    moveRight = keysPressed.contains(LogicalKeyboardKey.arrowRight);

    // Shoot only on key DOWN (not while holding)
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.space &&
        canShoot) {
      shoot();
    }

    return false;
  }

  void shoot() {
    game.shootProjectile(
      Vector2(position.x, position.y - size.y / 2),
      false,
    );
    canShoot = false;
  }
}
