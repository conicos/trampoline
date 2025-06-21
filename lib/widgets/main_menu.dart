import 'dart:ui';

import 'package:trampoline/model.dart';
import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

import '/widgets/hud.dart';
import '/dino_run.dart';
import '/widgets/settings_menu.dart';
import '/models/audio_manager.dart';

// This represents the main menu overlay.
class MainMenu extends StatefulWidget {
  // An unique identified for this overlay.
  static const id = 'MainMenu';

  // Reference to parent game.
  final DinoRun game;
  final GameModel gameModel;

  const MainMenu(this.game, {super.key, required this.gameModel});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  void initState() {
    super.initState();
    // widget.game.overlays.add('life');

    // // widget.gameModel.show = false;
    // widget.gameModel.getAdMobs();
    // // WidgetsBinding.instance.addObserver(this);
    // widget.gameModel.getDateTime();
  }

  // @override
  // void dispose() {
  //   widget.gameModel.disposeAdMobs();
  //   // WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.black.withAlpha(100),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 100,
              ),
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                  const Text(
                    'Dino Run',
                    style: TextStyle(fontSize: 50, color: Colors.white),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // widget.game.start();
                      widget.game.world.startGamePlay();
                      widget.game.overlays.remove(MainMenu.id);
                      widget.game.overlays.remove('life');
                      widget.game.overlays.add(Hud.id);
                    },
                    child: const Text('Play', style: TextStyle(fontSize: 30)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      widget.game.overlays.remove(MainMenu.id);
                      widget.game.overlays.add(SettingsMenu.id);
                    },
                    child: const Text(
                      'Settings',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  // SizedBox(
                  //   width: double.infinity,
                  //   // height: double.infinity,
                  //   child: FutureBuilder(
                  //       future: AdSize.getAnchoredAdaptiveBannerAdSize(
                  //           Orientation.portrait,
                  //           MediaQuery.of(context).size.width.truncate()),
                  //       builder: (BuildContext context,
                  //           AsyncSnapshot<AnchoredAdaptiveBannerAdSize?>
                  //               snapshot) {
                  //         if (snapshot.hasData) {
                  //           return SizedBox(
                  //             width: double.infinity,
                  //             child: widget.gameModel.adMob.getAdBanner(),
                  //           );
                  //         } else {
                  //           return Container(
                  //             height:
                  //                 widget.gameModel.adMob.getAdBannerHeight(),
                  //             color: Colors.white,
                  //           );
                  //         }
                  //       }),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
