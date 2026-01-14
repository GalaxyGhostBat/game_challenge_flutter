// ignore_for_file: sort_constructors_first

import 'package:flame/components.dart';
import '../../space_invaders_game.dart';
import 'strategies/shooting_strategy.dart';

class Invader extends SpriteAnimationComponent with HasGameReference<SpaceInvadersGame> {
  final ShootingStrategy shootingStrategy;

  Invader({
    required super.position,
    required super.size,
    required this.shootingStrategy,
  }) : super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final img1 = game.images.fromCache('alien.png');
    final img2 = game.images.fromCache('alien_2.png');

    final sprite1 = Sprite(img1);
    final sprite2 = Sprite(img2);

    animation = SpriteAnimation.spriteList(
      [sprite1, sprite2],
      stepTime: 0.5,
      loop: true,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Shooting logic only
    shootingStrategy.update(dt);

    // Only shoot if this invader is the bottom in its column
    if (_isBottomInvader() && shootingStrategy.shouldShoot(dt)) {
      shoot();
    }
  }

  bool _isBottomInvader() {
    return !game.invaders.any((other) =>
        other != this &&
        (other.position.x - position.x).abs() < size.x * 0.5 &&
        other.position.y > position.y);
  }

  void shoot() {
    game.shootProjectile(
      Vector2(position.x, position.y + size.y / 2),
      true,
    );
  }
}
