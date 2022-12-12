import 'package:flutter/material.dart';

class ScoreDisplay extends StatelessWidget {
  final int score;
  ScoreDisplay(this.score);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.green[200]),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        "Очки \n $score",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'fontello',
          color: Colors.white,
        ),
      ),
    );
  }
}
