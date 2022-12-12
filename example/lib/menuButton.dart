import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final Function onClickedFunction;

  MenuButton(this.onClickedFunction);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 60,
      minWidth: 200,
      child: ElevatedButton(
        //style: ,
        //shape: RoundedRectangleBorder(
        //    borderRadius: BorderRadius.circular(18.0),
        //    side: BorderSide(color: Colors.white12)),
        onPressed: () {
          onClickedFunction();
        },
        //color: Colors.green[300],
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
