
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:insurance/isModel/LocationManager.dart';
import 'package:insurance/isModel/communications/is_network_reachability_manager.dart';
import 'package:insurance/resources/app_styles.dart';
import 'package:insurance/screens/base/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LCLocationManager.sharedInstance.initializeLocationManager();
  ISNetworkReachabilityManager.sharedInstance
      .initializeNetworkReachabilityManager();
    runApp(MyApp());
}
class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppStyles.appTheme,
      home: const SplashScreen(),
    );
  }
}