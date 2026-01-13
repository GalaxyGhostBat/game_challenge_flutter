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
      final playerImage = await Flame.images.load('player.png');
      playerSprite = Sprite(playerImage);
      print('✓ Loaded player.png');
      
      // Load enemy images
      final enemyImage1 = await Flame.images.load('space__0002_B1.png');
      enemySprite1 = Sprite(enemyImage1);
      print('✓ Loaded space__0002_B1.png');
      
      final enemyImage2 = await Flame.images.load('space__0003_B2.png');
      enemySprite2 = Sprite(enemyImage2);
      print('✓ Loaded space__0003_B2.png');
      
      // Load projectile image
      final projectileImage = await Flame.images.load('ProjectileB_1.png');
      projectileSprite = Sprite(projectileImage);
      print('✓ Loaded ProjectileB_1.png');
      
      // Load explosion image
      final explosionImage = await Flame.images.load('space__0009_EnemyExplosion.png');
      explosionSprite = Sprite(explosionImage);
      print('✓ Loaded space__0009_EnemyExplosion.png');
      
      isInitialized = true;
      print('All images loaded successfully');
    } catch (e) {
      print('Error loading images: $e');
      rethrow;
    }
  }
}