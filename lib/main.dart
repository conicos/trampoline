import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dino_run.dart';
import 'model.dart';
import 'models/player_data.dart';
import 'models/settings.dart';
import 'widgets/hud.dart';
import 'models/settings.dart';
import 'widgets/main_menu.dart';
import 'models/player_data.dart';
import 'widgets/pause_menu.dart';
import 'widgets/life.dart';
import 'widgets/clear_menu.dart';
import 'widgets/settings_menu.dart';
import 'widgets/game_over_menu.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // MobileAds.instance.initialize();
  await initHive();
  runApp(const ProviderScope(child: DinoRunApp()));
}

Future<void> initHive() async {
  if (!kIsWeb) {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }
  Hive.registerAdapter<PlayerData>(PlayerDataAdapter());
  Hive.registerAdapter<Settings>(SettingsAdapter());
}

class DinoRunApp extends ConsumerWidget {
  const DinoRunApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GameModel gameModel = ref.read(gameProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dino Run',
      theme: ThemeData(
        fontFamily: 'AntonSC', // pubspecのfontfamily から読み込み
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            fixedSize: const Size(200, 60),
          ),
        ),
      ),
      home: Scaffold(
        body: GameWidget<DinoRun>(
          game: DinoRun(gameModel: gameModel),
          loadingBuilder:
              (conetxt) => const Center(
                child: SizedBox(width: 200, child: LinearProgressIndicator()),
              ),
          overlayBuilderMap: {
            'life': (_, game) => LifeBar(gameModel: gameModel),
            MainMenu.id: (_, game) => MainMenu(game, gameModel: gameModel),
            PauseMenu.id: (_, game) => PauseMenu(game),
            Hud.id: (_, game) => Hud(game),
            GameOverMenu.id: (_, game) => GameOverMenu(game),
            ClearMenu.id: (_, game) => ClearMenu(game),
            SettingsMenu.id: (_, game) => SettingsMenu(game),
          },
          initialActiveOverlays: const [MainMenu.id, 'life'],
        ),
      ),
    );
  }
}
