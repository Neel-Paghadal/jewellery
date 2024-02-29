import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jewellery_user/Common/bottom_button_widget.dart';
import 'package:jewellery_user/Common/snackbar.dart';
import 'package:jewellery_user/ConstFile/constColors.dart';
import 'package:jewellery_user/Controller/home_Controller.dart';
import 'package:jewellery_user/Controller/newRegister_controller.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../ConstFile/constFonts.dart';

class NewUserRegister extends StatefulWidget {
  const NewUserRegister({super.key});

  @override
  State<NewUserRegister> createState() => _NewUserRegisterState();
}

class _NewUserRegisterState extends State<NewUserRegister> {
  final mobileRegex = RegExp(r'^[0-9]{10}$');
  final _formKey = GlobalKey<FormState>();
  NewRegisterCon newRegisterCon = Get.put(NewRegisterCon());
  HomeController homeController = Get.put(HomeController());
  File? imageNotes;
  String? userProfileImage;

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
      newRegisterCon.isLoading.value = true;
      newRegisterCon.uploadFile(imageNotes!);
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
      newRegisterCon.isLoading.value = true;
      newRegisterCon.uploadFile(imageNotes!);

      debugPrint(imageNotes.toString());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newRegisterCon.clearController();
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
        title: const Text("New Register",
            style: TextStyle(
                color: Colors.white,
                fontFamily: ConstFont.poppinsRegular,
                fontSize: 22,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis)),
        leading: IconButton(
            tooltip: "Back",
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios),
            color: ConstColour.primaryColor),
      ),
      body: SingleChildScrollView(
        controller: ScrollController(),
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // const Text("Create Account",style: TextStyle(
                //     color: ConstColour.primaryColor,
                //     fontWeight: FontWeight.w700,
                //     fontFamily: ConstFont.poppinsRegular,
                //     fontSize: 30
                // )),
                // Divider(height: deviceHeight * 0.01),
                //
                // const Text("Create an account so you can\nexplore all the existing jobs",style: TextStyle(
                //     color: Colors.white,
                //     fontWeight: FontWeight.w700,
                //     fontFamily: ConstFont.poppinsRegular,
                //     fontSize: 19
                // ),overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,maxLines: 2),
                Divider(height: deviceHeight * 0.03),
                Padding(
                  padding: EdgeInsets.only(
                      left: deviceWidth * 0.03, right: deviceWidth * 0.03),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.text,
                          autocorrect: true,
                          controller: newRegisterCon.firstName,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter FirsName";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(color: Colors.grey),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: ConstColour.textFieldBorder),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: ConstColour.textFieldBorder),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: ConstColour.textFieldBorder),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: ConstColour.textFieldBorder),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: ConstColour.textFieldBorder),
                            ),
                            border: InputBorder.none,
                            filled: true,
                            hintText: "Enter Firstname",
                            hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontFamily: ConstFont.poppinsRegular,
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis),
                            errorStyle:
                                const TextStyle(color: ConstColour.errorHint),
                          ),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: ConstFont.poppinsRegular),
                        ),
                      ),
                      SizedBox(width: deviceWidth * 0.03),
                      Expanded(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.text,
                          autocorrect: true,
                          controller: newRegisterCon.lastName,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter LastName";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(color: Colors.grey),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: ConstColour.textFieldBorder),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: ConstColour.textFieldBorder),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: ConstColour.textFieldBorder),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: ConstColour.textFieldBorder),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: ConstColour.textFieldBorder),
                            ),
                            errorStyle:
                                const TextStyle(color: ConstColour.errorHint),
                            border: InputBorder.none,
                            filled: true,
                            hintText: "Enter Lastname",
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
                    ],
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
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10)
                    ],
                    autocorrect: true,
                    controller: newRegisterCon.mobile,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Your Mobile Number";
                      } else if (!mobileRegex.hasMatch(value)) {
                        return 'Enter a valid 10-digit mobile number';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: ConstColour.textFieldBorder),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: ConstColour.textFieldBorder),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: ConstColour.textFieldBorder),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ConstColour.textFieldBorder),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: ConstColour.textFieldBorder),
                      ),
                      border: InputBorder.none,
                      filled: true,
                      hintText: "Enter Your Mobile Number",
                      hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontFamily: ConstFont.poppinsRegular,
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis),
                      errorStyle: const TextStyle(color: ConstColour.errorHint),
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
                    keyboardType: TextInputType.multiline,
                    autocorrect: true,
                    controller: newRegisterCon.address,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Address";
                      } else if (value.length <= 10) {
                        return 'Enter Full Address';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: ConstColour.textFieldBorder),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: ConstColour.textFieldBorder),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: ConstColour.textFieldBorder),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ConstColour.textFieldBorder),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: ConstColour.textFieldBorder),
                      ),
                      errorStyle: const TextStyle(color: ConstColour.errorHint),
                      border: InputBorder.none,
                      filled: true,
                      hintText: "Enter Address",
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
                    keyboardType: TextInputType.multiline,
                    autocorrect: true,
                    controller: newRegisterCon.password,
                    obscureText: newRegisterCon.isHidden.value,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Password";
                        // } else if (!regex.hasMatch(value)) {
                        //   return 'Enter a valid password';
                        // }
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: ConstColour.textFieldBorder),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: ConstColour.textFieldBorder),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: ConstColour.textFieldBorder),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ConstColour.textFieldBorder),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: ConstColour.textFieldBorder),
                      ),
                      errorStyle: const TextStyle(color: ConstColour.errorHint),
                      suffixIcon: IconButton(
                        icon: Icon(
                          newRegisterCon.isHidden.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        color: ConstColour.primaryColor,
                        onPressed: () {
                          setState(() {
                            newRegisterCon.isHidden.value =
                                !newRegisterCon.isHidden.value;
                          });
                        },
                      ),
                      border: InputBorder.none,
                      filled: true,
                      hintText: "Password",
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
                    keyboardType: TextInputType.multiline,
                    autocorrect: true,
                    controller: newRegisterCon.cPassword,
                    obscureText: newRegisterCon.isHidden.value,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Your Confirm Password";
                      } else if (value != newRegisterCon.password.text) {
                        return 'Password doesn\'t Match';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          newRegisterCon.isHidden.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        color: ConstColour.primaryColor,
                        onPressed: () {
                          setState(() {
                            newRegisterCon.isHidden.value =
                                !newRegisterCon.isHidden.value;
                          });
                        },
                      ),
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: ConstColour.textFieldBorder),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: ConstColour.textFieldBorder),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: ConstColour.textFieldBorder),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ConstColour.textFieldBorder),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: ConstColour.textFieldBorder),
                      ),
                      border: InputBorder.none,
                      filled: true,
                      hintText: "Confirm Password",
                      hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontFamily: ConstFont.poppinsRegular,
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis),
                      errorStyle: const TextStyle(color: ConstColour.errorHint),
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
                    keyboardType: TextInputType.multiline,
                    autocorrect: true,
                    controller: newRegisterCon.reference,
                    // validator: (value) {
                    //   if (value!.isEmpty) {
                    //     return "Enter Reference Name";
                    //   } else {
                    //     return null;
                    //   }
                    // },
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: ConstColour.textFieldBorder),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: ConstColour.textFieldBorder),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: ConstColour.textFieldBorder),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ConstColour.textFieldBorder),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: ConstColour.textFieldBorder),
                      ),
                      errorStyle: const TextStyle(color: ConstColour.errorHint),
                      border: InputBorder.none,
                      filled: true,
                      hintText: "Reference Name",
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
                        border: Border.all(
                            color: ConstColour.primaryColor,
                            strokeAlign: BorderSide.strokeAlignInside,
                            style: BorderStyle.solid)),
                    child: Stack(
                      children: [
                        SizedBox(
                          width: deviceWidth * 1.0,
                          height: deviceHeight * 0.18,
                          child: Center(
                            child: Stack(
                              children: [
                                Obx(
                                  () => Container(
                                    child:
                                        newRegisterCon.isLoading.value == true
                                            ? const CircularProgressIndicator(
                                                color: ConstColour.primaryColor,
                                              )
                                            : Container(
                                                child: imageNotes != null
                                                    ? Image.file(
                                                        imageNotes!,
                                                        // width: deviceWidth * 0.275,
                                                        // height: deviceHeight * 0.13,
                                                      )
                                                    : InkWell(
                                                        onTap: () {
                                                          showDialog<void>(
                                                            context: context,
                                                            builder: (BuildContext
                                                                dialogContext) {
                                                              return AlertDialog(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            11)),
                                                                title: const Center(
                                                                    child: Text(
                                                                        "Choose Image Source",
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize:
                                                                                18,
                                                                            fontFamily: ConstFont
                                                                                .poppinsBold),
                                                                        overflow:
                                                                            TextOverflow.ellipsis)),
                                                                backgroundColor:
                                                                    ConstColour
                                                                        .primaryColor,
                                                                titlePadding:
                                                                    EdgeInsets.only(
                                                                        top: deviceHeight *
                                                                            0.02),
                                                                actionsPadding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                        .all(8),
                                                                content: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    const Divider(
                                                                        color: Colors
                                                                            .black),
                                                                    ListTile(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              11),
                                                                          side:
                                                                              const BorderSide(color: ConstColour.primaryColor)),
                                                                      tileColor:
                                                                          ConstColour
                                                                              .bgColor,
                                                                      title: const Text(
                                                                          "Camera",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontFamily:
                                                                                ConstFont.poppinsMedium,
                                                                            fontSize:
                                                                                14,
                                                                          ),
                                                                          overflow:
                                                                              TextOverflow.ellipsis),
                                                                      onTap:
                                                                          () {
                                                                        Get.back();
                                                                        getImageCamera();
                                                                      },
                                                                      leading:
                                                                          const Icon(
                                                                        Icons
                                                                            .camera_alt,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height: deviceHeight *
                                                                            0.01),
                                                                    ListTile(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              11),
                                                                          side:
                                                                              const BorderSide(color: ConstColour.primaryColor)),
                                                                      tileColor:
                                                                          ConstColour
                                                                              .bgColor,
                                                                      title: const Text(
                                                                          "Gallery",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontFamily:
                                                                                ConstFont.poppinsMedium,
                                                                            fontSize:
                                                                                14,
                                                                          ),
                                                                          overflow:
                                                                              TextOverflow.ellipsis),
                                                                      onTap:
                                                                          () {
                                                                        Get.back();

                                                                        getImageGallery();
                                                                      },
                                                                      leading:
                                                                          const Icon(
                                                                        Icons
                                                                            .photo_library_rounded,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: (userProfileImage ==
                                                                    null ||
                                                                userProfileImage!
                                                                    .isEmpty)
                                                            ? Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Image.asset(
                                                                      'asset/icons/image.png',
                                                                      width: deviceWidth *
                                                                          0.2),
                                                                  const Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            8.0),
                                                                    child: Text(
                                                                      "Upload Profile Image",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .grey,
                                                                        fontFamily:
                                                                            ConstFont.poppinsMedium,
                                                                        fontSize:
                                                                            14,
                                                                      ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  )
                                                                ],
                                                              )
                                                            : CircleAvatar(
                                                                radius: 55,
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                        userProfileImage!),
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
                        Container(
                          child: imageNotes != null
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      imageNotes = null;
                                      newRegisterCon.imgList.clear();
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.red,
                                    size: 24,
                                  ))
                              : const SizedBox(),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: deviceHeight * 0.05),
                  child: NextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (newRegisterCon.mobile.text.isEmpty &&
                            newRegisterCon.password.text.isEmpty) {
                          setState(() {
                            Utils().toastMessage(
                                "Enter valid Username & password");
                          });
                        } else if (newRegisterCon.imgList.isEmpty) {
                          Utils().toastMessage("Please enter the image");
                        } else {
                          homeController.loading.value = true;
                          newRegisterCon.userRegister(
                              newRegisterCon.firstName.text,
                              newRegisterCon.lastName.text,
                              newRegisterCon.password.text,
                              newRegisterCon.mobile.text,
                              newRegisterCon.address.text,
                              newRegisterCon.reference.text);

                          // loginController.login(mobileNo!, password!);
                        }
                      }
                    },
                    btnName: "Submit",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
