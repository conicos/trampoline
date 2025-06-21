import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'dino_world.dart';
import 'package:flame/parallax.dart';

import 'model.dart';

class DinoRun extends Forge2DGame<DinoWorld> with HasCollisionDetection {
  DinoRun({required this.gameModel})
      : super(
            zoom: 1,
            gravity: Vector2(0, 100.0),
            world: DinoWorld(gameModel: gameModel),
            camera:
                CameraComponent.withFixedResolution(width: 341, height: 192));

  static const _imageAssets = [
    'Dino/DinoSprites - tard.png',
    'AngryPig/Walk (36x30).png',
    'Bat/Flying (46x30).png',
    'duckee/run.png',
    'Rino/Run (52x34).png',
    'Gimmic/fire_red.png',
    'Gimmic/fire_blue.png',
    'Gimmic/weapon.png',
    'parallax/plx-1.png',
    'parallax/plx-2.png',
    'parallax/plx-3.png',
    'parallax/plx-4.png',
    'parallax/plx-5.png',
    'parallax/plx-6.png',
    'attack.png',
    'goal.png',
  ];

  Vector2 get virtualSize => camera.viewport.virtualSize; // [360.0,202.5]
  final GameModel gameModel;
  late Parallax parallax;

  @override
  Future<void> onLoad() async {
    debugMode = true;

    await Flame.device.fullScreen();
    await Flame.device.setLandscape();
    await add(
      FpsTextComponent(),
    );
    debugMode = true;
    await images.loadAll(_imageAssets);
    camera.viewfinder.position =
        camera.viewport.virtualSize * 0.5; // カメラをビューポートの中心に表示
    final parallaxBackground = await loadParallaxComponent(
      [ParallaxImageData('parallax/all.png')],
      baseVelocity: Vector2(1, 0), // parallax のスピード設定
      velocityMultiplierDelta: Vector2(1.4, 0),
    );
    parallax = parallaxBackground.parallax!; // 速度変更用インスタンス
    camera.backdrop.add(parallaxBackground);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        resumeEngine();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        pauseEngine();
        break;
    }
    super.lifecycleStateChange(state);
  }
}
