import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/camera.dart';
import 'world/invaders_world.dart';
import 'bloc/game_bloc.dart';
import 'bloc/game_event.dart';
import 'effects/screen_shake_effect.dart';

class SpaceInvadersGame extends FlameGame with HasKeyboardHandlerComponents {
  SpaceInvadersGame({required this.gameBloc}) : super();

  final GameBloc gameBloc;
  late InvadersWorld invadersWorld;
  late ScreenShakeEffect screenShake;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Initialize world
    invadersWorld = InvadersWorld(gameBloc: gameBloc);
    add(invadersWorld);
    
    // Initialize screen shake effect
    screenShake = ScreenShakeEffect();
    add(screenShake);
    
    // Setup camera with fixed viewport
    camera.viewport = FixedResolutionViewport(resolution: Vector2(800, 600));
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Check win condition
    if (invadersWorld.enemies.isEmpty && !gameBloc.state.isGameOver) {
      gameBloc.add(const GameWon());
    }
  }

  void triggerScreenShake(double intensity) {
    screenShake.shake(intensity);
  }
}