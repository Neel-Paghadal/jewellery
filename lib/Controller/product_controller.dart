import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/Common/snackbar.dart';
import 'package:jewellery_user/ConstFile/constApi.dart';
import 'package:jewellery_user/ConstFile/constPreferences.dart';
import 'package:http/http.dart' as http;
import 'package:jewellery_user/Controller/home_Controller.dart';
import 'package:jewellery_user/Screen/home.dart';
import '../Models/file_model.dart';
import '../Models/productDetailAdmin_model.dart';

class ProductController extends GetxController {
  HomeController homeController = Get.put(HomeController());
  TextEditingController designT = TextEditingController();
  TextEditingController partyT = TextEditingController();
  TextEditingController caratT = TextEditingController();
  TextEditingController weightT = TextEditingController();
  TextEditingController descripT = TextEditingController();
  TextEditingController createDateController = TextEditingController();
  TextEditingController deliveryDateController = TextEditingController();

  void clearController() {
    designT.clear();
    partyT.clear();
    caratT.clear();
    weightT.clear();
    descripT.clear();
    createDateController.clear();
    deliveryDateController.clear();
    imgList.clear();
    imgListMulti.clear();
  }


  RxList<Order> productDetail = <Order>[].obs;
  RxList<FileElement> imgList = <FileElement>[].obs;
  RxList<FileElement> imgListMulti = <FileElement>[].obs;
  List<File> imageList = [];

  var startDate;
  var delviveryDate;

  int? productIndex;

  var filePath;

  RxBool isLoading = false.obs;
  RxBool isLoadingSec = false.obs;
  RxBool isFilterApplyed = false.obs;

