import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/Controller/User_Controller/adminList_controller.dart';
import 'package:http/http.dart' as http;
import 'package:jewellery_user/Models/file_model.dart';
import '../Common/snackbar.dart';
import '../ConstFile/constApi.dart';
import '../ConstFile/constPreferences.dart';
import 'home_Controller.dart';
import 'login_controller.dart';

class NewRegisterCon extends GetxController {
  HomeController homeController = Get.put(HomeController());
  LoginController loginController = Get.put(LoginController());
  AdminListController adminListController = Get.put(AdminListController());
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cPassword = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController reference = TextEditingController();

  RxBool isHidden = true.obs;
  RxBool isLoading = false.obs;
  RxList<FileElement> imgList = <FileElement>[].obs;
  var filePath;

  void clearController() {
    firstName.clear();
    lastName.clear();
    password.clear();
    cPassword.clear();
    address.clear();
    mobile.clear();
    reference.clear();
  }


  void uploadFile(File image) async {
    var url = Uri.parse(ConstApi.fileUpload);
    var file = File(image.path);
    var directory = 'UserProfile';

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
        // var filePath = json.decode(responseBody);
        debugPrint(imgList.toString());
        // Extract and store the filePath value
        filePath = imgList[0].path.toString();
        debugPrint("File Path "+filePath);


      } else {
        debugPrint('Failed to upload file. Status code: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error uploading file: $error');
    }
    isLoading.value = false;
  }



  Future<void> userRegister(String firstName, String lastName, String password,
      String mobileNumber, String address, String referenceName) async {
    String? token = await ConstPreferences().getToken();
    debugPrint("Token : " + token.toString());

    debugPrint("Device id : ${loginController.deviceId}");
    Map<String, dynamic> requestData = {
      "firstName": firstName,
      "lastName": lastName,
      "password": password,
      "mobileNumber": mobileNumber,
      "address": address,
      "referenceName": referenceName,
      "ProfileImage" : filePath.toString(),
      "DeviceId": ""
    };

    debugPrint("Request Data : " + requestData.toString());

    try {
      final http.Response response =
          await http.post(Uri.parse(ConstApi.newUser),
              headers: <String, String>{
                'Content-Type': 'application/json',
              },
              body: jsonEncode(requestData));

      if (response.statusCode == 201) {
        debugPrint('API call successful');
        debugPrint('Response: ${response.body}');
        Utils().toastMessage("Register Successful");
        clearController();
        homeController.loading.value = false;
        adminListController.adminList.clear();
        adminListController.pageIndex = 0;
        adminListController.pageSize  = 10;
        adminListController.loadProducts();

        Get.back();
      } else {
        homeController.loading.value = false;

        debugPrint('Error: ${response.reasonPhrase}');
        Utils().errorsnackBar(response.body.toString(), '');
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

    homeController.loading.value = false;
  }
}
