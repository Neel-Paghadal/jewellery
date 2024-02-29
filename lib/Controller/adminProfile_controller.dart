import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/Models/adminProfile__model.dart';
import 'package:http/http.dart' as http;
import '../Common/snackbar.dart';
import '../ConstFile/constApi.dart';
import '../ConstFile/constPreferences.dart';

class AdminProfileController extends GetxController{


  RxList<AdminProfile> adminProfileList = <AdminProfile>[].obs;

  var adminId;

  getAdminProfileCall(String id) async {

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
      final responseData = adminProfileModelFromJson(response.body);
      debugPrint("USER LIST " + responseData.toString());
      adminProfileList.clear();
      adminProfileList.add(responseData.user);
      // debugPrint('Response: ${response.body}');
      return adminProfileList;
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