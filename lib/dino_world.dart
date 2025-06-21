import 'dart:math';
import 'package:trampoline/models/gimmic_manager.dart';
import 'package:trampoline/models/enemy_manager.dart';
import 'package:flame/extensions.dart';

import 'package:trampoline/square.dart';
import 'package:flame/events.dart';
import 'package:flame/components.dart';
import 'package:hive/hive.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'model.dart';
import 'dino.dart';
import 'body_object.dart';
import 'add_tiled.dart';
import '/models/player_data.dart';
import '/models/settings.dart';
import '/models/stage.dart';
import '/models/audio_manager.dart';

class DinoWorld extends Forge2DWorld
    with DragCallbacks, DoubleTapCallbacks, HasGameReference {
  DinoWorld({required this.gameModel});
  final GameModel gameModel;
  bool spawn = false;
  Vector2 position = Vector2(0, 0);
  final double spawnRange = 3; // 指定した距離
  double defaultTileSize = 16;
  double tiledComponentWidth = 50;
  double tiledComponentHeight = 12;

  List<Square> cubes = [];
  List<BodyComponent> objectLayers = [];
  List<TiledComponent> tiledComponents = [];
  List<BodyComponent> moveObjects = [];
  Vector2 point1 = Vector2(0, 0);
  Vector2 point2 = Vector2(0, 0);

  late PlayerData playerData;
  late Settings settings;
  late Dino dino;
  late Floor floor;
  late Ceiling ceiling;
  late Ground ground;
  late EnemyManager enemyManager;
  late GimmicManager gimmicManager;
  late TiledComponent tiledComponent;

  static const _audioAssets = [
    '8BitPlatformerLoop.wav',
    'hurt7.wav',
    'jump14.wav',
  ];

  final List<String> _stageAssets = ['01_stage.tmx'];

  @override
  Future<void> onLoad() async {
    playerData = await _readPlayerData();
    settings = await _readSettings();
    // await AudioManager.instance.init(_audioAssets, settings);
    // AudioManager.instance.startBgm('8BitPlatformerLoop.wav');

    // startGamePlay();
  }

  @override
  void onMount() {
    playerData.highScore = 0;
    enemyManager = EnemyManager();
    enemyManager.priority = 1;

    super.onMount();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void onRemove() {}

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    // 指の移動量
    point2 = event.localPosition;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    point1 = event.localEndPosition;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    double angle = Vector2(1, 0).angleToSigned(point2 - point1) * 180 / pi;
    double stroke = point1.distanceTo(point2);
    if (angle < 0) {
      angle += 2 * pi;
    }
    if (stroke < 0) {
      stroke = stroke * -1;
    }
    final cube = Square(
      position: (point1 + point2) / 2,
      size: Vector2(stroke, 1),
      dragAngle: radians(angle),
      // dino: _dino
    );
    add(cube);
    cubes.add(cube);
    if (cubes.length == 5) {
      cubes.first.removeFromParent();
      cubes.removeAt(0);
    }
  }

  @override
  void onDoubleTapDown(DoubleTapDownEvent event) {}

  void addComponent() async {
    final rect = game.camera.visibleWorldRect;
    dino = Dino(
      game.images.fromCache('Dino/DinoSprites - tard.png'),
      playerData,
      gameModel,
    );
    floor = Floor(pos: rect.bottomLeft.toVector2(), size: Vector2(1000, 1));
    ceiling = Ceiling(pos: rect.topLeft.toVector2(), size: Vector2(1000, 1));
    selectStage();
    gimmicManager = GimmicManager();
    addAll([dino, floor, ceiling, gimmicManager, enemyManager]);
  }

  Future<void> addTiled() async {
    tiledComponent = await TiledComponent.load(
      _stageAssets[0],
      Vector2(16, 16),
    );
    // 地面の BodyComponent を追加
    final objectLayer1 = tiledComponent.tileMap.getLayer<ObjectGroup>(
      'オブジェクトレイヤー1',
    );
    if (objectLayer1 != null) {
      for (final object in objectLayer1.objects) {
        final blockCount = [
          object.size.x / defaultTileSize,
          object.size.y / defaultTileSize,
        ];
        final bodyComponent = MyEntity(blockCount, object);
        await add(bodyComponent);
        objectLayers.add(bodyComponent);
      }
    }
    // 動く Bodycomponent を追加
    final moveObject1 = tiledComponent.tileMap.getLayer<ObjectGroup>(
      'moveObject1',
    );
    if (moveObject1 != null) {
      for (final object in moveObject1.objects) {
        // print(object.properties['picture']?.value ?? 'null');
        final picture = object.properties['picture']?.value ?? 'null';
        final blockCount = [
          object.size.x / defaultTileSize,
          object.size.y / defaultTileSize,
        ];
        if (object.y == 0) {
          blockCount[1] = blockCount[1] - 1;
        }
        ground = Ground(object, blockCount);
        await add(ground);
        moveObjects.add(ground);
        await addMoveObjects(picture, blockCount);
      }
    }
    add(tiledComponent);
    tiledComponents.add(tiledComponent);
  }

  Future<void> addMoveObjects(Object picture, List<double> blockCount) async {
    final map = await RenderableTiledMap.fromFile(
      picture.toString(),
      Vector2(16, 16),
    );
    final tiledComponent = AddTiled(map, ground, blockCount);
    add(tiledComponent);
    tiledComponents.add(tiledComponent);
  }

  void selectStage() async {
    _stageAssets.shuffle();
    await addTiled(); // Tiled を追加
    await addEnemy();
  }

  Future<void> addEnemy() async {
    final enemyObject = tiledComponent.tileMap.getLayer<ObjectGroup>(
      'エネミーオブジェクト1',
    );
    if (enemyObject != null) {
      for (final object in enemyObject.objects) {
        enemyManager.addDuckee(object.position); // addするとrangeエラーが起こる
      }
    }
    // 動く Bodycomponent を追加
  }

  void startGamePlay() async {
    defaultScore();
    addComponent();
  }

  void reset() {
    _disconnectActors();
    playerData.currentScore = 0;
    playerData.attack = 5;
    // playerData.totalScore = 0;
  }

  void allReset() {
    _disconnectActors();
    defaultScore();
  }

  void _disconnectActors() {
    dino.removeFromParent();
    floor.removeFromParent();
    ceiling.removeFromParent();
    for (var cube in cubes) {
      cube.removeFromParent();
    }
    for (var bodycomponent in objectLayers) {
      bodycomponent.removeFromParent();
    }
    gimmicManager.removeAllEnemies();
    gimmicManager.removeFromParent();
    enemyManager.removeAllEnemies();
    enemyManager.removeFromParent();
  }

  void defaultScore() {
    playerData.currentScore = 0;
    playerData.totalScore = 0;
    playerData.attack = 5;
  }

  Future<PlayerData> _readPlayerData() async {
    final playerDataBox = await Hive.openBox<PlayerData>(
      'DinoRun.PlayerDataBox',
    );
    final playerData = playerDataBox.get('DinoRun.PlayerData');
    if (playerData == null) {
      await playerDataBox.put('DinoRun.PlayerData', PlayerData());
    }
    return playerDataBox.get('DinoRun.PlayerData')!;
  }

  Future<Settings> _readSettings() async {
    final settingsBox = await Hive.openBox<Settings>('DinoRun.SettingsBox');
    final settings = settingsBox.get('DinoRun.Settings');
    if (settings == null) {
      await settingsBox.put('DinoRun.Settings', Settings(bgm: true, sfx: true));
    }
    return settingsBox.get('DinoRun.Settings')!;
  }
}
