import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget_example/screens/no_interaction_screen.dart';
import 'package:flutter_unity_widget_example/screens/orientation_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'menu_screen.dart';
import 'screens/api_screen.dart';
import 'screens/loader_screen.dart';
import 'screens/simple_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_unity_widget_example/web_view.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  final prefs =  await SharedPreferences.getInstance();
  final prefsUrl =   await prefs.getString("url");

  if(prefsUrl != null && prefsUrl != "")
  {
    //todo: check connection show no connection screen
    print('saved prefsUrl read succesfully '+ prefsUrl + ' runAPp WebViewExample : main.dart');
    runApp(WebViewExample(serverAdress: prefsUrl));
    return;
  }
  //runApp(MyApp());

       print('no prefsUrl saved tring to fetch from firebase : main.dart');

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
         print('activateResult'+ activateResult.toString() + ' : main.dart');

         String url = remoteConfig.getString('url');

         if (url == null || url == "" || checkIsEmu() == true)//todo: check no sim
             {
           print('  url null or url empty or emulator open mock game : main.dart');
           //todo: add and open mock game
         } else
         {
           //todo: check connection show no connection screen
           await prefs.setString("url", url);
           print(url + '   is url string setted to shared preferences local store run web view  : main.dart');
           runApp(WebViewExample(serverAdress: prefsUrl));
         }
       } catch (exception) {
         //todo: add and show error firebase screen
         print(exception.toString() + ' happen show exception screen : main.dart');
       }
       //runApp(MyApp());

}

checkIsEmu() async {
  final  devinfo = DeviceInfoPlugin();
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

//class MyApp extends StatelessWidget {
  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//     title: 'Flutter Unity Demo',
//      theme: ThemeData(
//        primarySwatch: Colors.blue,
//        visualDensity: VisualDensity.adaptivePlatformDensity,
//      ),
//      initialRoute: '/',
//      routes: {
//        '/': (context) => MenuScreen(),
//        '/simple': (context) => SimpleScreen(),
//        '/loader': (context) => LoaderScreen(),
//        '/orientation': (context) => OrientationScreen(),
//        '/api': (context) => ApiScreen(),
//       '/none': (context) => NoInteractionScreen(),
//      },
//    );
//  }
//}