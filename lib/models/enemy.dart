// import 'package:catch_touch/body_object.dart';
import 'package:trampoline/dino.dart';
import 'package:trampoline/square.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:trampoline/models/stage.dart';

import '/dino_run.dart';
import '/body_object.dart';
import '/models/enemy_data.dart';

class Enemy extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameReference<DinoRun> {
  final EnemyData enemyData;
  late final BodyComponent bodyComponent;
  bool isFloor = false;

  Enemy(this.enemyData) {
    animation = SpriteAnimation.fromFrameData(
      enemyData.image,
      SpriteAnimationData.sequenced(
        amount: enemyData.nFrames,
        stepTime: enemyData.stepTime,
        textureSize: enemyData.textureSize,
      ),
    );
    _createBody();
  }

  @override
  void onMount() {
    size *= 0.6;
    super.onMount();
  }

  @override
  void update(double dt) {
    if (bodyComponent.isLoaded) {
      position = bodyComponent.body.position;
    }
    if (position.x < -64) {
      removeFromParent();
    }

    super.update(dt);
  }

  void _createBody() {
    bodyComponent = EnemyBody(parentenemy: this, posi: position);
    add(bodyComponent);
  }
}

class EnemyBody extends BodyComponent with ContactCallbacks {
  final Enemy parentenemy; // enemyのインスタンスを保持
  final Vector2 posi;
  EnemyBody({required this.parentenemy, required this.posi}) {
    // opacity = 0.0;
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 16 / 2;
    final fixtureDef = FixtureDef(
      shape,
      restitution: 0.05, //反発係数 : 跳ねる
      density: 20.0, //密度
      friction: 0.1, //摩擦
      isSensor: parentenemy.enemyData.isSensor,
    );
    final bodyDef = BodyDef(
      userData: this,
      // linearVelocity: Vector2(0, 40),
      position: posi, // 初期位置を設定,
      linearDamping: 0, // 線形減衰 : 落下速度
      angularDamping: 0, // 角減衰の値を設定
      // gravityScale: Vector2(0, 10),
      type: parentenemy.enemyData.bodyType,
    );
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void onRemove() {
    // timer.stop();
    print('delete');
    super.onRemove();
  }

  @override
  void update(double dt) {
    if (!parentenemy.enemyData.canJump) {
      body.linearVelocity = Vector2(-parentenemy.enemyData.speedX, 0);
    } else if (parentenemy.isFloor) {
      body.linearVelocity = Vector2(0, -85);
    }
    super.update(dt);
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is MyEntity || other is Square || other is Ground) {
      parentenemy.isFloor = true;
    }
  }

  @override
  void endContact(Object other, Contact contact) {
    if (other is MyEntity || other is Ground || other is Square) {
      parentenemy.isFloor = false;
    }
  }
}
