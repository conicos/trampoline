import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_tiled/flame_tiled.dart';
import '/models/stage.dart';

class AddTiled extends TiledComponent {
  AddTiled(RenderableTiledMap map, this.ground, this.blockCount) : super(map);

  final Ground ground;
  final List<double> blockCount;

  @override
  void update(double dt) {
    super.update(dt);
    // anchor = Anchor.topcenter;
    position = Vector2(ground.body.position.x - blockCount[0] * 8,
        ground.body.position.y - 48);
  }
}
