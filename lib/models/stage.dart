import 'dart:math';

import 'package:trampoline/models/player_data.dart';
import 'package:flame/components.dart';
import 'package:trampoline/square.dart';
import 'package:flame/events.dart';
import 'package:flame/palette.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:trampoline/dino.dart';
import 'package:flame_tiled/flame_tiled.dart';
import '/widgets/game_over_menu.dart';
// import '/audio_manager.dart';

class Floor extends BodyComponent with ContactCallbacks {
  Floor({required this.pos, required this.size}) : super();

  final Vector2 pos;
  final Vector2 size;

  @override
  Body createBody() {
    final shape =
        PolygonShape()..setAsBox(size.x, size.y, Vector2(pos.x, pos.y + 16), 0);
    final fixtureDef = FixtureDef(shape, friction: 0.3);
    final bodyDef = BodyDef(userData: this);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is DinoBody) {
      // game.overlays.add(GameOverMenu.id);
      // game.overlays.remove(Hud.id);
      game.pauseEngine();
      // AudioManager.instance.pauseBgm();
    }
  }
}

class Ceiling extends BodyComponent with ContactCallbacks {
  Ceiling({required this.pos, required this.size}) : super();

  final Vector2 pos;
  final Vector2 size;

  @override
  Body createBody() {
    final shape =
        PolygonShape()..setAsBox(size.x, size.y, Vector2(pos.x, pos.y), 0);
    final fixtureDef = FixtureDef(shape, friction: 0.3);
    final bodyDef = BodyDef(userData: this);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class TestGround extends BodyComponent with ContactCallbacks {
  TestGround({required this.pos, required this.size}) : super();

  final Vector2 pos;
  final Vector2 size;

  @override
  Body createBody() {
    final shape =
        PolygonShape()..setAsBox(size.x, size.y, Vector2(pos.x, 180), 0);
    final fixtureDef = FixtureDef(shape, friction: 0.3);
    final bodyDef = BodyDef(userData: this);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class Goal extends BodyComponent with ContactCallbacks {
  Goal({required this.pos, required this.size, required this.playerData})
    : super();

  final Vector2 pos;
  final Vector2 size;
  final PlayerData playerData;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(
      SpriteComponent(
        sprite: Sprite(game.images.fromCache('goal.png')),
        size: Vector2(18, 18),
        // scale: Vector2(4, 4),
        anchor: Anchor.bottomCenter,
      ),
    );
  }

  @override
  Body createBody() {
    final shape =
        PolygonShape()..setAsBox(size.x, size.y, Vector2(pos.x, pos.y), 0);
    final fixtureDef = FixtureDef(shape, friction: 0.3);
    final bodyDef = BodyDef(userData: this);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void beginContact(Object other, Contact contact) {
    print(other);
    if (other is DinoBody) {
      playerData.clear = 1000;
      game.pauseEngine();
      // game.overlays.add(ClearMenu.id);
      // game.overlays.remove(Hud.id);
      // AudioManager.instance.pauseBgm();
    }
  }
}

class Ground extends BodyComponent {
  Ground(this.object, this.blockCount) {}

  double move = 10;
  bool isExtended = false;
  int count = 0;
  final TiledObject object;
  final List<double> blockCount;

  @override
  void onMount() {
    // print(object.size.x);
    // print(object.size.y);
    // print(object.x);
    // print(object.y);
    // print(object.y + 8 * (blockCount[1] + 1));
    if (isMounted) {
      removeFromParent();
    }
    // timer.start();
    super.onMount();
  }

  @override
  Body createBody() {
    final shape = PolygonShape();
    shape.setAsBoxXY(object.size.x / 2, object.size.y / 2);
    final fixtureDef =
        FixtureDef(shape)
          ..friction = 0.3
          ..restitution = 0.0
          ..density = 1.0;
    final bodyDef =
        BodyDef()
          ..userData = this
          ..position = Vector2(
            object.x + 8 * blockCount[0],
            object.y + 8 * (blockCount[1] + 1),
          )
          ..type = BodyType.kinematic;
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void onRemove() {
    // timer.stop();
    print('stop');
    super.onRemove();
  }

  @override
  void update(double dt) {
    if (body.position.y <= object.y + 8 * (blockCount[1] + 1)) {
      move = 10;
    } else if (body.position.y >= 202.5) {
      move = -10;
    }
    moveGround();
    // timer.update(dt);
    super.update(dt);
  }

  void moveGround() {
    body.linearVelocity = Vector2(0, move);
    // print(body.position);
  }
}
