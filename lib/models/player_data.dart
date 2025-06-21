import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'player_data.g.dart';

// This class stores the player progress presistently.
@HiveType(typeId: 0)
class PlayerData extends ChangeNotifier with HiveObjectMixin {
  @HiveField(1)
  int highScore = 0;
  int totalScore = 0;
  int score = 0;
  int attack = 0;

  // int _lives = 5;

  // int get lives => _lives;
  // set lives(int value) {
  //   if (value <= 5 && value >= 0) {
  //     _lives = value;
  //     notifyListeners();
  //   }
  // }

  int _currentScore = 0;

  int get currentScore => _currentScore;
  set currentScore(int value) {
    _currentScore = value;

    score = totalScore + _currentScore;
    if (highScore < _currentScore) {
      highScore = _currentScore;
    }

    notifyListeners();
    save();
  }

  set clear(int value) {
    totalScore = totalScore + value; // value = 1000
    notifyListeners();
    save();
  }
}
