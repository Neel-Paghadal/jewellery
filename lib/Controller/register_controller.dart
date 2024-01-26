import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jewellery_user/Common/snackbar.dart';
import 'package:jewellery_user/Models/file_model.dart';
import 'package:jewellery_user/Screen/auth_screen/login.dart';
import '../ConstFile/constApi.dart';
import '../ConstFile/constPreferences.dart';
import 'home_Controller.dart';
import 'login_controller.dart';


class RegisterController extends GetxController{
  HomeController homeController = Get.put(HomeController());
  LoginController loginController = Get.put(LoginController());

  var firstNames;
  var lastNames;
  var pass;
  var phone;
  var addr;
  var ref;

  RxBool isLoading = false.obs;
  //register screen controller
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cPassword = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController reference = TextEditingController();

  //document screen controller
  TextEditingController bankName = TextEditingController();
  TextEditingController accNo = TextEditingController();
  TextEditingController ifsc = TextEditingController();
  TextEditingController branchName = TextEditingController();
  TextEditingController accHolName = TextEditingController();


  RxList<FileElement> imgList = <FileElement>[].obs;



  void clearController(){
    firstName.clear();
    lastName.clear();
    password.clear();
    cPassword.clear();
    address.clear();
    mobile.clear();
    reference.clear();


    accHolName.clear();
    bankName.clear();
    ifsc.clear();
    branchName.clear();
    accNo.clear();

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




  Future<void> userRegister(String firstName,String lastName,String password,String mobileNumber,String address,
      String referenceName,String name,String accountNumber,String ifsc,String brachName,String accountHolderName
      ) async {
    debugPrint("Device id : ${loginController.deviceId}");
    Map<String, dynamic> requestData = {
      "firstName": firstName.toString(),
      "lastName": lastName.toString(),
      "password": password.toString(),
      "mobileNumber": mobileNumber.toString(),
      "address": address.toString(),
      "referenceName": referenceName.toString(),
      "DeviceId": loginController.deviceId.toString(),
      "userDocuments": [
        {
          "document": filePath.toString(),
          "documentType": 1
        }
      ],
      "bankDetails": {
        "name": name.toString(),
        "accountNumber": accountNumber.toString(),
        "ifsc": ifsc.toString(),
        "brachName": brachName.toString(),
        "accountHolderName": accountHolderName.toString()
      }
    };

    // final Map<String, String> headers = {
    //   'Content-Type': 'application/json',
    // };
    // var requestBodyNew = await jsonEncode(requestData);

    try {
      final http.Response response = await http.post(
          Uri.parse(ConstApi.userRegister),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(requestData));



      if (response.statusCode == 201) {
        debugPrint('API call successful');
        debugPrint('Response: ${response.body}');
        Get.to(()=> const LoginScreen());
        Utils().toastMessage("Register Successfull");

        // Utils().snackBar(response.body, '');
      } else {
        debugPrint('Error: ${response.reasonPhrase}');
        Utils().errorsnackBar(response.reasonPhrase.toString(), '');
      }
    } catch (e) {
      debugPrint('Error: $e');
      Utils().errorsnackBar(e.toString(), '');

    }

    homeController.loading.value = false;
  }









  // File upload call
  //
  // Future<void> UpdateUserProfileApiCall(File imageFile) async {
  //   var url = Uri.parse('http://208.64.33.118:8558/api/File/Upload');
  //
  //   var request = http.MultipartRequest('POST',Uri.parse(url.toString()),
  //   );
  //
  //
  //
  //
  //   var contentType = MediaType.parse(lookupMimeType(imageFile.path) ?? 'image/jpeg');
  //   var part = await http.MultipartFile.fromPath('file', imageFile.path,contentType: contentType,);
  //   request.files.add(part);
  //
  //   debugPrint("request: " + request.toString());
  //   var res = await request.send();
  //   var responseBody = await res.stream.bytesToString();
  //
  //   debugPrint("This is response:" + res.toString());
  //   if (res.statusCode == 200) {
  //     debugPrint('Response: $responseBody');
  //     Fluttertoast.showToast(
  //       msg: 'Profile Updated Succefully!!!',
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       backgroundColor: Colors.black,
  //       textColor: Colors.white,
  //     );
  //
  //   } else {
  //     if (res.statusCode == 500) {
  //       Fluttertoast.showToast(
  //         msg: "Internal Server Error",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         backgroundColor: Colors.black,
  //         textColor: Colors.white,
  //       );
  //     } else {
  //       Fluttertoast.showToast(
  //         msg:
  //         'Please Update Your Profile Picture!!!' /*: errorMsg.toString()*/,
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         backgroundColor: Colors.black,
  //         textColor: Colors.white,
  //       );
  //     }
  //   }
  // }

}