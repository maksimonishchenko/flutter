import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget_example/helper.dart';
import 'package:flutter_unity_widget_example/blocks/block.dart';
import 'package:flutter_unity_widget_example/blocks/alivePoint.dart';
import 'package:flutter_unity_widget_example/scoreDisplay.dart';
import 'package:flutter_unity_widget_example/userInput.dart';

enum LastButtonPressed { LEFT, RIGHT, ROTATE_LEFT, ROTATE_RIGHT, NONE }
enum MoveDir { LEFT, RIGHT, DOWN }

const int BOARD_WIDTH = 10;
const int BOARD_HEIGHT = 20;

const double POINT_SIZE = 20; //size is px

const double WIDTH = 200;
const double HEIGHT = 400;

const int GAME_SPEED = 400;
Timer timer;

class Game extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Game();
}

class _Game extends State<Game> {
  LastButtonPressed performAction = LastButtonPressed.NONE;
  Block currentBlock;
  List<AlivePoint> alivePoints = List<AlivePoint>();
  int score = 0;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void onActionButtonPressed(LastButtonPressed newAction) {
    setState(() {
      performAction = newAction;
    });
  }

  void startGame() {
    setState(() {
      currentBlock = getRandomBlock();
    });

    timer = new Timer.periodic(
      new Duration(milliseconds: GAME_SPEED),
      onTimeTick,
    );
  }

  void checkForUserInput() {
    if (performAction != LastButtonPressed.NONE) {
      setState(() {
        switch (performAction) {
          case LastButtonPressed.LEFT:
            currentBlock.move(MoveDir.LEFT);
            break;
          case LastButtonPressed.RIGHT:
            currentBlock.move(MoveDir.RIGHT);
            break;
          case LastButtonPressed.ROTATE_LEFT:
            currentBlock.rotateLeft();
            break;
          case LastButtonPressed.ROTATE_RIGHT:
            currentBlock.rotateRight();
            break;
          default:
            break;
        }

        performAction = LastButtonPressed.NONE;
      });
    }
  }

  void saveOldBlock() {
    currentBlock.points.forEach((point) {
      AlivePoint newPoint = AlivePoint(point.x, point.y, currentBlock.color);
      setState(() {
        alivePoints.add(newPoint);
      });
    });
  }

  bool isAbowOldBlock() {
    bool retVal = false;

    alivePoints.forEach((oldPoint) {
      if (oldPoint.checkIfPointsCollide(currentBlock.points)) {
        retVal = true;
      }
    });

    return retVal;
  }

  void removeRow(int row) {
    setState(() {
      alivePoints.removeWhere((point) => point.y == row);

      alivePoints.forEach((point) {
        if (point.y < row) {
          point.y += 1;
        }
      });
      score += 1;
    });
  }

  void removeFullRow() {
    for (int currentRow = 0; currentRow < BOARD_HEIGHT; currentRow++) {
      int counter = 0;
      //loop through all row (top to bottom)
      alivePoints.forEach((point) {
        if (point.y == currentRow) {
          counter++;
        }
      });

      if (counter >= BOARD_WIDTH) {
        //remove current row
        removeRow(currentRow);
      }
    }
  }

  bool playerLost() {
    bool retVal = false;

    alivePoints.forEach((point) {
      if (point.y <= 0) {
        retVal = true;
      }
    });

    return retVal;
  }

  void onTimeTick(Timer time) {
    if (currentBlock == null || playerLost()) return;

    //remove full rows
    removeFullRow();

    //check if the tile is already at the bottom
    if (currentBlock.isAtBottom() || isAbowOldBlock()) {
      //save the block
      saveOldBlock();

      // spawn new block
      setState(() {
        currentBlock = getRandomBlock();
      });
    } else {
      setState(() {
        currentBlock.move(MoveDir.DOWN);
      });
      checkForUserInput();
    }
  }

  Widget drawTetrisBlocks() {
    if (currentBlock == null) return null;

    List<Positioned> visiblePoints = List();
    //currentBlock
    currentBlock.points.forEach((point) {
      visiblePoints.add(
        Positioned(
          child: getTetrisPoint(currentBlock.color),
          left: point.x * POINT_SIZE,
          top: point.y * POINT_SIZE,
        ),
      );
    });

    //old block
    alivePoints.forEach((point) {
      visiblePoints.add(
        Positioned(
          child: getTetrisPoint(point.color),
          left: point.x * POINT_SIZE,
          top: point.y * POINT_SIZE,
        ),
      );
    });

    return Stack(children: visiblePoints);
  }

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Center(
          child: Container(
            width: WIDTH,
            height: HEIGHT,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: (playerLost() == false)
                ? drawTetrisBlocks()
                : getGameOverText(score),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ScoreDisplay(score),
            UserInput(onActionButtonPressed),
          ],
        )
      ],
    );
  }
}
