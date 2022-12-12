import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget_example/blocks/block.dart';
import 'package:flutter_unity_widget_example/blocks/iblock.dart';
import 'package:flutter_unity_widget_example/blocks/jblock.dart';
import 'package:flutter_unity_widget_example/blocks/Lblock.dart';
import 'package:flutter_unity_widget_example/blocks/sblock.dart';
import 'package:flutter_unity_widget_example/blocks/sqblock.dart';
import 'package:flutter_unity_widget_example/blocks/Tblock.dart';
import 'package:flutter_unity_widget_example/blocks/zblock.dart';
import 'package:flutter_unity_widget_example/game.dart';

Block getRandomBlock() {
  int randomNr = Random().nextInt(7);
   switch (randomNr) {
    case 0:
      return IBlock(BOARD_WIDTH);
    case 1:
      return JBlock(BOARD_WIDTH);
    case 2:
      return LBlock(BOARD_WIDTH);
    case 3:
      return SBlock(BOARD_WIDTH);
    case 4:
      return SquareBlock(BOARD_WIDTH);
    case 5:
      return TBlock(BOARD_WIDTH);
    case 6:
      return ZBlock(BOARD_WIDTH);
  }
}

Widget getTetrisPoint(Color color) {
  return Container(
    width: POINT_SIZE,
    height: POINT_SIZE,
    decoration: new BoxDecoration(
      color: color,
      shape: BoxShape.rectangle,
    ),
  );
}

Widget getGameOverText(int score) {
  return Center(
    child: Text(
      'Конец игры \nОчки: $score',
      style: TextStyle(
          fontSize: 35.0,
          fontWeight: FontWeight.bold,
          color: Colors.green[300],
          shadows: [
            Shadow(
              color: Colors.white12,
              blurRadius: 3.0,
              offset: Offset(2.0, 2.0),
            )
          ]),
    ),
  );
}
