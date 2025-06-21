import 'package:flutter/material.dart';
// import 'package:avoid_balls/topGame.dart';
import 'package:trampoline/model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// class LifeConponent extends TextComponent {
//   LifeConponent({
//     String? text,
//     Color? color,
//     double? fontSize,
//   }) : super(
//           text ?? "default",
//           config: TextConfig(
//             color: color ?? Colors.white,
//             fontSize: fontSize ?? 32.0,
//           ),
//         ) {
//     anchor = Anchor.center;
//   }
// }

class LifeBar extends StatelessWidget {
  const LifeBar({
    super.key,
    // required this.game,
    required this.gameModel,
  });

  // final TopPageGame game;
  final GameModel gameModel;

  // [Icon(Icons.favorite), Icon(Icons.favorite_border)]

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withAlpha(100),
      child: Consumer(
        builder: (context, ref, _) {
          ref.watch(gameProvider);
          return Row(
            children: [
              Row(children: gameModel.lifes),
              Text(gameModel.sec.toString()),
            ],
          );
        },
      ),
    );
  }
}
