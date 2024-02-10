import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jewellery_user/Common/bottom_button_widget.dart';
import 'package:jewellery_user/ConstFile/constColors.dart';
import 'package:jewellery_user/Controller/home_Controller.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Common/snackbar.dart';
import '../../ConstFile/constFonts.dart';
import '../../Controller/register_controller.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  RegisterController registerController = Get.put(RegisterController());
  HomeController homeController = Get.put(HomeController());
  File? imageNotes;

  String? userProfileImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    registerController.imgList.clear();
  }


  Future<void> _checkPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future getImageCamera() async {
    _checkPermission();

    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;


    final imageTemporary = File(image.path);
    setState(() {
      imageNotes = imageTemporary;
      registerController.isLoading.value = true;
      registerController.uploadFile(imageNotes!);
      debugPrint(imageNotes.toString());
    });
  }

  Future getImageGallery() async {
    _checkPermission();

    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final imageTemporary = File(image.path);
    setState(() {
      imageNotes = imageTemporary;
    registerController.isLoading.value = true;
      registerController.uploadFile(imageNotes!);

      debugPrint(imageNotes.toString());
    });
  }

  final _formKey = GlobalKey<FormState>();
  final ifscVal = RegExp(r"^[A-Z]{4}[0]{1}[0-9A-Z}[6]");
  bool ifscCodeValidate({required String content}) {
    if (content.length != 11) {
      return false;
    } else {
      return RegExp(r"^[A-Z]{4}[0]{1}[0-9A-Z}[6]").hasMatch(content);
    }
  }

    @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ConstColour.bgColor,
      appBar: AppBar(
        backgroundColor: ConstColour.bgColor,
        centerTitle: true,
        title: Text("Bank Details",
            style: TextStyle(
                color: Colors.white,
                fontFamily: ConstFont.poppinsRegular,
                fontSize: 22,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis),),
          leading: IconButton(
              tooltip: "Back",
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios),
              color: ConstColour.primaryColor),

      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: ScrollController(),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              Padding(
                padding: EdgeInsets.only(
                    left: deviceWidth * 0.03, right: deviceWidth * 0.03),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.multiline,
                  autocorrect: true,
                  controller: registerController.bankName,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Bankname";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ConstColour.textFieldBorder),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ConstColour.textFieldBorder),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ConstColour.textFieldBorder),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: ConstColour.textFieldBorder),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ConstColour.textFieldBorder),
                    ),
                    errorStyle: TextStyle(color: ConstColour.errorHint),
                    border: InputBorder.none,
                    filled: true,
                    hintText: "Enter Bank",
                    hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontFamily: ConstFont.poppinsRegular,
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis),
                  ),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: ConstFont.poppinsRegular),
                ),
              ),
              Divider(height: deviceHeight * 0.01),
              Padding(
                padding: EdgeInsets.only(
                    left: deviceWidth * 0.03, right: deviceWidth * 0.03),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.number,
                  autocorrect: true,
                  controller: registerController.accNo,
                  inputFormatters: [LengthLimitingTextInputFormatter(16 ),],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Account Number";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ConstColour.textFieldBorder),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ConstColour.textFieldBorder),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ConstColour.textFieldBorder),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: ConstColour.textFieldBorder),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ConstColour.textFieldBorder),
                    ),
                    errorStyle: TextStyle(color: ConstColour.errorHint),

                    border: InputBorder.none,
                    filled: true,
                    hintText: "Enter Account Number",
                    hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontFamily: ConstFont.poppinsRegular,
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis),
                  ),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: ConstFont.poppinsRegular),
                ),
              ),
              Divider(height: deviceHeight * 0.01),
              Padding(
                padding: EdgeInsets.only(
                    left: deviceWidth * 0.03, right: deviceWidth * 0.03),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textAlign: TextAlign.start,
                   textCapitalization: TextCapitalization.characters,
                   inputFormatters: [LengthLimitingTextInputFormatter(11),],
                  keyboardType: TextInputType.text,
                  autocorrect: true,
                  controller: registerController.ifsc,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter IFSC code";
                    } else if(ifscVal.hasMatch(value)) {
                      return "Enter Valid IFSC Code";
                    }else{
                      return null;
                    }
                  },

                  decoration: InputDecoration(
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ConstColour.textFieldBorder),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ConstColour.textFieldBorder),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ConstColour.textFieldBorder),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: ConstColour.textFieldBorder),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ConstColour.textFieldBorder),
                    ),
                    errorStyle: TextStyle(color: ConstColour.errorHint),

                    border: InputBorder.none,
                    filled: true,
                    hintText: "Enter IFSC",
                    hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontFamily: ConstFont.poppinsRegular,
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis),
                  ),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: ConstFont.poppinsRegular),
                ),
              ),
              Divider(height: deviceHeight * 0.01),
              Padding(
                padding: EdgeInsets.only(
                    left: deviceWidth * 0.03, right: deviceWidth * 0.03),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.text,
                  autocorrect: true,
                  controller: registerController.branchName,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Branch Name";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ConstColour.textFieldBorder),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ConstColour.textFieldBorder),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ConstColour.textFieldBorder),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: ConstColour.textFieldBorder),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ConstColour.textFieldBorder),
                    ),
                    errorStyle: TextStyle(color: ConstColour.errorHint),

                    border: InputBorder.none,
                    filled: true,
                    hintText: "Enter Branch Name",
                    hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontFamily: ConstFont.poppinsRegular,
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis),
                  ),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: ConstFont.poppinsRegular),
                ),
              ),
              Divider(height: deviceHeight * 0.01),
              Padding(
                padding: EdgeInsets.only(
                    left: deviceWidth * 0.03, right: deviceWidth * 0.03),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.text,
                  autocorrect: true,
                  controller: registerController.accHolName,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Account Holder Name";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ConstColour.textFieldBorder),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ConstColour.textFieldBorder),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ConstColour.textFieldBorder),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: ConstColour.textFieldBorder),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ConstColour.textFieldBorder),
                    ),
                    errorStyle: TextStyle(color: ConstColour.errorHint),

                    border: InputBorder.none,
                    filled: true,
                    hintText: "Enter Account Holder Name",
                    hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontFamily: ConstFont.poppinsRegular,
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis),
                  ),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: ConstFont.poppinsRegular),
                ),
              ),


              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: ConstColour.primaryColor,strokeAlign: BorderSide.strokeAlignInside,style: BorderStyle.solid)
                  ),
                  child: Stack(
                    children: [
                      SizedBox(
                        width: deviceWidth * 1.0,
                        height: deviceHeight * 0.18,
                        child: Center(
                          child: Stack(
                            children: [

                              Obx(
                                () =>  Container(
                                  child : registerController.isLoading.value == true ? CircularProgressIndicator(
                                    color: ConstColour.primaryColor,
                                  ) :
                                   Container(
                                    child: imageNotes != null
                                        ?  Image.file(
                                        imageNotes!,
                                        // width: deviceWidth * 0.275,
                                        // height: deviceHeight * 0.13,
                                      )
                                        : InkWell(
                                      onTap: () {
                                        showDialog<void>(
                                          context: context,
                                          builder: (BuildContext dialogContext) {
                                            return AlertDialog(
                                              content: SizedBox(
                                                // height: deviceHeight * 0.17,
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Card(
                                                      child: ListTile(
                                                        title: const Text("Camera"),
                                                        onTap: () {
                                                          Navigator.pop(context);
                                                          getImageCamera();
                                                        },
                                                        leading: const Icon(
                                                          Icons.camera_alt,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    Card(
                                                      child: ListTile(
                                                        title: const Text("Gallery"),
                                                        onTap: () {
                                                          Navigator.pop(context);
                                                          getImageGallery();
                                                        },
                                                        leading: const Icon(
                                                          Icons.photo_library_rounded,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: (userProfileImage == null || userProfileImage!.isEmpty)
                                          ?
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset('asset/icons/image.png',width: deviceWidth * 0.2),
                                          Padding(
                                            padding:  EdgeInsets.all(8.0),
                                            child: Text("Upload Aadhaar Card",style: TextStyle(color: Colors.grey,fontFamily: ConstFont.poppinsMedium,fontSize: 14,),overflow: TextOverflow.ellipsis,),
                                          )
                                        ],
                                      )

                                          : CircleAvatar(
                                        radius: 55,
                                        backgroundImage: NetworkImage(userProfileImage!),
                                      ),
                                    ),
                                  ),

                                // Positioned(
                                //     left: deviceWidth * 0.16,
                                //     // bottom: deviceHeight * 0.08,
                                //     top: deviceHeight * 0.08,
                                //     child: imageNotes != null
                                //         ? IconButton(
                                //         onPressed: () {
                                //           setState(() {
                                //             imageNotes = null;
                                //           });
                                //         },
                                //         icon: const Icon(
                                //           CupertinoIcons.minus_circle_fill,
                                //           color: Colors.red,
                                //           size: 24,
                                //         ))
                                //         : const SizedBox())
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(child: imageNotes != null
                          ? IconButton(
                          onPressed: () {
                            setState(() {
                              imageNotes = null;
                              registerController.imgList.clear();
                            });
                          },
                          icon: const Icon(
                            Icons.cancel_outlined,
                            color: Colors.red,
                            size: 24,
                          ))
                          : const SizedBox(),)
                    ],
                  ),
                ),
              ),

               Obx(
                 () =>  Padding(
                      padding: EdgeInsets.only(top: deviceHeight * 0.05),
                      child:  registerController.isLoading.value == true ? SizedBox() :  NextButton(
                        btnName: "Register",
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (registerController.imgList.isEmpty) {
                                Utils().toastMessage("Please enter the image");
                            } else {

                              homeController.loading.value = true;
                              registerController.userRegister(
                                  registerController.firstNames,
                                  registerController.lastNames,
                                  registerController.pass,
                                  registerController.phone,
                                  registerController.addr,
                                  registerController.ref,
                                  registerController.bankName.text,
                                  registerController.accNo.text,
                                  registerController.ifsc.text,
                                  registerController.branchName.text,
                                  registerController.accHolName.text
                              );

                            }




                          }
                        },
                      ),
                    ),
               ),


            ],
          ),
        ),
      ),
    );
  }
}
