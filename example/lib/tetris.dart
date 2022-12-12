import 'package:flutter_unity_widget_example/menu.dart';
import 'package:flutter_unity_widget_example/game.dart';
import 'package:flutter/material.dart';

class Tetris extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Игра",
      theme: ThemeData(
        fontFamily: 'fontello',
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.black,
          displayColor: Colors.grey[600],
        ),
        primaryColor:  Colors.grey[500],
        //textSelectionHandleColor:  Colors.green[500],
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Menu'),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey,
      body: Menu(),
    );
  }
}

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios),
          onPressed: () async {
            timer.cancel();
            Navigator.pop(context);
          },
        ),
        title: Text('Play'),
        centerTitle: true,
      ),
      backgroundColor: Colors.brown[300],
      body: Game(),
    );
  }
}
