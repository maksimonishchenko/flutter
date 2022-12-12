import 'package:flutter/material.dart';
import 'package:flutter_unity_widget_example/game.dart';

import 'game.dart';

class ActionButton extends StatelessWidget {
  final Function onClickedFunction;
  final Icon buttonIcon;
  final LastButtonPressed nextAction;

  ActionButton(this.onClickedFunction, this.buttonIcon, this.nextAction);

  Widget build(BuildContext context) {
    return ButtonTheme(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
        child: ElevatedButton(
          onPressed: () {
            onClickedFunction(nextAction);
          },
          //shape: RoundedRectangleBorder(
          //    borderRadius: BorderRadius.circular(18.0),
          //    side: BorderSide(color: Colors.green[200])),
          //color: Colors.green[200],
          child: buttonIcon,
        ),
      ),
    );
  }
}
