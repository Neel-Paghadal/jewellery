import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/Common/snackbar.dart';
import 'package:jewellery_user/ConstFile/constPreferences.dart';
import 'package:http/http.dart' as http;
import '../Models/product_detail_model.dart';
import '../Screen/productdetail.dart';

class ProductController extends GetxController {

  TextEditingController designT = TextEditingController();
  TextEditingController partyT = TextEditingController();
  TextEditingController caratT = TextEditingController();
  TextEditingController weightT = TextEditingController();
  TextEditingController descripT = TextEditingController();
  TextEditingController createDateController = TextEditingController();
  TextEditingController deliveryDateController = TextEditingController();
  RxList<Order> productDetail = <Order>[].obs;

  var startDate;
  var delviveryDate;


  getProductDetailCall(String id) async {
    String? token = await ConstPreferences().getToken();
    debugPrint(token);

    // Set up headers with the token
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
        Uri.parse("http://208.64.33.118:8558/api/Order/GetOrderDetails?orderId=$id"),
        headers: headers);
    if (response.statusCode == 200) {
      debugPrint(response.body);
      final responseData = productDetailFromJson(response.body);
      debugPrint("HOME LIST " + responseData.toString());
      Get.to(const ProductDetailScreen());
      productDetail.clear();
      productDetail.add(responseData.order);
      designT.text = productDetail[0].name;
      partyT.text = productDetail[0].party;
      caratT.text = productDetail[0].carat.toString();
      weightT.text = productDetail[0].weight.toString();
      createDateController.text = productDetail[0].dateCreated.toString();
      deliveryDateController.text = productDetail[0].deliveryDate.toString();
      descripT.text = productDetail[0].description.toString();


      // debugPrint("HOME LIST " + userList[0].userName.toString());

      debugPrint('Response: ${response.body}');
      // Process the data as needed
    } else {
      // Error in API call.
      Utils().toastMessage(response.body);
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error body: ${response.body}');
    }
  }
















}