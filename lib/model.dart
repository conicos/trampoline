import 'dart:io';
import 'dart:ui';
import 'package:convert/convert.dart';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/rendering.dart';
import 'package:trampoline/admob/ad_mob.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

final gameProvider = ChangeNotifierProvider((ref) => GameModel());

class GameModel extends ChangeNotifier {
  int life = 4;
  int time = 0;
  int sec = 0; // recovory timer
  int cours = 300;
  bool show = false;
  bool active = true;
  bool isGround = false;
  List<Icon> lifes = [];
  File? applicationDocumentsFile;
  final format = FixedDateTimeFormatter('YYYYMMDDhhmmss');
  Stopwatch stopwatch = Stopwatch();

  // final AdMob adMob = AdMob();
  // late final RewardedAdManager rewardedAdManager;

  GameModel() {
    // rewardedAdManager = RewardedAdManager(getReward: getReward);
    lifeUpdate();

    // notifyListeners();
  }

  // void getAdMobs() {
  //   adMob.load();
  //   // rewardedAdManager.loadRewardedAd();
  // }

  // void disposeAdMobs() {
  //   adMob.dispose();
  //   // rewardedAdManager;
  // }

  void setDateTime() async {
    DateTime now = DateTime.now().toUtc();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('time', int.parse(format.encode(now)));
    prefs.setInt('sec', sec);
    prefs.setInt('life', life);
    sec = 0;
    active = false;
  }

  void getDateTime() async {
    DateTime now = DateTime.now();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sec =
        now
            .difference(
              format
                  .decode(
                    (prefs.getInt('time') ?? format.encode(now)).toString(),
                  )
                  .toLocal(),
            )
            .inSeconds +
        (prefs.getInt('sec') ?? 0).toInt();
    print(sec);
    life = prefs.getInt('life') ?? 0;
    if (sec >= cours * 4) {
      life = life + 4;
      sec = 0;
    } else if (sec >= cours * 3) {
      life = life + 3;
    } else if (sec >= cours * 2) {
      life = life + 2;
    } else if (sec >= cours) {
      life = life + 1;
    }
    if (life > 4) {
      life = 4;
      sec = 0;
    }
    sec = sec % cours;
    active = true;
    lifeUpdate();
    notifyListeners();
  }

  void count() {
    if (active) {
      if (life < 4) {
        sec++;
        if (sec >= cours) {
          life = life + 1;
          sec = 0;
        }
        lifeUpdate();
        notifyListeners();
      }
    }
  }

  void lifeUpdate() {
    lifes = [];
    for (int i = 0; i <= 3; i++) {
      if (i < life) {
        lifes.add(const Icon(Icons.favorite, color: Colors.red));
      } else {
        lifes.add(const Icon(Icons.favorite_border, color: Colors.white));
      }
    }
    // notifyListeners();
  }

  void changeTopPage() {
    if (!show) {
      show = true;
    } else {
      show = false;
    }
    notifyListeners();
  }

  void getReward() {
    life = 4;
    setDateTime();
    lifeUpdate();
    notifyListeners();
  }

  Future<ByteData?> exportWidgetToImage(GlobalKey globalKey) async {
    final boundary =
        globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData;
  }

  Future<File> getApplicationDocumentsFile(
    String text,
    List<int> imageData,
  ) async {
    final directory = await getApplicationDocumentsDirectory();

    final exportFile = File('${directory.path}/$text.png');
    if (!await exportFile.exists()) {
      await exportFile.create(recursive: true);
    }
    final file = await exportFile.writeAsBytes(imageData);
    return file;
  }

  shareWidgetImage({required GlobalKey globalKey}) async {
    // globalKeyからWidgetを画像へ変換
    final byteData = await exportWidgetToImage(globalKey);
    if (byteData == null) {
      return;
    }
    // 画像をUint8Listへ変換
    final widgetImageBytes = byteData.buffer.asUint8List(
      byteData.offsetInBytes,
      byteData.lengthInBytes,
    );
    // 画像をローカルパスに保存
    applicationDocumentsFile = await getApplicationDocumentsFile(
      globalKey.toString(),
      widgetImageBytes,
    );
    final path = XFile(applicationDocumentsFile!.path);
    // 画像をシェア
    // await Share.shareXFiles(
    //   [path],
    // );
    return path;
  }

  shareImages(XFile path) async {
    await Share.shareXFiles([path], text: '#アボアボ');
  }
}
