import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jewellery_user/Common/snackbar.dart';
import 'package:jewellery_user/ConstFile/constApi.dart';
import 'package:jewellery_user/Models/users_model.dart';
import 'package:http/http.dart' as http;
import 'package:jewellery_user/Screen/home.dart';
import '../ConstFile/constPreferences.dart';
import '../Models/userList_model.dart';
import '../Screen/user_list.dart';
import 'home_Controller.dart';

class UserListController extends GetxController {
  HomeController homeController = Get.put(HomeController());

  String? orderId;
  String? userId;

  RxList<User> userList = <User>[].obs;
  RxList<UsersData> userListDrop = <UsersData>[].obs;
  TextEditingController notesCon = TextEditingController();

  Future<void> assignOrder(
      String userId, String code, String notes, String orderId) async {
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
        Get.to(() => const HomeScreen());
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
  }

  getUserCall(String id) async {
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
      // Get.to(() => const UserListScreen());
      userList.clear();
      userList.addAll(responseData.users);
      return userList;
      debugPrint("HOME LIST ${userList[0].userName}");

      debugPrint('Response: ${response.body}');
      // Process the data as needed
    } else {
      // Error in API call
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error body: ${response.body}');
    }
    getUserDropCall(orderId.toString());
  }

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
      debugPrint("HOME LIST ${userList[0].userName}");

      debugPrint('Response: ${response.body}');
      // Process the data as needed
    } else {
      // Error in API call
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error body: ${response.body}');
    }
  }
}
