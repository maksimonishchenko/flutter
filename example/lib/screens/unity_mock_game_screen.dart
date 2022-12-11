import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class UnityMockGameScreen extends StatelessWidget {

  const UnityMockGameScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: _UnityMockGameScreenState()
    );
  }
}

class _UnityMockGameScreenState extends StatelessWidget {

  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  UnityWidgetController _unityWidgetController;
  static const String score = "Очки:";
  String scoreValue = "0";


  @override
  void dispose() {
    _unityWidgetController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Tetris'),
      ),
      body: Card(
          margin: const EdgeInsets.all(0),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Stack
            (
            children:
            <Widget>
            [
              Expanded(
                      child: Stack
                            (
                              children:
                              [
                                UnityWidget
                                  (
                                  onUnityCreated: _onUnityCreated,
                                  onUnityMessage: onUnityMessage,
                                  onUnitySceneLoaded: onUnitySceneLoaded,
                                  useAndroidViewSurface: false,
                                  borderRadius: BorderRadius.all(Radius.circular(70)),
                                ),
                                PointerInterceptor
                                  (
                                  child: Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Card(
                                      elevation: 10,
                                      child: Column(
                                        children: <Widget>[
                                          Text("Score:" + scoreValue),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ]
                            )
                      )
                   ],
            )
      ));
  }

  void onUnityMessage(message) {
    print('Received message from unity: ${message.toString()}');
    scoreValue = message;
  }

  void onUnitySceneLoaded(SceneLoaded scene) {
    print('Received scene loaded from unity: ${scene.name}');
    print('Received scene loaded from unity buildIndex: ${scene.buildIndex}');
  }

  // Callback that connects the created controller to the unity controller
  void _onUnityCreated(controller) {
    controller.resume();
    this._unityWidgetController = controller;
  }
}