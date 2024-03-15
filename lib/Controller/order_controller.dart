import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jewellery_user/ConstFile/constApi.dart';
import 'package:jewellery_user/Controller/home_Controller.dart';
import 'package:jewellery_user/Screen/Admin%20Screen/home.dart';
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

  File? imageNotes;

  void clearController(){
    designT.clear();
    partyT.clear();
    caratT.clear();
    weightT.clear();
    descripT.clear();
    dateCon.clear();
    imgList.clear();
    imgListMulti.clear();
    isLoading.value = false;
    isLoadingSec.value = false;
  }

  var filePath;

  RxDouble progressed = 0.0.obs;


  void uploadFile(File image) async {
    var url = Uri.parse(ConstApi.fileUpload);
    var file = File(image.path);
    var directory = 'OrderImages';

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
        filePath = imgList[0].path;
        debugPrint("File Path "+filePath);


      } else {
        debugPrint('Failed to upload file. Status code: ${response.statusCode}');
        Utils().snackBar("Failed", "Failed to upload file");
      }
    } catch (error) {
      debugPrint('Error uploading file: $error');
      Utils().snackBar("Failed", "$error");
    }
    isLoading.value = false;
  }

  void uploadFileMulti(List<File> images) async {
    var url = Uri.parse(ConstApi.fileUpload);
    var directory = 'OrderImages';
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
        Utils().toastMessage("Order Successful");

        // Utils().snackBar(response.body, '');
        clearController();
        homeController.homeList.clear();
        homeController.pageIndex = 0;
        homeController.pageSize = 6;
        homeController.loadProducts();
        Get.to(() => HomeScreen());
        imgList.clear();
        imgListMulti.clear();
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
    homeController.loading.value = false;
  }
}









