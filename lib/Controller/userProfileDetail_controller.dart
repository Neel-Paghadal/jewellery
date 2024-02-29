

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/Common/snackbar.dart';
import 'package:jewellery_user/ConstFile/constApi.dart';
import 'package:jewellery_user/ConstFile/constPreferences.dart';
import 'package:jewellery_user/Models/userProfileDetail_model.dart';
import 'package:http/http.dart' as http;

class UserProfileDetailController extends GetxController{


  RxList<UserProfile> userDetailList = <UserProfile>[].obs;

  var userId;

  getUserProfileCall(String id) async {

    String? token = await ConstPreferences().getToken();
    debugPrint(token);

    // Set up headers with the token
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
        Uri.parse(ConstApi.userProfileDetail+id),
        headers: headers);
    if (response.statusCode == 200) {
      // isLoaderShow.value = false;
      final responseData = userProfileDetailModelFromJson(response.body);
      debugPrint("USER LIST " + responseData.toString());
      userDetailList.clear();
      userDetailList.add(responseData.user);
      return userDetailList;
      debugPrint('Response: ${response.body}');
      // Process the data as needed
    } else {
      // isLoaderShow.value = false;
      // Error in API call
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error body: ${response.body}');
    }
    if(response.statusCode == 401 || response.statusCode == 403){
      Utils().toastMessage("Please Relogin Account");
      ConstPreferences().clearPreferences();
      SystemNavigator.pop();
    }
    // isLoaderShow.value = false;
  }






}