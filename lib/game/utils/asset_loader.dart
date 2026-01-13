import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';

class AssetLoader {
  static Future<void> loadAllAssets() async {
    // Load images
    await Flame.images.loadAll([
      'player.png',
      'ProjectileB_1.png',
      'space__0002_B1.png',
      'space__0003_B2.png',
      'space__0009_EnemyExplosion.png',
    ]);
    
    // Load audio
    await FlameAudio.audioCache.loadAll([
      'explosion.wav',
      'shoot.wav',
      'spaceinvaders1.mpeg',
    ]);
  }
  
  static Future<void> preloadAudio() async {
    // Preload audio for faster playback
    await FlameAudio.audioCache.load('explosion.wav');
    await FlameAudio.audioCache.load('shoot.wav');
    await FlameAudio.audioCache.load('spaceinvaders1.mpeg');
  }
}