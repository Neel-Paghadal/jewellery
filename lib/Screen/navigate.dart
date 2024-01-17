import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/ConstFile/constColors.dart';
import 'package:jewellery_user/ConstFile/constFonts.dart';
import 'package:jewellery_user/Screen/auth_screen/login.dart';

import 'auth_screen/register.dart';

class NavigateScreen extends StatefulWidget {
  const NavigateScreen({super.key});

  @override
  State<NavigateScreen> createState() => _NavigateScreenState();
}

class _NavigateScreenState extends State<NavigateScreen> {
  @override
  Widget build(BuildContext context) {

    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ConstColour.bgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           Center(
             child: ElevatedButton(
                 style: ElevatedButton.styleFrom(
                     backgroundColor: ConstColour.primaryColor
                 ),
                 onPressed: () {

                    Get.to(() => const LoginScreen() );
             }, child: const Text("Login",style: TextStyle(fontFamily: ConstFont.poppinsRegular,fontSize: 16,color: Colors.white),overflow: TextOverflow.ellipsis,)),
           ),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ConstColour.primaryColor
              ),
                onPressed: () {
              Get.to(() => const RegisterScreen());

             }, child: const Text("Register",style: TextStyle(fontFamily: ConstFont.poppinsRegular,fontSize: 16,color: Colors.white),overflow: TextOverflow.ellipsis,)),
          )
        ],
      ),
    );
  }
}
