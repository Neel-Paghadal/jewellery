import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/ConstFile/constColors.dart';
import 'package:jewellery_user/ConstFile/constFonts.dart';
import 'package:jewellery_user/Screen/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_screen/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
      () {
        checkPref();
      },
    );
  }

  checkPref() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("login") == true) {
      Get.to(() => const HomeScreen());
    } else {
      Get.to(() => const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColour.bgColor,
      body: Center(
        child: Text('splash'.tr,
            style: TextStyle(
                fontFamily: ConstFont.poppinsBold,
                color: ConstColour.primaryColor,
                fontSize: 40),
            overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
// Text('name'.tr,
//     style: TextStyle(
//         fontFamily: ConstFont.poppinsBold,
//         color: ConstColour.primaryColor,
//         fontSize: 16),
//     overflow: TextOverflow.ellipsis),
// SizedBox(
//   height: 40,
// ),
// Text('message'.tr,
//     style: TextStyle(
//         fontFamily: ConstFont.poppinsBold,
//         color: ConstColour.primaryColor,
//         fontSize: 16),
//     overflow: TextOverflow.ellipsis),
// Text('name'.tr,
//     style: TextStyle(
//         fontFamily: ConstFont.poppinsBold,
//         color: ConstColour.primaryColor,
//         fontSize: 16),
//     overflow: TextOverflow.ellipsis),
// ElevatedButton(
//     onPressed: () {
//       setState(() {
//         Get.updateLocale(Locale('en', 'US'));
//       });
//     },
//     child: Text("English")),
// SizedBox(
//   height: 40,
// ),
// ElevatedButton(
//     onPressed: () {
//       setState(() {
//         Get.updateLocale(Locale('gu', 'IN'));
//       });
//     },
//     child: Text("ગુજરાતી")),