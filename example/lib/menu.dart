import 'package:flutter/material.dart';
import 'package:flutter_unity_widget_example/menuButton.dart';
import 'package:flutter_unity_widget_example/tetris.dart';

class Menu extends StatefulWidget {
  State<StatefulWidget> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  void onPlayClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameScreen()),
    );
  }

  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Игра',
            style: TextStyle(
                fontSize: 70.0,
                fontWeight: FontWeight.bold,
                color: Colors.green[300],
                shadows: [
                  Shadow(
                    color: Colors.white12,
                    blurRadius: 8.0,
                    offset: Offset(2.0, 2.0),
                  )
                ]),
          ),
          MenuButton(onPlayClicked),
        ],
      ),
    );
  }
}