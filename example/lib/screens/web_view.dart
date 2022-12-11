import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewWidget extends StatelessWidget {
  final String serverAdress;

  const WebViewWidget({Key key, this.serverAdress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: WebViewExampleState(msg: this.serverAdress));
  }
}

class WebViewExampleState extends StatelessWidget {
  final String msg;
  WebViewController webViewController;

  WebViewExampleState({Key key, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBack,
      child: Scaffold(
          body: SafeArea(
              child: WebView(
        initialUrl: this.msg,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: onWebViewCreated,
        onPageFinished: onPageFinished,
      ))),
    );
  }

  Future<bool> onBack() async {
    bool goBack;
    var value =
        await webViewController.canGoBack(); // check webview can go back
    print("value " + value.toString());
    if (value) {
      webViewController.goBack(); // perform webview back operation
      return false;
    } else {
      return false;
    }
  }

  void onWebViewCreated(WebViewController controller)
  {
    webViewController = controller;
  }

  void onPageFinished(String url)
  {
    SharedPreferences.getInstance().then(
            (prefs) => {
              print('saved cookies for url ' + url + ' : ' + prefs.getString("cookies" + url))
            });

    if(webViewController != null)
      webViewController.runJavascriptReturningResult('document.cookie')
        .then((cookies) => {
      SharedPreferences.getInstance().then(
              (prefs) => {prefs.setString("cookies" + url, cookies)})
    });
  }
}
