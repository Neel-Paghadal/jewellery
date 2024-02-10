import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:jewellery_user/Common/snackbar.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:jewellery_user/ConstFile/constApi.dart';
import 'package:jewellery_user/ConstFile/constPreferences.dart';
import 'package:jewellery_user/Models/dashboard_model.dart';

class HomeController extends GetxController {
  RxBool loading = false.obs;
  RxBool loadingSec = false.obs;
  RxList<Order> homeList = <Order>[].obs;
  RxBool isLoaderShow = false.obs;
  RxBool isShow = false.obs;
  // ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    checkUser();
  }

  int pageIndex = 0;
  int pageSize = 6;
  RxBool loadingPage = false.obs;


  Future<void> handleRefresh() async {
    pageIndex = 1;
    pageSize = 6;

    homeList.clear();
    getOrderCall(
      pageIndex,
      pageSize,
    );
    debugPrint("ScreenRefresh");
    return await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> loadProducts() async {
    loadingPage.value = true;

    pageIndex++;

    debugPrint("Page Order index$pageIndex");
    try {
      final RxList<Order> products = await getOrderCall(
        pageIndex,
        pageSize,
      );
        homeList.addAll(products);
    } catch (e) {
      // Handle errors
      debugPrint('Error loading products: $e');
    } finally {
      loadingPage.value = false;
    }
  }












  void checkUser() async {
    var role = await ConstPreferences().getRole();
    debugPrint("Role : $role");
    if (role == 'Admin') {
    } else if (role == 'SuperAdmin') {
      isShow.value = true;
    }
  }

  getOrderCall(int pageIndex, int pageSize) async {
    if(homeList.isEmpty){
      isLoaderShow.value = true;
    }else{
      isLoaderShow.value = false;
    }
    String? token = await ConstPreferences().getToken();
    debugPrint(token);

    // Set up headers with the token
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
        Uri.parse("http://208.64.33.118:8558/api/Order/Orders?PageNumber=$pageIndex&PageSize=$pageSize"),
        headers: headers);
    if (response.statusCode == 200) {
      isLoaderShow.value = false;
      final responseData = dashboardFromJson(response.body);
      debugPrint("HOME LIST " + responseData.toString());
      homeList.addAll(responseData.orders);
      debugPrint('Response: ${response.body}');
      // Process the data as needed
    } else {
      isLoaderShow.value = false;
      // Error in API call
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error body: ${response.body}');
    }
    if(response.statusCode == 401){
      Utils().toastMessage("Please Relogin Account");
      ConstPreferences().clearPreferences();
      SystemNavigator.pop();
    }
    isLoaderShow.value = false;
  }

  // getOrderCall(int pageIndex, int pageSize) async {
  //   String? token = await ConstPreferences().getToken();
  //   debugPrint(token);
  //
  //   // Set up headers with the token
  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $token',
  //   };
  //
  //
  //   final response =  await http.get(Uri.parse("http://208.64.33.118:8558/api/Order/Orders?PageNumber=$pageIndex&PageSize=$pageSize"),headers: headers);
  //   if (response.statusCode == 200) {
  //     final responseData = dashboardFromJson(response.body);
  //     debugPrint("HOME LIST "+responseData.toString());
  //     homeList.clear();
  //     homeList.addAll(responseData.orders);
  //     // Successful API call
  //     debugPrint("HOME LIST "+homeList[0].name.toString());
  //     debugPrint("HOME LIST "+homeList[1].name.toString());
  //
  //     debugPrint('Response: ${response.body}');
  //     // Process the data as needed
  //   } else {
  //     // Error in API call
  //     debugPrint('Error: ${response.statusCode}');
  //     debugPrint('Error body: ${response.body}');
  //   }
  // }
}
