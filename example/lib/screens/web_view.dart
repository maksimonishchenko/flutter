import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewWidget extends StatelessWidget {
  final String serverAdress;

  const WebViewWidget ({ Key key, this.serverAdress }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: WebViewExampleState(msg:this.serverAdress)
    );
  }
}

class WebViewExampleState extends StatelessWidget {
  final String msg;
  WebViewController webView;

  WebViewExampleState({Key key,this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBack,
      child: Scaffold(
          body: SafeArea(
              child: WebView(
                initialUrl: this.msg,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (controller) => {webView  = controller},
              ))),
      );
  }

  Future<bool> onBack() async {
    bool goBack;
    var value = await webView.canGoBack();  // check webview can go back
    print("value " + value.toString());
    if (value) {
      webView.goBack(); // perform webview back operation
      return false;
    } else {
      return false;
    }
  }
}