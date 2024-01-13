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
      Duration(seconds: 3),
      () {
        checkPref();
      },
    );
  }

  checkPref() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("login") == true) {
      Get.to(() => HomeScreen());
    } else {
      Get.to(() => LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColour.bgColor,
      body: Center(
        child: Text("Jewellery",
            style: TextStyle(
                fontFamily: ConstFont.poppinsBold,
                color: ConstColour.primaryColor,
                fontSize: 45),
            overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
