import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jewellery_user/Common/snackbar.dart';
import 'package:jewellery_user/ConstFile/constApi.dart';
import 'package:jewellery_user/Models/users_model.dart';
import 'package:http/http.dart' as http;
import '../ConstFile/constPreferences.dart';
import '../Models/userList_model.dart';
import 'home_Controller.dart';

class UserListController extends GetxController {
  HomeController homeController = Get.put(HomeController());
  TextEditingController reasonController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  String? orderId;
  String? userId;


  RxList<User> userList = <User>[].obs;
  RxList<UsersData> userListDrop = <UsersData>[].obs;
  TextEditingController notesCon = TextEditingController();

   RxBool isCall = false.obs;
  // Assign order to new user
  Future<void> assignOrder(String userId, String code, String notes, String orderId) async {
    String? token = await ConstPreferences().getToken();
    debugPrint(token);
    var url = Uri.parse(ConstApi.assignOrder);

    Map<String, String> requestBody = {
      "userId": userId.toString(),
      "Code": code.toString(),
      "notes": notes.toString(),
      "OrderId": orderId.toString(),
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    debugPrint("Request Body :$requestBody");

    try {
      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Successful API call
        var responseBody = json.decode(response.body);
        notesCon.clear();
        // homeController.homeList.clear();
        // Get.to(() => const HomeScreen());

        debugPrint('Response: $responseBody');
        Utils().toastMessage("Order assign Successfully");
      } else {
        // Failed API call
        debugPrint(
            'Failed to make API call. Status code: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
      }
    } catch (error) {
      debugPrint('Error making API call: $error');
    }
    homeController.loading.value = false;
    userListDrop.clear();
    userList.clear();
    getUserCall(orderId.toString());
  }


  // Assign order cancel
  Future<void> assignCancel(String id,String reason ) async {
    String? token = await ConstPreferences().getToken();
    debugPrint(token);
    var url = Uri.parse(ConstApi.orderCancel);

    Map<String, String> requestBody = {
      "Id":id,
      "Reason":reason
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    debugPrint("Request Body :$requestBody");

    try {
      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Successful API call
        var responseBody = json.decode(response.body);
        reasonController.clear();
        debugPrint('Response: $responseBody');
        Utils().toastMessage("Order Cancel Successfully");


      } else {
        // Failed API call
        debugPrint('Failed to make API call. Status code: ${response.statusCode}');
        Utils().toastMessage(response.body);
      }
      if(response.statusCode == 401 || response.statusCode == 403){
        Utils().toastMessage("Please Relogin Account");
        ConstPreferences().clearPreferences();
        SystemNavigator.pop();
      }

    } catch (error) {
      debugPrint('Error making API call: $error');
    }
    homeController.loading.value = false;
    userList.clear();
    getUserCall(orderId.toString());

  }

  // assignOrder Update Detail
  Future<void> assignUpdate(String id,String notes ) async {
    homeController.loadingSec.value = true;
    String? token = await ConstPreferences().getToken();
    debugPrint(token);
    var url = Uri.parse(ConstApi.updateAssignOrder);

    Map<String, String> requestBody = {
      "Id":id,
      "Notes": notes
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    debugPrint("Request Body :$requestBody");

    try {
      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Successful API call
        var responseBody = json.decode(response.body);
        reasonController.clear();
        debugPrint('Response: $responseBody');
        Utils().toastMessage("Update Successfully");


      } else {
        // Failed API call
        debugPrint('Failed to make API call. Status code: ${response.statusCode}');
        Utils().toastMessage(response.body);
      }
      if(response.statusCode == 401 || response.statusCode == 403){
        Utils().toastMessage("Please Relogin Account");
        ConstPreferences().clearPreferences();
        SystemNavigator.pop();
      }

    } catch (error) {
      debugPrint('Error making API call: $error');
    }
    homeController.loadingSec.value = false;
    userList.clear();
    getUserCall(orderId.toString());

  }

  // Assign order Complete
  Future<void> assignComplete(String id,) async {
    String? token = await ConstPreferences().getToken();
    debugPrint(token);
    var url = Uri.parse(ConstApi.orderComplete);

    Map<String, String> requestBody = {
      "Id":id,
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    debugPrint("Request Body :$requestBody");

    try {
      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Successful API call
        var responseBody = json.decode(response.body);
        reasonController.clear();
        debugPrint('Response: $responseBody');
        Utils().toastMessage("Order assign Successfully");
      } else {
        // Failed API call
        debugPrint(
            'Failed to make API call. Status code: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
        Utils().toastMessage(response.body);
      }
      if(response.statusCode == 401 || response.statusCode == 403){
        Utils().toastMessage("Please Relogin Account");
        ConstPreferences().clearPreferences();
        SystemNavigator.pop();
      }
    } catch (error) {
      debugPrint('Error making API call: $error');
    }
    userListDrop.clear();
    getUserDropCall(orderId.toString());
    userList.clear();
    getUserCall(orderId.toString());
    homeController.loading.value = false;
  }

 // getUserOrderList
  getUserCall(String id) async {
    isCall.value = true;
    String? token = await ConstPreferences().getToken();
    debugPrint(token);
    getUserDropCall(orderId.toString());
    // Set up headers with the token
    Map<String, String> headers = {
      // 'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
        Uri.parse(
            'http://208.64.33.118:8558/api/Order/GetOrderUsers?orderId=$id'),
        headers: headers);
    if (response.statusCode == 200) {
      debugPrint(response.body);
      final responseData = usersListFromJson(response.body);
      debugPrint("HOME LIST $responseData");
      userList.clear();
      userList.addAll(responseData.users);
      debugPrint('Response: ${response.body}');
      isCall.value = false;
      return userList;
      // Process the data as needed
    } else {
      // Error in API call
      isCall.value = false;

      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error body: ${response.body}');
    }
    if(response.statusCode == 401 || response.statusCode == 403){
      Utils().toastMessage("Please Relogin Account");
      ConstPreferences().clearPreferences();
      SystemNavigator.pop();
    }
    isCall.value = false;
    getUserDropCall(orderId.toString());
  }

  // get user dropdown call
  getUserDropCall(String id) async {

    String? token = await ConstPreferences().getToken();
    debugPrint(token);

    // Set up headers with the token
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
        Uri.parse("http://208.64.33.118:8558/api/Order/Users?orderId=$id"),
        headers: headers);
    if (response.statusCode == 200) {
      debugPrint(response.body);
      final responseData = usersFromJson(response.body);
      debugPrint("HOME LIST $responseData");
      userListDrop.clear();
      userListDrop.addAll(responseData.users);
      if(userListDrop.isEmpty){
        Utils().toastMessage("No Users Found");
      }
      debugPrint('Response: ${response.body}');
      // Process the data as needed
    } else {
      // Error in API call
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error body: ${response.body}');
    }
    if(response.statusCode == 401 || response.statusCode == 403){
      Utils().toastMessage("Please Relogin Account");
      ConstPreferences().clearPreferences();
      SystemNavigator.pop();
    }
  }


}
