import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jewellery_user/ConstFile/constApi.dart';
import 'package:jewellery_user/Controller/home_Controller.dart';
import 'package:jewellery_user/Screen/home.dart';
import '../Common/snackbar.dart';
import '../ConstFile/constPreferences.dart';
import '../Models/file_model.dart';

class OrderController extends GetxController{

  HomeController homeController = Get.put(HomeController());
  TextEditingController designT = TextEditingController();
  TextEditingController partyT = TextEditingController();
  TextEditingController caratT = TextEditingController();
  TextEditingController weightT = TextEditingController();
  TextEditingController descripT = TextEditingController();
  TextEditingController dateCon = TextEditingController();

  RxList<FileElement> imgList = <FileElement>[].obs;
  RxList<FileElement> imgListMulti = <FileElement>[].obs;

  RxBool isLoading = false.obs;
  RxBool isLoadingSec = false.obs;


  void clearController(){
    designT.clear();
    partyT.clear();
    caratT.clear();
    weightT.clear();
    descripT.clear();
    dateCon.clear();
    imgList.clear();
    imgListMulti.clear();
  }

  var filePath;
  void uploadFile(File image) async {
    var url = Uri.parse('http://208.64.33.118:8558/api/File/Upload');
    var file = File(image.path);
    var directory = 'Test';

    var request = http.MultipartRequest('POST', url)..files.add(await http.MultipartFile.fromPath('files', file.path))..fields['Directory'] = directory;

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
        filePath = imgList[0].path;
        debugPrint("File Path "+filePath);


      } else {
        debugPrint('Failed to upload file. Status code: ${response.statusCode}');
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
      request..files.add(await http.MultipartFile.fromPath('files', file.path))..fields['Directory'] = directory;
    }

    debugPrint("REQUEST"+ request.toString());

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
        imgListMulti.addAll(responseData.files);
        var jsonResponse = json.decode(responseBody);
        // var filePath = json.decode(responseBody);
        debugPrint(imgListMulti.toString());
        // Extract and store the filePath value
        filePath = jsonResponse['filePath'];
        debugPrint("File Path "+filePath);


      } else {
        debugPrint('Failed to upload file. Status code: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error uploading file: $error');
    }
    isLoadingSec.value = false;
  }




  Future<void> orderCall(String name,String party,double carat,double weight,String date,String description) async {

    String? token = await ConstPreferences().getToken();
    debugPrint(token);


    Map<String, dynamic> requestData = {
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

    // final Map<String, String> headers = {
    //   'Content-Type': 'application/json',
    // };
    // var requestBodyNew = await jsonEncode(requestData);


    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final http.Response response = await http.post(
          Uri.parse(ConstApi.order),
          headers: headers,
          body: jsonEncode(requestData));



      if (response.statusCode == 201) {
        debugPrint('API call successful');
        debugPrint('Response: ${response.body}');
        Utils().toastMessage("Order Successfull");

        // Utils().snackBar(response.body, '');
        Get.to(() => const HomeScreen());
        homeController.homeList.clear();
        clearController();
      } else {
        debugPrint('Error: ${response.reasonPhrase}');
        Utils().errorsnackBar(response.reasonPhrase.toString(), '');
      }
    } catch (e) {
      debugPrint('Error: $e');
      Utils().errorsnackBar(e.toString(), '');

    }
      debugPrint("Request Data : $requestData");
    homeController.loading.value = false;
  }


}