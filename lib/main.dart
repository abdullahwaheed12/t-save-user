import 'dart:developer';

import 'package:com.tsaveuser.www/controllers/local_notification.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:com.tsaveuser.www/controllers/general_controller.dart';
import 'package:com.tsaveuser.www/utils/theme.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'modules/splash/view.dart';
import 'route_generator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  // LocalNotificationService.display(message);

  print('background message :  ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await GetStorage.init();

  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Get.put(GeneralController())..requestLocationPermission(context);
  }

  @override
  Widget build(BuildContext context) {
    /// on app closed
    FirebaseMessaging.instance.getInitialMessage();

    ///forground messages
    FirebaseMessaging.onMessage.listen((message) {
      print('A bg message just showed up :  ${message.messageId}');
      try {
        LocalNotificationService.initialize(context);
        LocalNotificationService.display(message);
      } catch (e) {
        print('exception in notification ${e.toString()}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log('Notifications--->>$message');
    });
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
    ]);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
      themeMode: ThemeMode.light,
      theme: lightTheme(),
      getPages: routes(),
    );
  }
}
