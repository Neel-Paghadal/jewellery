import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:jewellery_user/Screen/splashScreen.dart';

import 'Screen/auth_screen/documentScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Jewellery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(splashColor: Colors.white,useMaterial3: false),
      home: const SplashScreen(),
      // home: const DocumentScreen(),
    );
  }
}


