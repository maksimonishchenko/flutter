import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  final String msg;
  const MessageScreen({Key key,this.msg}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp( //use MaterialApp() widget like this
        home: _MessageScreenState(message: this.msg) //create new widget class for this 'home' to
      // escape 'No MediaQuery widget found' error
    );
  }
}

class _MessageScreenState extends StatelessWidget{
  static const String ERROR_TITLE = 'Сбой запуска';
  final String message;
  const _MessageScreenState({Key key,this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ERROR_TITLE),
      ),
      body: Card(
          margin: const EdgeInsets.all(0),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column
            (
            children:
            <Widget>
            [
              Expanded(
                child: Center(
                  child: Text(
                    message,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              )
            ],
            )
      ));
  }
}