  getProductDetailCall(String id) async {
    String? token = await ConstPreferences().getToken();
    debugPrint(token);
    productDetail.clear();

    // Set up headers with the token
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
        Uri.parse(
            "http://208.64.33.118:8558/api/Order/GetOrderDetails?orderId=$id"),
        headers: headers);
    if (response.statusCode == 200) {
      debugPrint(response.body);
      final responseData = productDetailFromJson(response.body);
      debugPrint("HOME LIST $responseData");
      // Get.to(const ProductDetailScreen());
      productDetail.clear();
      productDetail.add(responseData.order);
      designT.text = productDetail[0].name;
      partyT.text = productDetail[0].party;
      caratT.text = productDetail[0].carat.toString();
      weightT.text = productDetail[0].weight.toString();
      createDateController.text = productDetail[0].dateCreated.toString();
      deliveryDateController.text = productDetail[0].deliveryDate.toString();
      descripT.text = productDetail[0].description.toString();

      debugPrint('Response: ${response.body}');
      // Process the data as needed
    } else {
      // Error in API call.
      Utils().toastMessage(response.body);
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error body: ${response.body}');
    }
    if(response.statusCode == 401 || response.statusCode == 403){
      Utils().toastMessage("Please Relogin Account");
      ConstPreferences().clearPreferences();
      SystemNavigator.pop();
    }
  }

  List<String> strings = [];
  List<String> modifiedStrings = [];
  void replaceString(String imageUrl) {
    strings.add(imageUrl);
    // Common string to remove
    String commonStringToRemove = "http://208.64.33.118:8558/Files/";

    // Remove common string from each element in the list
    modifiedStrings = strings.map((str) {
      return str.replaceAll(commonStringToRemove, '');
    }).toList();

    // Print the modified list of strings
    modifiedStrings.forEach(print);
    debugPrint(modifiedStrings.toString());
  }

  void passOldImage() {
    productDetail[0].image =
        "http://208.64.33.118:8558/Files/${modifiedStrings[0]}";
    debugPrint(productDetail[0].image);
    isLoading.value = false;
  }

  void uploadFile(File image) async {
    isLoading.value = true;
    var url = Uri.parse('http://208.64.33.118:8558/api/File/Upload');
    var file = File(image.path);
    var directory = 'Test';

    var request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('files', file.path))
      ..fields['Directory'] = directory;

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        debugPrint('File uploaded successfully');
        debugPrint(response.toString());
        debugPrint('Response: $responseBody');
        final responseData = fileUploadFromJson(responseBody);
        imgList.addAll(responseData.files);
        var jsonResponse = json.decode(responseBody);
        // var filePath = json.decode(responseBody);
        debugPrint(imgList.toString());
        // Extract and store the filePath value
        filePath = jsonResponse['filePath'];
        replaceString(productDetail[0].image);
        productDetail[0].image = '';
        productDetail[0].image =
            "http://208.64.33.118:8558/Files/${imgList[0].path}";
        filePath = imgList[0].path;
        debugPrint("File Path " + filePath);
      } else {
        debugPrint(
            'Failed to upload file. Status code: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error uploading file: $error');
    }
    isLoading.value = false;
  }

  void uploadFileMulti(List<File> images) async {
    var url = Uri.parse('http://208.64.33.118:8558/api/File/Upload');
    var directory = 'Test';
    var request = http.MultipartRequest('POST', url);

    for (var image in images) {
      var file = File(image.path);
      request
        ..files.add(await http.MultipartFile.fromPath('files', file.path))
        ..fields['Directory'] = directory;
    }

    debugPrint("REQUEST$request");

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        isLoadingSec.value = false;
        debugPrint('Files uploaded successfully');
        debugPrint(response.toString());
        debugPrint('Response: $responseBody');
        final responseData = fileUploadFromJson(responseBody);
        imgListMulti.clear();
        imageList.clear();
        imgListMulti.addAll(responseData.files);
        List<String> seenPaths = [];

        var jsonResponse = json.decode(responseBody);
        // var filePath = json.decode(responseBody);
        debugPrint(imgListMulti.toString());
        // Extract and store the filePath value

        for (int i = 0; i <= imgListMulti.length; i++) {
          productDetail[0].orderImages.add(OrderImage(
              id: 'id',
              path: imgListMulti[i].path,
              dateCreated: 'dateCreated'));
        }

        filePath = jsonResponse['filePath'];
        debugPrint("File Path " + filePath);
      } else {
        debugPrint(
            'Failed to upload file. Status code: ${response.statusCode}');
        Utils().toastMessage("Failed to upload file");
      }
    } catch (error) {
      debugPrint('Error uploading file: $error');
    }
    isLoadingSec.value = false;
  }

  Future<void> updateProductCall(String id, String name, String party,
      double carat, double weight, String date, String description) async {
    String? token = await ConstPreferences().getToken();
    debugPrint(token);
    // for(int i = 0 ; i<= productDetail[0].orderImages.length; i++){
    imgListMulti.addAll(productDetail[0]
        .orderImages
        .map((image) => FileElement(path: image.path)));

    if (imgList.isEmpty) {
      replaceString(productDetail[0].image);
      imgList.add(FileElement(path: modifiedStrings[0].toString()));
      debugPrint(imgList.toString());
    }
    imgListMulti.forEach((fileElement) {
      fileElement.path =
          fileElement.path.replaceAll("http://208.64.33.118:8558/Files/", "");
    });

    List<String> seenPaths = [];

    for (int i = imgListMulti.length - 1; i >= 0; i--) {
      String path = imgListMulti[i].path;
      if (seenPaths.contains(path)) {
        imgListMulti.removeAt(i);
      } else {
        seenPaths.add(path);
      }
    }

    // for (var item in myList) {
    //   String path = item['path'];
    //   if (!seenPaths.contains(path)) {
    //     seenPaths.add(path);
    //     resultList.add(item);
    //   } else {
    //     seenPaths.remove(path); // Remove the seen path from the list to ensure only one occurrence is removed
    //   }
    // }
    // debugPrint(imgListMulti[i].toString());
    // }

    debugPrint(imgListMulti.toString());

    Map<String, dynamic> requestData = {
      "id": id,
      "name": name,
      "party": party,
      "carat": carat,
      "weight": weight,
      "deliveryDate": date,
      "description": description,
      "image": imgList[0].path,
      "orderImages": imgListMulti
    };

    debugPrint(imgListMulti.toString());

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    debugPrint(jsonEncode(requestData));

    try {
      final http.Response response = await http.post(
          Uri.parse(ConstApi.updateOrder),
          headers: headers,
          body: jsonEncode(requestData));

      if (response.statusCode == 200) {
        debugPrint('API call successful');
        debugPrint('Response: ${response.body}');
        // homeController.homeList[productIndex!].id = id;
        // homeController.homeList[productIndex!].image = "http://208.64.33.118:8558/Files/${imgList[0].path}";
        // homeController.homeList[productIndex!].name = name;
        homeController.homeList.clear();
        homeController.pageIndex = 0;
        homeController.pageSize = 6;
        homeController.loadProducts();
        Get.to(() => HomeScreen());
        Utils().toastMessage(json.decode(response.body)['message']);
        // Utils().toastMessage("Order Successfull");

        // Utils().snackBar(response.body, '');
        clearController();
      } else {
        debugPrint('Error: ${response.reasonPhrase}');
        Utils().errorsnackBar(response.reasonPhrase.toString(), '');
      }
      if(response.statusCode == 401 || response.statusCode == 403){
        Utils().toastMessage("Please Relogin Account");
        ConstPreferences().clearPreferences();
        SystemNavigator.pop();
      }
    } catch (e) {
      debugPrint('Error: $e');
      Utils().errorsnackBar(e.toString(), '');
    }
    debugPrint("Request Data : $requestData");
    // homeController.loading.value = false;
  }
}
