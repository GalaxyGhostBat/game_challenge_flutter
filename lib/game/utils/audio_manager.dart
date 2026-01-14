import 'package:flame_audio/flame_audio.dart';

class AudioManager {
  static bool isInitialized = false;
  
  static Future<void> initialize() async {
    if (isInitialized) return;
    
    try {
      // Load all audio files
      await FlameAudio.audioCache.loadAll([
        'explosion.wav',
        'shoot.wav',
        'background.mp3', 
      ]);
      
      isInitialized = true;
      print('AudioManager initialized successfully');
    } catch (e) {
      print('Error initializing AudioManager: $e');
    }
  }
  
  static void playShoot() {
    if (!isInitialized) return;
    try {
      FlameAudio.play('shoot.wav', volume: 0.5);
    } catch (e) {
      print('Error playing shoot sound: $e');
    }
  }
  
  static void playExplosion() {
    if (!isInitialized) return;
    try {
      FlameAudio.play('explosion.wav', volume: 0.7);
    } catch (e) {
      print('Error playing explosion sound: $e');
    }
  }
  
  static void playBackgroundMusic() {
    if (!isInitialized) return;
    try {
      print('AudioManager: playing background music');
      FlameAudio.bgm.stop();
      FlameAudio.bgm.play('background.mp3', volume: 0.3);
      print('AudioManager: background music play called');
    } catch (e) {
      print('Error playing background music: $e');
    }
  }
  
  static void stopBackgroundMusic() {
    try {
      print('AudioManager: stopping background music');
      FlameAudio.bgm.stop();
    } catch (e) {
      print('Error stopping background music: $e');
    }
  }
  
  static void pauseBackgroundMusic() {
    try {
      print('AudioManager: pausing background music');
      FlameAudio.bgm.pause();
    } catch (e) {
      print('Error pausing background music: $e');
    }
  }
  
  static void resumeBackgroundMusic() {
    try {
      print('AudioManager: resuming background music');
      FlameAudio.bgm.resume();
    } catch (e) {
      print('Error resuming background music: $e');
    }
  }
}