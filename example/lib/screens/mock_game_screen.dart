import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  const ErrorMessage({Key key, this.message}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: MediaQuery.of(context).size.width,
      color: Colors.red,
      child: Center(
        child: Text(
          message,
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}

class SimpleScreen extends StatefulWidget {
  const SimpleScreen({Key key}) : super(key: key);
  @override
  _SimpleScreenState createState() => _SimpleScreenState();
}

class _SimpleScreenState extends State<SimpleScreen> {
  static const String NO_INTERNET_HINT = "Нет подключения";
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  UnityWidgetController _unityWidgetController;
  double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _unityWidgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('SimpleScreen'),
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
              Visibility(
                visible: Provider.of<InternetConnectionStatus>(context) ==
                    InternetConnectionStatus.disconnected,
                child: ErrorMessage(message: NO_INTERNET_HINT),
              ),
              Provider.of<InternetConnectionStatus>(context) ==
                  InternetConnectionStatus.disconnected
                  ? Expanded(
                      child: Center(
                        child: Text(
                          NO_INTERNET_HINT,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                    )
                  : Expanded(
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
                                          Padding(
                                            padding: const EdgeInsets.only(top: 20),
                                            child: Text("Rotation speed:"),
                                          ),
                                          Slider(
                                            onChanged: (value) {
                                              setState(() {
                                                _sliderValue = value;
                                              });
                                              setRotationSpeed(value.toString());
                                            },
                                            value: _sliderValue,
                                            min: 0.0,
                                            max: 1.0,
                                          ),
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

  void setRotationSpeed(String speed) {
    _unityWidgetController.postMessage(
      'Cube',
      'SetRotationSpeed',
      speed,
    );
  }

  void onUnityMessage(message) {
    print('Received message from unity: ${message.toString()}');
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