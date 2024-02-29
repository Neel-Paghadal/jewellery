import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jewellery_user/Common/snackbar.dart';
import 'package:jewellery_user/ConstFile/constApi.dart';
import 'package:jewellery_user/ConstFile/constPreferences.dart';
import 'package:jewellery_user/Screen/Admin%20Screen/home.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/Login_model.dart';
import '../Screen/User_screen/user_home.dart';
import 'home_Controller.dart';

class LoginController extends GetxController {

  HomeController homeController = Get.put(HomeController());
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();


  RxBool isHidden = true.obs;


  void clearController(){
   phoneController.clear();
   passController.clear();
  }

  var deviceId;
  Future<void> login(String mobileNo, String pass) async {
    debugPrint("Device Id : $deviceId");
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'mobileNo': mobileNo,
      'password': pass,
      'DeviceId': deviceId
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(ConstApi.userLogin),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // Successful login, handle the response accordingly
        debugPrint('Login successful');

        final responseData = loginFromJson(response.body);
        debugPrint(responseData.toString());
        ConstPreferences().setToken(responseData.token);
        final SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setBool("login", true);
        clearController();

        Utils().toastMessage("Login successfully");
        debugPrint(response.body);

        debugPrint('Response: ${response.body}');
      } else {
        Utils().errorsnackBar("Login failed", json.decode(response.body)['message']);
        // Handle unsuccessful login

        debugPrint('Response: ${response.body}');

      }
    } catch (e) {
      Utils().errorsnackBar("title", e.toString());
      // Handle network or other errors
      debugPrint('Error during login: $e');
    }

    homeController.loading.value = false;
    mainToken();
    clearController();
  }

  var role;
  String jwtToken = '';
  Future<void> mainToken() async {
    // Replace 'your_token_here' with the actual JWT token you want to decode
    jwtToken = (await ConstPreferences().getToken())!;
    // String jwtToken = 'your_token_here';
    debugPrint(jwtToken);
    Map<String, dynamic>? decodedToken = Jwt.parseJwt(jwtToken);

    if (decodedToken != null) {
      print('Decoded Token: $decodedToken');
      // Access token claims
      List newList = decodedToken.values.toList();
      debugPrint(newList.toString());
      role = newList[1];
      debugPrint('Role value: ${newList[1]}');

      ConstPreferences().setRole(role);

      if (role == 'Admin') {
        Get.to(() => const HomeScreen());
      }else if(role == 'SuperAdmin') {
        Get.to(() => const HomeScreen());
      }
      else {
        Get.to(() => const UserHome());
      }
    } else {
      print('Failed to decode token.');
    }
  }

  // Future<void> loginUser(String mobileNo,String pass) async {
  //     final Map<String, String> headers = {"Content-Type": "application/json"};
  //     final Map<String, dynamic> body = {
  //         "mobileNo": mobileNo,
  //         "password": pass,
  //     };
  //
  //     try {
  //         final response = await http.post(Uri.parse(ConstApi.userLogin),
  //             headers: headers, body: jsonEncode(body));
  //
  //         if (response.statusCode == 200) {
  //             // Successful login, handle the response
  //             debugPrint("Login successful");
  //             final responseData = loginFromJson(response.body);
  //             debugPrint(responseData.toString());
  //             ConstPreferences().setToken(responseData.token);
  //             Utils().toastMessage("Login successful");
  //             debugPrint(response.body);
  //         } else {
  //             Utils().errorsnackBar("Login failed", '');
  //             // Handle unsuccessful login
  //             debugPrint("Login failed. Status code: ${response.statusCode}");
  //             debugPrint(response.body);
  //         }
  //     } catch (error) {
  //         // Handle potential network or server errors
  //         Utils().errorsnackBar("title", error.toString());
  //
  //         debugPrint("Error during login request: $error");
  //     }
  // }
}
