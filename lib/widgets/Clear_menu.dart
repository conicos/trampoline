import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/widgets/hud.dart';
import '/dino_run.dart';
import '/widgets/main_menu.dart';
import '/models/player_data.dart';
// import '/audio_manager.dart';

class ClearMenu extends StatelessWidget {
  static const id = 'ClearMenu';
  final DinoRun game;

  const ClearMenu(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: game.world.playerData,
      child: Center(
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.6,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Colors.black.withAlpha(20),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        color: Colors.lightGreen, // Card自体の色
                        elevation: 8, // 影の離れ具合
                        shadowColor: Colors.black, // 影の色
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Selector<PlayerData, int>(
                            selector: (_, playerData) => playerData.totalScore,
                            builder: (_, score, __) {
                              return Center(
                                  child: Text(
                                'You Score : $score',
                                style: const TextStyle(
                                    fontSize: 40, color: Colors.white),
                              ));
                            },
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: ElevatedButton(
                              child: const Text(
                                '次のステージへ',
                                style: TextStyle(
                                  fontSize: 30,
                                ),
                              ),
                              onPressed: () {
                                game.overlays.remove(ClearMenu.id);
                                // game.overlays.remove('life');
                                game.overlays.add(Hud.id);
                                game.resumeEngine();
                                game.world.reset();
                                game.world.addComponent();
                                // AudioManager.instance.resumeBgm();
                              },
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: ElevatedButton(
                              child: const Text(
                                'Exit',
                                style: TextStyle(
                                  fontSize: 30,
                                ),
                              ),
                              onPressed: () {
                                // game.exit();
                                game.overlays.remove(ClearMenu.id);
                                game.overlays.add(MainMenu.id);
                                game.overlays.add('life');
                                game.resumeEngine();
                                game.world.reset();
                                // AudioManager.instance.resumeBgm();
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
