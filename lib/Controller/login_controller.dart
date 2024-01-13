import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jewellery_user/Common/snackbar.dart';
import 'package:jewellery_user/ConstFile/constApi.dart';
import 'package:jewellery_user/ConstFile/constColors.dart';
import 'package:jewellery_user/ConstFile/constPreferences.dart';
import 'package:jewellery_user/Screen/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/Login_model.dart';
import 'home_Controller.dart';

class LoginController extends GetxController{

    HomeController homeController = Get.put(HomeController());

    TextEditingController phoneController = TextEditingController();
    TextEditingController passController = TextEditingController();

    Future<void> login(String mobileNo,String pass) async {


        final Map<String, String> headers = {
            'Content-Type': 'application/json',
        };

        final Map<String, dynamic> body = {
            'mobileNo': mobileNo,
            'password': pass,
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
                Get.to(() => const HomeScreen());
                phoneController.clear();
                passController.clear();
                Utils().toastMessage("Login successful");
                debugPrint(response.body);

                debugPrint('Response: ${response.body}');
            } else {
                Utils().errorsnackBar("Login failed", '');
                // Handle unsuccessful login

                // Handle error cases
                debugPrint('Login failed. Status code: ${response.statusCode}');
                debugPrint('Response: ${response.body}');
            }
        } catch (e) {
            Utils().errorsnackBar("title", e.toString());
            // Handle network or other errors
            debugPrint('Error during login: $e');
        }
        homeController.loading.value = false;
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