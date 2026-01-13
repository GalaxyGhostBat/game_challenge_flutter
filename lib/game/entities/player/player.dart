import 'package:flutter/services.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import '../../world/invaders_world.dart';
import 'player_state.dart';
import 'states/alive_state.dart';

class Player extends SpriteAnimationComponent
    with HasGameReference, KeyboardHandler {
  Player({
    required super.position,
    required this.world,
  }) : super(size: Vector2(48, 32)) {
    _currentState = AliveState();
  }

  final InvadersWorld world;
  late PlayerState _currentState;
  final double speed = 350;
  bool isInvincible = false;
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Load spritesheet animation
    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: await game.images.load('player_sheet.png'),
      columns: 3,
      rows: 1,
    );
    
    animation = spriteSheet.createAnimation(
      row: 0,
      from: 0,
      to: 2,
      stepTime: 0.15,
    );
    
  }
  
  void setState(PlayerState newState) {
    _currentState.exit(this);
    _currentState = newState;
    _currentState.enter(this);
  }
  
  void takeHit() {
    _currentState.takeHit(this);
  }
  
  void shoot() {
    _currentState.shoot(this);
  }
  
  void move(double direction) {
    _currentState.move(this, direction);
  }
  
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isLeft = keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRight = keysPressed.contains(LogicalKeyboardKey.arrowRight);
    
    if (isLeft && !isRight) {
      move(-1);
    } else if (isRight && !isLeft) {
      move(1);
    }
    
    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      shoot();
    }
    
    return true;
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    _currentState.update(this, dt);
  }
}