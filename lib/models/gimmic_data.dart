import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

// This class stores all the data
// necessary for creation of an Gimmic.
class GimmicData {
  final Image image;
  final Vector2 bodySize;
  final Vector2 linear;
  final Vector2 textureSize;
  final bool canFly;
  final bool isFall;
  final bool canJump;
  final bool isSensor;
  final BodyType bodyType;

  const GimmicData({
    required this.image,
    required this.bodySize,
    required this.linear,
    required this.textureSize,
    required this.canFly,
    required this.isFall,
    required this.canJump,
    required this.isSensor,
    required this.bodyType,
  });
}