// import 'dart:convert';
// import 'dart:io';
// import 'package:chewie/chewie.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:jewellery_user/ConstFile/constApi.dart';
// import 'package:jewellery_user/Controller/home_Controller.dart';
// import 'package:jewellery_user/Screen/Admin%20Screen/home.dart';
// import 'package:video_player/video_player.dart';
// import '../Common/snackbar.dart';
// import '../ConstFile/constPreferences.dart';
// import '../Models/file_model.dart';
//
// class OrderController extends GetxController {
//   VideoPlayerController? controller;
//   ChewieController? chewieController;
//
//   HomeController homeController = Get.put(HomeController());
//   TextEditingController designT = TextEditingController();
//   TextEditingController partyT = TextEditingController();
//   TextEditingController caratT = TextEditingController();
//   TextEditingController weightT = TextEditingController();
//   TextEditingController descripT = TextEditingController();
//   TextEditingController dateCon = TextEditingController();
//
//   RxList<FileElement> imgList = <FileElement>[].obs;
//   // RxList<FileElement> imgListMulti = <FileElement>[].obs;
//
//
//   List<File> subimageList = [];
//
//
//   RxBool isLoading = true.obs;
//   RxBool isLoadingSec = true.obs;
//
//   File? imageNotes;
//   File? imageNotesLocal;
//
//   RxDouble progress = 0.0.obs;
//
//
//   void clearController() {
//     designT.clear();
//     partyT.clear();
//     caratT.clear();
//     weightT.clear();
//     descripT.clear();
//     dateCon.clear();
//     imgList.clear();
//     subimageList.clear();
//     isLoading.value = false;
//     isLoadingSec.value = false;
//   }
//
//   var filePath;
//
//   RxDouble progressed = 0.0.obs;
//
//   Future<void> createNewOrder(String name, String party, double carat, double weight, String deliveryDate, String description,
//       File image, List<File> subImages) async {
//     final String? token = await ConstPreferences().getToken(); // Your JWT token
//     var file = File(image.path);
//     // Prepare the data to be sent in the request body
//     var request = http.MultipartRequest('POST', Uri.parse(ConstApi.newOrder))
//       ..headers.addAll({'Authorization': 'Bearer $token'})
//       ..fields['Name'] = name
//       ..fields['Party'] = party
//       ..fields['Carat'] = carat.toString()
//       ..fields['Weight'] = weight.toString()
//       ..fields['DeliveryDate'] = deliveryDate
//       ..fields['Description'] = description;
//
//     // Add the main image
//     request.files.add(await http.MultipartFile.fromPath('Image',file.path));
//
//     // Add each subimage file to the request
//     for (File path in subImages) {
//       request.files.add(await http.MultipartFile.fromPath('Submages', path.path));
//     }
//
//     debugPrint(request.toString());
//     try {
//       // Send the request
//       var response = await request.send();
//       final totalBytes = response.contentLength;
//       int bytesUploaded = 0;
//       response.stream.listen(
//             (chunk) {
//           // Calculate progress
//           bytesUploaded += chunk.length;
//           final progres = (bytesUploaded / totalBytes!);
//
//           // Update progress state
//           // setState(() {
//             progress.value = progres;
//           // });
//         },
//         onDone: () {
//           // Upload complete
//         },
//         onError: (error) {
//           // Handle error
//           print('Upload Error: $error');
//         },
//       );
//       if (response.statusCode == 201) {
//         // Successful request
//         debugPrint(response.stream.bytesToString().toString());
//         print('New order created successfully');
//       } else {
//         // Handle errors
//         debugPrint(response.stream.bytesToString().toString());
//         print(
//             'Failed to create new order. Status code: ${response.statusCode}');
//         print('Response body: ${await response.stream.bytesToString()}');
//       }
//     } catch (e) {
//       print('Error creating new order: $e');
//     }
//   }
//
//
//
//   // void uploadFile(File image) async {
//   //   var url = Uri.parse(ConstApi.fileUpload);
//   //   var file = File(image.path);
//   //   var directory = 'OrderImages';
//   //
//   //   var request = http.MultipartRequest('POST', url)
//   //     ..files.add(await http.MultipartFile.fromPath('files', file.path))
//   //     ..fields['Directory'] = directory;
//   //
//   //   try {
//   //     var response = await request.send();
//   //     var responseBody = await response.stream.bytesToString();
//   //     if (response.statusCode == 200) {
//   //       debugPrint('File uploaded successfully');
//   //       debugPrint(response.toString());
//   //       debugPrint('Response: $responseBody');
//   //       final responseData = fileUploadFromJson(responseBody);
//   //       imgList.addAll(responseData.files);
//   //       // var filePath = json.decode(responseBody);
//   //       debugPrint(imgList.toString());
//   //       // Extract and store the filePath value
//   //       filePath = imgList[0].path;
//   //       debugPrint("File Path " + filePath);
//   //     } else {
//   //       debugPrint(
//   //           'Failed to upload file. Status code: ${response.statusCode}');
//   //       Utils().snackBar("Failed", "Failed to upload file");
//   //     }
//   //   } catch (error) {
//   //     debugPrint('Error uploading file: $error');
//   //     Utils().snackBar("Failed", "$error");
//   //   }
//   //   isLoading.value = false;
//   // }
//
//   // void uploadFileMulti(List<File> images) async {
//   //   var url = Uri.parse(ConstApi.fileUpload);
//   //   var directory = 'OrderImages';
//   //   var request = http.MultipartRequest('POST', url);
//   //
//   //   for (var image in images) {
//   //     var file = File(image.path);
//   //     request..files.add(await http.MultipartFile.fromPath('files', file.path))..fields['Directory'] = directory;
//   //   }
//   //
//   //   debugPrint("REQUEST" + request.toString());
//   //
//   //   try {
//   //     var response = await request.send();
//   //     var responseBody = await response.stream.bytesToString();
//   //     if (response.statusCode == 200) {
//   //       isLoadingSec.value = false;
//   //       debugPrint('Files uploaded successfully');
//   //       debugPrint(response.toString());
//   //       debugPrint('Response: $responseBody');
//   //       final responseData = fileUploadFromJson(responseBody);
//   //       orderController.subimageList.clear();
//   //       imgListMulti.addAll(responseData.files);
//   //       var jsonResponse = json.decode(responseBody);
//   //       // var filePath = json.decode(responseBody);
//   //       debugPrint(imgListMulti.toString());
//   //       // Extract and store the filePath value
//   //       filePath = jsonResponse['filePath'];
//   //       debugPrint("File Path " + filePath);
//   //     } else {
//   //       debugPrint(
//   //           'Failed to upload file. Status code: ${response.statusCode}');
//   //     }
//   //   } catch (error) {
//   //     debugPrint('Error uploading file: $error');
//   //   }
//   //   isLoadingSec.value = false;
//   // }
//
//
//   // Future<void> orderCall(String name, String party, double carat, double weight,
//   //     String date, String description) async {
//   //   String? token = await ConstPreferences().getToken();
//   //   debugPrint(token);
//   //
//   //   Map<String, dynamic> requestData = {
//   //     "name": name,
//   //     "party": party,
//   //     "carat": carat,
//   //     "weight": weight,
//   //     "deliveryDate": date,
//   //     "description": description,
//   //     "image": imgList[0].path,
//   //     "orderImages": imgListMulti
//   //   };
//   //
//   //   debugPrint(imgListMulti.toString());
//   //
//   //   // final Map<String, String> headers = {
//   //   //   'Content-Type': 'application/json',
//   //   // };
//   //   // var requestBodyNew = await jsonEncode(requestData);
//   //
//   //   Map<String, String> headers = {
//   //     'Content-Type': 'application/json',
//   //     'Authorization': 'Bearer $token',
//   //   };
//   //
//   //   try {
//   //     final http.Response response = await http.post(Uri.parse(ConstApi.order),
//   //         headers: headers, body: jsonEncode(requestData));
//   //
//   //     if (response.statusCode == 201) {
//   //       debugPrint('API call successful');
//   //       debugPrint('Response: ${response.body}');
//   //       Utils().toastMessage("Order Successful");
//   //
//   //       // Utils().snackBar(response.body, '');
//   //       clearController();
//   //       homeController.homeList.clear();
//   //       homeController.pageIndex = 0;
//   //       homeController.pageSize = 6;
//   //       homeController.loadProducts();
//   //       Get.to(() => HomeScreen());
//   //       imgList.clear();
//   //       imgListMulti.clear();
//   //     } else {
//   //       debugPrint('Error: ${response.reasonPhrase}');
//   //       Utils().errorsnackBar(response.reasonPhrase.toString(), '');
//   //     }
//   //     if (response.statusCode == 401 || response.statusCode == 403) {
//   //       Utils().toastMessage("Please Relogin Account");
//   //       ConstPreferences().clearPreferences();
//   //       SystemNavigator.pop();
//   //     }
//   //   } catch (e) {
//   //     debugPrint('Error: $e');
//   //     Utils().errorsnackBar(e.toString(), '');
//   //   }
//   //   debugPrint("Request Data : $requestData");
//   //   homeController.loading.value = false;
//   // }
// }
