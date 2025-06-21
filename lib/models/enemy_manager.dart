import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import '/models/enemy.dart';
import '/dino_run.dart';
import '/models/enemy_data.dart';

class EnemyManager extends Component with HasGameReference<DinoRun> {
  final List<EnemyData> _data = [];
  final Random _random = Random();
  final Timer timer = Timer(5, repeat: true);

  EnemyManager() {
    timer.onTick = spawnRandomEnemy;
  }

  void spawnRandomEnemy() {
    final randomIndex = _random.nextInt(_data.length);
    final enemyData = _data.elementAt(0);
    final enemy = Enemy(enemyData);

    enemy.anchor = Anchor.center;
    enemy.position = Vector2(
      game.world.playerData.currentScore + game.virtualSize.x + 32,
      20,
    );

    if (enemyData.canFly) {
      final newHeight = _random.nextDouble() * 5.5 * enemyData.textureSize.y;
      enemy.position.y = newHeight;
      print(newHeight);
    }

    enemy.size = enemyData.textureSize;
    game.world.add(enemy);
    print('spawn');
  }

  void addDuckee(Vector2 position) {
    print(_data.last);
    if (_data.length <= 1) return; // リストの長さをチェック
    final enemyData = _data[1];
    final enemy = Enemy(enemyData);

    enemy.anchor = Anchor.center;
    enemy.position = position;

    // if (enemyData.canFly) {
    //   final newHeight = _random.nextDouble() * 4 * enemyData.textureSize.y;
    //   enemy.position.y -= newHeight;
    // }

    enemy.size = enemyData.textureSize;
    game.world.add(enemy);
    print('spawn');
  }

  @override
  void onLoad() {
    if (isMounted) {
      removeFromParent();
    }

    if (_data.isEmpty) {
      _data.addAll([
        // EnemyData(
        //   image: game.images.fromCache('AngryPig/Walk (36x30).png'),
        //   nFrames: 16,
        //   stepTime: 0.1,
        //   textureSize: Vector2(36, 30),
        //   speedX: 80,
        //   canFly: false,
        // ),
        EnemyData(
            image: game.images.fromCache('Bat/Flying (46x30).png'),
            nFrames: 7,
            stepTime: 0.5,
            textureSize: Vector2(46, 30),
            speedX: 50,
            canFly: true,
            canJump: false,
            isSensor: true,
            bodyType: BodyType.dynamic),
        EnemyData(
            image: game.images.fromCache('duckee/run.png'),
            nFrames: 4,
            stepTime: 0.09,
            textureSize: Vector2(64, 64),
            speedX: 0,
            canFly: false,
            canJump: true,
            isSensor: false,
            bodyType: BodyType.dynamic),
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
    final enemies = game.world.children.whereType<Enemy>();
    for (var enemy in enemies) {
      enemy.removeFromParent();
    }
  }
}
