import 'dart:math';
import 'dart:ui';

import 'package:trampoline/model.dart';
import 'package:trampoline/models/enemy.dart';
import 'package:trampoline/models/gimmic.dart';
import 'package:trampoline/square.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
// import 'package:flame_tiled/flame_tiled.dart';

// import '/game/enemy.dart';
import 'dino_run.dart';
import '/models/audio_manager.dart';
import '/models/player_data.dart';
import '/widgets/hud.dart';
import '/widgets/game_over_menu.dart';

enum DinoAnimationStates { idle, run, kick, hit, sprint }

class Dino extends SpriteAnimationGroupComponent<DinoAnimationStates>
    with HasGameReference<DinoRun>, TapCallbacks {
  Dino(Image image, this.playerData, this.gameModel)
    : super.fromFrameData(image, _animationMap) {
    _createBody();
  }

  static final _animationMap = {
    DinoAnimationStates.idle: SpriteAnimationData.sequenced(
      amount: 4,
      stepTime: 0.1,
      textureSize: Vector2.all(16),
    ),
    DinoAnimationStates.run: SpriteAnimationData.sequenced(
      amount: 6,
      stepTime: 0.1,
      textureSize: Vector2.all(24),
      texturePosition: Vector2((4) * 24, 0),
    ),
    DinoAnimationStates.kick: SpriteAnimationData.sequenced(
      amount: 4,
      stepTime: 0.1,
      textureSize: Vector2.all(24),
      texturePosition: Vector2((4 + 6) * 24, 0),
    ),
    DinoAnimationStates.hit: SpriteAnimationData.sequenced(
      amount: 3,
      stepTime: 0.1,
      textureSize: Vector2.all(24),
      texturePosition: Vector2((4 + 6 + 4) * 24, 0),
    ),
    DinoAnimationStates.sprint: SpriteAnimationData.sequenced(
      amount: 7,
      stepTime: 0.1,
      textureSize: Vector2.all(24),
      texturePosition: Vector2((4 + 6 + 4 + 3) * 24, 0),
    ),
  };

  late final BodyComponent bodyComponent;
  final PlayerData playerData;
  final GameModel gameModel;
  // final DinoRun game;
  bool isFloor = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();
  }

  @override
  void onMount() {
    _reset();
    super.onMount();
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    bodyComponent.body.linearVelocity = Vector2(0, -50);
  }

  @override
  void update(double dt) {
    if (bodyComponent.isLoaded) {
      position = bodyComponent.body.position;
    }
    super.update(dt);
  }

  void _createBody() {
    bodyComponent = DinoBody(parentdino: this, posi: position, speed: 40);
    add(bodyComponent);
  }

  void _reset() {
    if (isMounted) {
      removeFromParent();
    }
    anchor = Anchor.center;
    position = Vector2(32, 128);
    size = Vector2.all(16);
    current = DinoAnimationStates.run;
  }
}

class DinoBody extends BodyComponent with ContactCallbacks {
  DinoBody({
    required this.parentdino,
    required this.posi,
    required this.speed,
  }) {
    opacity = 0.0;
  }
  final Dino parentdino; // dinoのインスタンスを保持
  final Vector2 posi;
  double speed;
  // bool isFloor = false;
  bool isSquare = false;

  @override
  Body createBody() {
    final shape =
        PolygonShape()
          ..setAsBoxXY(parentdino.size.x / 3, parentdino.size.y / 3);
    final fixtureDef = FixtureDef(
      shape,
      restitution: 0.05, //反発係数 : 跳ねる
      density: 20.0, //密度
      friction: 0.1, //摩擦
    );
    final bodyDef = BodyDef(
      userData: this,
      position: posi, // 初期位置を設定,
      linearDamping: 0.001, // 線形減衰 : 落下速度
      angularDamping: 0.3, // 角減衰の値を設定
      type: BodyType.dynamic,
      gravityScale: Vector2(1, 1),
    );
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  void gameOver() {
    game.overlays.add(GameOverMenu.id);
    game.overlays.remove(Hud.id);
    game.pauseEngine();
    // AudioManager.instance.pauseBgm();
  }

  @override
  void update(double dt) {
    parentdino.playerData.currentScore = (body.position.x - 32).toInt();
    camera.viewfinder.position = Vector2(
      position.x + 150,
      camera.viewport.virtualSize.y * 0.5,
    );
    // body.linearVelocity.x = 15;
    if (isSquare) {
      // body.linearVelocity = Vector2(0, 0);
    }
    if (parentdino.isFloor) {
      body.gravityScale = Vector2(0, 0.5);
    } else {
      body.gravityScale = Vector2(0, 0.5);
    }
    super.update(dt);
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Square) {
      // Square に接触したら、Square の dragAngle に沿った方向へインパルスを与える
      const impulseMagnitude = 100.0;
      // // ドラッグで得た角度に基づく単位ベクトルを作成
      // final impulseDirection = Vector2(
      //   cos(other.dragAngle),
      //   sin(other.dragAngle),
      // );
      // Square 側で算出した flightDirection を使用して、インパルスベクトルを決定
      final impulse =
          other.flightDirection *
          impulseMagnitude; // body.applyLinearImpulse(impulse);
      parentdino.isFloor = true;
      print("Dino に impulse: ${other.dragAngle} を与えました");
      body.linearVelocity = (impulse);
      // final angle = other.body.angle * 180 / pi;
      // parentdino.gameModel.isGround = true;
      parentdino.isFloor = true;
    }
    if (other is GimmicBody || other is EnemyBody) {
      print('contact');
      gameOver();
    }
  }

  @override
  void endContact(Object other, Contact contact) {
    // if (other is Square || other is MyEntity || other is Ground) {
    //   parentdino.gameModel.isGround = false;
    // }
  }
}
