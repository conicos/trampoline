import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import '/models/gimmic.dart';
import '/dino_run.dart';
import '/models/gimmic_data.dart';

class GimmicManager extends Component with HasGameReference<DinoRun> {
  final List<GimmicData> _data = [];
  final Random _random = Random();
  final Timer timer = Timer(2.5, repeat: true);

  GimmicManager() {
    timer.onTick = spawnRandomGimmic;
  }

  void spawnRandomGimmic() {
    final randomIndex = _random.nextInt(_data.length);
    final gimmicData = _data.elementAt(randomIndex);
    final gimmic = Gimmic(gimmicData);

    gimmic.anchor = Anchor.center;
    gimmic.position = Vector2(
      game.world.playerData.currentScore + game.virtualSize.x + 32,
      20,
    );

    if (gimmicData.canFly) {
      final newHeight = _random.nextDouble() * 5.5 * gimmicData.textureSize.y;
      gimmic.position.y = newHeight;
      print(newHeight);
    }
    if (gimmicData.isFall) {
      final newWidth = (_random.nextDouble() * 5 * gimmicData.textureSize.x) +
          game.world.playerData.currentScore +
          game.virtualSize.x / 2;
      gimmic.position.x = newWidth;
      print(newWidth);
    }

    gimmic.size = gimmicData.textureSize;
    game.world.add(gimmic);
    print('spawn');
  }

  @override
  void onLoad() {
    if (isMounted) {
      removeFromParent();
    }

    if (_data.isEmpty) {
      _data.addAll([
        GimmicData(
            image: game.images.fromCache('Gimmic/fire_red.png'),
            bodySize: Vector2(2, 1),
            linear: Vector2(-50, 0),
            textureSize: Vector2(16, 16),
            canFly: true,
            isFall: false,
            canJump: false,
            isSensor: false,
            bodyType: BodyType.dynamic),
        GimmicData(
            image: game.images.fromCache('Gimmic/fire_blue.png'),
            bodySize: Vector2(2, 1),
            linear: Vector2(-50, 0),
            textureSize: Vector2(16, 16),
            canFly: true,
            isFall: false,
            canJump: false,
            isSensor: false,
            bodyType: BodyType.kinematic),
        GimmicData(
            image: game.images.fromCache('Gimmic/weapon.png'),
            bodySize: Vector2(2, 1),
            linear: Vector2(-25, 25),
            textureSize: Vector2(16, 16),
            canFly: false,
            isFall: true,
            canJump: false,
            isSensor: false,
            bodyType: BodyType.kinematic),
      ]);
    }
    timer.start();
    super.onLoad();
  }

  @override
  void onRemove() {
    timer.stop();
    super.onRemove();
  }

  @override
  void update(double dt) {
    timer.update(dt);
    super.update(dt);
  }

  void removeAllEnemies() {
    final gimmics = game.world.children.whereType<Gimmic>();
    for (var gimmic in gimmics) {
      gimmic.removeFromParent();
    }
  }
}
