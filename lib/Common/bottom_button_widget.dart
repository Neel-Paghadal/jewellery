import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/ConstFile/constFonts.dart';
import 'package:jewellery_user/Controller/home_Controller.dart';

import '../ConstFile/constColors.dart';

class NextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  var btnName;
   NextButton({Key? key, this.onPressed,this.btnName}) : super(key: key);

   HomeController homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    return   Obx(
      () => ElevatedButton(
                style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          minimumSize: Size(deviceWidth * 0.9, deviceHeight * 0.06),
           maximumSize: Size(deviceWidth * 1.0, deviceHeight * 0.07),
          backgroundColor: ConstColour.primaryColor
      ),
      onPressed: homeController.loading.value.obs == true ? null : onPressed,

          child:  homeController.loading.value.obs == true
          ? const CircularProgressIndicator(
        color: Colors.white,
      ) : Text(btnName,style: const TextStyle(fontFamily: ConstFont.poppinsRegular,fontWeight: FontWeight.w600, fontSize: 20,color: Colors.black),overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,)),
    );
  }
}