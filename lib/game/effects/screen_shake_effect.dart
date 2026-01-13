import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';

// Custom Space Transformation: Screen Shake Effect
class ScreenShakeEffect extends Component {
  double _shakeIntensity = 0;
  double _shakeDuration = 0;
  final Random _random = Random();
  bool _isShaking = false;
  
  void shake(double intensity, {double duration = 0.5}) {
    if (!_isShaking || intensity > _shakeIntensity) {
      _shakeIntensity = intensity;
      _shakeDuration = duration;
      _isShaking = true;
    }
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    if (_isShaking && _shakeDuration > 0) {
      _shakeDuration -= dt;
      
      if (_shakeDuration <= 0) {
        _isShaking = false;
      }
    }
  }
  
  @override
  void render(Canvas canvas) {
    if (_isShaking) {
      final shakeX = (_random.nextDouble() * 2 - 1) * _shakeIntensity * 10;
      final shakeY = (_random.nextDouble() * 2 - 1) * _shakeIntensity * 10;
      
      canvas.save();
      canvas.translate(shakeX, shakeY);
      super.render(canvas);
      canvas.restore();
    } else {
      super.render(canvas);
    }
  }
}