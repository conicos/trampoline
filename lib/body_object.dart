import 'package:trampoline/square.dart';
import 'package:flame/extensions.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '/dino.dart';

class MyEntity extends BodyComponent with ContactCallbacks {
  MyEntity(this.blockCount, this.object) : super();

  final List<double> blockCount;
  final TiledObject object;

  @override
  Future<void> onLoad() async {
    super.onLoad();
  }

  @override
  Body createBody() {
    final shape = PolygonShape();
    shape.setAsBoxXY(object.width / 2, object.height / 2);
    final fixtureDef =
        FixtureDef(shape)
          ..friction = 0.3
          ..restitution =
              0.0 // これは反発係数です
          ..density = 1.0; // これは密度です
    final bodyDef =
        BodyDef()
          ..userData = this
          ..position = Vector2(
            object.x + 8 * blockCount[0],
            object.y + 8 * blockCount[1],
          ) // ここ？
          ..type = BodyType.static; // これはボディのタイプです
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
