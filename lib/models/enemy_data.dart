import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

// This class stores all the data
// necessary for creation of an enemy.
class EnemyData {
  final Image image;
  final int nFrames;
  final double stepTime;
  final Vector2 textureSize;
  final double speedX;
  final bool canFly;
  final bool canJump;
  final bool isSensor;
  final BodyType bodyType;

  const EnemyData({
    required this.image,
    required this.nFrames,
    required this.stepTime,
    required this.textureSize,
    required this.speedX,
    required this.canFly,
    required this.canJump,
    required this.isSensor,
    required this.bodyType,
  });
}
