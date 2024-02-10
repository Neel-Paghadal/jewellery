import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:jewellery_user/Common/checkInternet.dart';
import 'package:jewellery_user/Screen/User_screen/user_home.dart';
import 'package:jewellery_user/Screen/languages.dart';
import 'package:jewellery_user/Screen/splashScreen.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final ImagePickerPlatform imagePickerImplementation = ImagePickerPlatform.instance;
  if (imagePickerImplementation is ImagePickerAndroid) {
    imagePickerImplementation.useAndroidPhotoPicker = true;
  }

  runApp(const MyApp());
  // runApp(DevicePreview(
  //   enabled: true, builder: (context) => MyApp(),
  // ));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Jewellery',
      locale: Locale('en','US'),
      // locale: Locale('gu','IN'),
      // locale: Locale('hi','IN'),
      translations: Languages(),
      // fallbackLocale: Locale('en','US'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(splashColor: Colors.white,useMaterial3: false),
      // home: const SplashScreen(),
      home :  InternetStatus(child: SplashScreen(),)
      // home: const ReportScreen(),
      // home: const UserHome(),
    );
  }
}


