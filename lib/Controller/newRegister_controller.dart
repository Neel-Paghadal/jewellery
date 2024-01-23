import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/Screen/home.dart';
import 'package:http/http.dart' as http;
import '../Common/snackbar.dart';
import '../ConstFile/constApi.dart';
import 'home_Controller.dart';
import 'login_controller.dart';

class NewRegisterCon extends GetxController{
  HomeController homeController = Get.put(HomeController());
  LoginController loginController = Get.put(LoginController());

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cPassword = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController reference = TextEditingController();


  void clearController(){
    firstName.clear();
    lastName.clear();
    password.clear();
    cPassword.clear();
    address.clear();
    mobile.clear();
    reference.clear();

  }



  Future<void> userRegister(String firstName,String lastName,String password,String mobileNumber,String address,
      String referenceName) async {
    debugPrint("Device id : ${loginController.deviceId}");
    Map<String, dynamic> requestData = {
      "firstName": firstName,
      "lastName": lastName,
      "password": password,
      "mobileNumber": mobileNumber,
      "address": address,
      "referenceName": referenceName,
      "DeviceId": ''
    };

    debugPrint("Request Data : "+requestData.toString());

    try {
      final http.Response response = await http.post(
          Uri.parse(ConstApi.newUser),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(requestData));



      if (response.statusCode == 201) {
        debugPrint('API call successful');
        debugPrint('Response: ${response.body}');
        Utils().toastMessage("Register Successfull");
        clearController();
        Get.to(() => const HomeScreen());
      } else {
        debugPrint('Error: ${response.reasonPhrase}');
        Utils().errorsnackBar(response.reasonPhrase.toString(), '');
      }
    } catch (e) {
      debugPrint('Error: $e');
      Utils().errorsnackBar(e.toString(), '');

    }

    homeController.loading.value = false;
  }

}