import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';

class AssetLoader {
  static Future<void> loadAllAssets() async {
    // Load images
    await Flame.images.loadAll([
      'ship.png',
      'bullet.png',
      'alien.png',
      'explosion.png',
    ]);
    
    // Load audio
    await FlameAudio.audioCache.loadAll([
      'explosion.wav',
      'shoot.wav',
      'background.mp3',
    ]);
  }
  
  static Future<void> preloadAudio() async {
    // Preload audio for faster playback
    await FlameAudio.audioCache.load('explosion.wav');
    await FlameAudio.audioCache.load('shoot.wav');
    await FlameAudio.audioCache.load('background.mp3');
  }
}