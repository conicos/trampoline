import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:flame/palette.dart';
// import 'package:catch_touch/floor.dart';

class Square extends BodyComponent with ContactCallbacks {
  Square({
    required this.position,
    required this.size,
    required this.dragAngle,
    // required this.angle,
  }) : super(paint: BasicPalette.white.paint());

  final Vector2 size;
  final double dragAngle;
  Vector2 position;
  // final double angle;
  // final Dino dino; // Dinoの参照を保持

  @override
  Body createBody() {
    print("角度$dragAngle");
    final shape = PolygonShape()..setAsBoxXY(size.x / 2, size.y / 2);
    final fixtureDef = FixtureDef(
      shape,
      restitution: 0.05, //反発係数 : 跳ねる
      density: 120.0, //密度
      friction: 0.1, //摩擦
    );
    final bodyDef =
        BodyDef()
          ..userData = this
          ..type = BodyType.static
          ..position =
              position // 配置されるポジションは四角の中心点
          ..angle = dragAngle;
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  /// ドラッグで得た角度から「飛ばす方向」を決定するゲッター
  ///
  /// ここでは、ドラッグされた方向の反対 (dragAngle + π) を基本とし、
  /// もし水平（つまり y 成分がほぼ 0）なら (0, -1) を返すように補正します。
  Vector2 get flightDirection {
    // 反対方向の角度
    double oppositeAngle = dragAngle + pi;
    // 基本候補は反対方向
    Vector2 candidate = Vector2(cos(oppositeAngle), sin(oppositeAngle));
    // ドラッグベクトルがほぼ水平の場合（上下方向の成分が小さい場合）は、強制的に上向きにする
    if (candidate.y.abs() < 0.1) {
      candidate = Vector2(0, -1);
    }
    // 万が一、y 成分が下向きになってしまう場合は上向きに補正
    if (candidate.y > 0) {
      candidate.y = -candidate.y;
    }
    return candidate.normalized();
  }

  @override
  void update(double dt) {
    body.setTransform(position, dragAngle); // 位置と角度を更新します
    super.update(dt);
    // if (dino.isLoaded) {
    //   position.x = dino.bodyComponent.body.position.x * -1;
    // }
  }

  @override
  void beginContact(Object other, Contact contact) {}
}
