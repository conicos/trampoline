// import 'package:catch_touch/body_object.dart';
import 'package:trampoline/dino.dart';
import 'package:trampoline/square.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:trampoline/models/stage.dart';

import '/dino_run.dart';
import '/models/gimmic_data.dart';

class Gimmic extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameReference<DinoRun> {
  final GimmicData gimmicData;
  late final BodyComponent bodyComponent;
  bool isFloor = false;

  Gimmic(this.gimmicData) {
    animation = SpriteAnimation.fromFrameData(
      gimmicData.image,
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 1,
        textureSize: gimmicData.textureSize,
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
    bodyComponent = GimmicBody(parentgimmic: this, posi: position);
    add(bodyComponent);
  }
}

class GimmicBody extends BodyComponent with ContactCallbacks {
  final Gimmic parentgimmic; // gimmicのインスタンスを保持
  final Vector2 posi;
  GimmicBody({required this.parentgimmic, required this.posi}) {
    // opacity = 0.0;
  }

  @override
  Body createBody() {
    final shape =
        PolygonShape()..setAsBoxXY(
          parentgimmic.gimmicData.bodySize.x,
          parentgimmic.gimmicData.bodySize.y,
        );
    final fixtureDef = FixtureDef(
      shape,
      restitution: 0.05, //反発係数 : 跳ねる
      density: 20.0, //密度
      friction: 0.1, //摩擦
      isSensor: parentgimmic.gimmicData.isSensor,
    );
    final bodyDef = BodyDef(
      userData: this,
      // linearVelocity: Vector2(0, 40),
      position: posi, // 初期位置を設定,
      linearDamping: 0, // 線形減衰 : 落下速度
      angularDamping: 0, // 角減衰の値を設定
      // gravityScale: Vector2(0, 10),
      type: parentgimmic.gimmicData.bodyType,
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
    if (!parentgimmic.gimmicData.canJump) {
      body.linearVelocity = parentgimmic.gimmicData.linear;
    } else if (parentgimmic.isFloor) {
      body.linearVelocity = Vector2(0, -85);
    }
    super.update(dt);
  }

  @override
  void beginContact(Object other, Contact contact) {
    // if (other is Square || other is Ground) {
    //   parentgimmic.isFloor = true;
    // }
  }

  // @override
  // void endContact(Object other, Contact contact) {
  //   if (other is MyEntity || other is Ground) {
  //     parentgimmic.isFloor = false;
  //   }
  // }
}
