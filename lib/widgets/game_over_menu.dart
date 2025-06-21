import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/dino_run.dart';
import '/models/player_data.dart';
import '/widgets/hud.dart';
import '/widgets/main_menu.dart';

import '/models/audio_manager.dart';

class GameOverMenu extends StatelessWidget {
  static const id = 'GameOverMenu';
  final DinoRun game;

  const GameOverMenu(this.game, {super.key});

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
                            selector: (_, playerData) => playerData.score,
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
                                'Restart',
                                style: TextStyle(
                                  fontSize: 30,
                                ),
                              ),
                              onPressed: () {
                                game.overlays.remove(GameOverMenu.id);
                                game.overlays.remove('life');
                                game.overlays.add(Hud.id);
                                game.resumeEngine();
                                game.world.allReset();
                                game.world.startGamePlay();
                                AudioManager.instance.resumeBgm();
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
                                game.overlays.remove(GameOverMenu.id);
                                game.overlays.add(MainMenu.id);
                                game.overlays.add('life');
                                game.resumeEngine();
                                game.world.allReset();
                                AudioManager.instance.resumeBgm();
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
            //     Card(
            //   shape:
            //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            //   color: Colors.black.withAlpha(100),
            //   child: FittedBox(
            //     fit: BoxFit.scaleDown,
            //     child: Padding(
            //       padding:
            //           const EdgeInsets.symmetric(vertical: 20, horizontal: 100),
            //       child: Column(
            //         // direction: Axis.vertical,
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         // spacing: 10,
            //         children: [
            //           Card(
            //             color: Colors.green, // Card自体の色
            //             margin: const EdgeInsets.all(30),
            //             elevation: 8, // 影の離れ具合
            //             shadowColor: Colors.black, // 影の色
            //             shape: RoundedRectangleBorder(
            //               // 枠線を変更できる
            //               borderRadius: BorderRadius.circular(10),
            //             ),
            //             child: Column(
            //               children: [
            //                 Selector<PlayerData, int>(
            //                   selector: (_, playerData) =>
            //                       playerData.currentScore,
            //                   builder: (_, score, __) {
            //                     return Text(
            //                       'You Score: $score',
            //                       style: const TextStyle(
            //                           fontSize: 40, color: Colors.white),
            //                     );
            //                   },
            //                 ),
            //                 // Text('hello'),
            //               ],
            //             ),
            //           ),
            //           // const Text(
            //           //   'Game Over',
            //           //   style: TextStyle(fontSize: 40, color: Colors.white),
            //           // ),
            //           // Selector<PlayerData, int>(
            //           //   selector: (_, playerData) => playerData.currentScore,
            //           //   builder: (_, score, __) {
            //           //     return Text(
            //           //       'You Score: $score',
            //           //       style: const TextStyle(
            //           //           fontSize: 40, color: Colors.white),
            //           //     );
            //           //   },
            //           // ),
            //           Row(
            //             children: [
            //               ElevatedButton(
            //                 child: const Text(
            //                   'Restart',
            //                   style: TextStyle(
            //                     fontSize: 30,
            //                   ),
            //                 ),
            //                 onPressed: () {
            //                   game.overlays.remove(GameOverMenu.id);
            //                   game.overlays.add(Hud.id);
            //                   game.resumeEngine();
            //                   game.reset();
            //                   game.startGamePlay();
            //                   AudioManager.instance.resumeBgm();
            //                 },
            //               ),
            //               ElevatedButton(
            //                 child: const Text(
            //                   'Exit',
            //                   style: TextStyle(
            //                     fontSize: 30,
            //                   ),
            //                 ),
            //                 onPressed: () {
            //                   game.overlays.remove(GameOverMenu.id);
            //                   game.overlays.add(MainMenu.id);
            //                   game.resumeEngine();
            //                   game.reset();
            //                   AudioManager.instance.resumeBgm();
            //                 },
            //               ),
            //             ],
            //           )
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            ),
      ),
    );
  }
}
