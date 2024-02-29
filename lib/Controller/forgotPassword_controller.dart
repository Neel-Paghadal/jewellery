import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jewellery_user/Common/snackbar.dart';
import 'package:jewellery_user/ConstFile/constApi.dart';
import 'package:jewellery_user/Controller/home_Controller.dart';
import '../ConstFile/constPreferences.dart';

class ForgotPassController extends GetxController {
  HomeController homeController = Get.put(HomeController());

  TextEditingController password = TextEditingController();
  TextEditingController cPassword = TextEditingController();

  RxBool isHidden = false.obs;
  RxBool isHiddenSec = false.obs;

  clearController(){
    password.clear();
    cPassword.clear();
  }

  Future<void>  forgotPasswordCall(String userId, String pass) async {
    homeController.loading.value = true;
    String? token = await ConstPreferences().getToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    Map<String, dynamic> requestData = {"UserId": userId, "Password": pass};
    debugPrint("Request Data : ${requestData}");
    try {
      final response = await http.post(Uri.parse(ConstApi.forgotPassword), headers: headers, body: jsonEncode(requestData));
      if (response.statusCode == 200) {
        debugPrint('API call successful');
        debugPrint('Response: ${response.body}');
        Utils().toastMessage(json.decode(response.body)['message']);
        clearController();

        Get.back();
      } else {
        homeController.loading.value = false;

        debugPrint('Error: ${response.reasonPhrase}');
        Utils().errorsnackBar(response.body.toString(), '');
      }
    }catch (e) {
      debugPrint('Error: $e');
      Utils().errorsnackBar(e.toString(), '');
    }
    homeController.loading.value = false;
    clearController();
  }
}
