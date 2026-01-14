import 'package:flame/flame.dart';
import 'package:flame/components.dart';

class ImageLoader {
  static late Sprite playerSprite;
  static late Sprite enemySprite1;
  static late Sprite enemySprite2;
  static late Sprite projectileSprite;
  static late Sprite explosionSprite;
  
  static bool isInitialized = false;
  
  static Future<void> loadAllImages() async {
    if (isInitialized) return;
    
    try {
      print('Loading images...');
      
      // Load player image
      final playerImage = await Flame.images.load('ship.png');
      playerSprite = Sprite(playerImage);
      print('✓ Loaded ship.png');
      
      // Load enemy images
      final enemyImage1 = await Flame.images.load('alien.png');
      enemySprite1 = Sprite(enemyImage1);
      print('✓ Loaded alien.png');
      
      final enemyImage2 = await Flame.images.load('alien.png');
      enemySprite2 = Sprite(enemyImage2);
      print('✓ Loaded alien.png');
      
      // Load projectile image
      final projectileImage = await Flame.images.load('bullet.png');
      projectileSprite = Sprite(projectileImage);
      print('✓ Loaded bullet.png');
      
      // Load explosion image
      final explosionImage = await Flame.images.load('explosion.png');
      explosionSprite = Sprite(explosionImage);
      print('✓ Loaded explosion.png');
      
      isInitialized = true;
      print('All images loaded successfully');
    } catch (e) {
      print('Error loading images: $e');
      rethrow;
    }
  }
}