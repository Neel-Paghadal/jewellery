import 'dart:math';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/Common/snackbar.dart';
import 'package:jewellery_user/Controller/home_Controller.dart';
import 'package:jewellery_user/Controller/user_list_controller.dart';

import '../Common/bottom_button_widget.dart';
import '../ConstFile/constColors.dart';
import '../ConstFile/constFonts.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  UserListController userListController = Get.put(UserListController());
  HomeController homeController = Get.put(HomeController());
  final _formKey = GlobalKey<FormState>();


  String generateUniqueCode(int length) {
    final random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    String code = '';

    for (int i = 0; i < length; i++) {
      code += chars[random.nextInt(chars.length)];
    }

    return code;
  }

  var dropdownvalue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstColour.bgColor,
        centerTitle: true,
        title: const Text("User List",
            style: TextStyle(
                color: Colors.white,
                fontFamily: ConstFont.poppinsRegular,
                fontSize: 22,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis)),
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_back_ios),
            color: ConstColour.primaryColor),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: NextButton(
          onPressed: () {
            setState(() {
              String uniqueCode = generateUniqueCode(12);
              print('Generated Unique Code: $uniqueCode');
              if(userListController.userListDrop.isEmpty) {
                userListController.getUserDropCall(userListController.orderId.toString());
              }
              showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      setState(() {

                      },);
                      return Dialog(
                        insetAnimationDuration: const Duration(seconds: 1),
                        insetAnimationCurve: Curves.linear,
                        shadowColor: ConstColour.primaryColor,
                        backgroundColor: Colors.black45,
                        child: Container(
                          decoration: BoxDecoration(
                            color: ConstColour.bgColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: ConstColour.primaryColor,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: deviceHeight * 0.01),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        uniqueCode,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: ConstFont.poppinsBold,
                                            color: Colors.white),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                ConstColour.primaryColor),
                                        onPressed: () {
                                          FlutterClipboard.copy(uniqueCode);
                                        },
                                        child: const Text(
                                          "Copy Code",
                                          style: TextStyle(
                                              fontFamily: ConstFont.poppinsBold,
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Obx(
                                  () => Padding(
                                    padding: EdgeInsets.only(
                                        top: deviceHeight * 0.02,
                                        left: deviceWidth * 0.03,
                                        right: deviceWidth * 0.03),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                              color: ConstColour.primaryColor)),
                                      child: DropdownButton(
                                        isExpanded: true,
                                        borderRadius: BorderRadius.circular(8),
                                        iconEnabledColor:
                                            ConstColour.primaryColor,
                                        dropdownColor: Colors.white,
                                        autofocus: true,
                                        elevation: 5,
                                        iconSize: 30,
                                        focusColor: Colors.white,
                                        underline: const DropdownButtonHideUnderline(
                                            child: SizedBox()),
                                        hint: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'Select username',
                                            style: TextStyle(
                                                fontFamily:
                                                    ConstFont.poppinsRegular,
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        ),
                                        items: userListController.userListDrop
                                            .map((item) {
                                          return DropdownMenuItem(
                                              value: item.id.toString(),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  item.name.toString(),
                                                  style: const TextStyle(
                                                      fontFamily: ConstFont
                                                          .poppinsRegular,
                                                      fontSize: 14,
                                                      color: ConstColour
                                                          .primaryColor),
                                                ),
                                              ));
                                        }).toList(),
                                        onChanged: (newVal) {
                                          setState(() {
                                            dropdownvalue = newVal;
                                            userListController.userId = newVal.toString();
                                            debugPrint(dropdownvalue.toString());
                                          });
                                        },
                                        value: dropdownvalue,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: deviceHeight * 0.02,
                                      left: deviceWidth * 0.03,
                                      right: deviceWidth * 0.03),
                                  child: TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    textAlign: TextAlign.start,
                                    keyboardType: TextInputType.text,
                                    autocorrect: true,
                                    controller:  userListController.notesCon,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please Enter Note";
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
                                      labelStyle:
                                          const TextStyle(color: Colors.grey),
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
                                            color: ConstColour.primaryColor),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ConstColour.primaryColor),
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
                                      labelText: "Note",
                                      hintText: "Enter your note",
                                      floatingLabelStyle:
                                          const TextStyle(color: Colors.white),
                                      hintStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontFamily: ConstFont.poppinsRegular,
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    minLines: 3,
                                    maxLines: 4,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: ConstFont.poppinsRegular),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: NextButton(
                                    btnName: "Assign",
                                    onPressed: () {
                                    if(_formKey.currentState!.validate()){
                                      if(userListController.userId == null){
                                        Utils().toastMessage("Please select username");
                                      }else{
                                        homeController.loading.value = true;
                                        userListController.assignOrder(
                                            userListController.userId.toString(),
                                            uniqueCode,
                                            userListController.notesCon.text,
                                            userListController.orderId.toString()
                                        );
                                      }

                                    }


                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            });
          },
          btnName: "Assign User",
        ),
      ),
      backgroundColor: ConstColour.bgColor,
      body: SingleChildScrollView(
        controller: ScrollController(),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Obx(
              () => ListView.builder(
                controller: ScrollController(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: userListController.userList.length,
                itemBuilder: (BuildContext context, index) {
                  Color buttonColor = ConstColour.offerImageColor;

                  if (userListController.userList[index].status ==
                      "In Progress") {
                    buttonColor = ConstColour.offerImageColor;
                  } else if (userListController.userList[index].status ==
                      "Completed") {
                    buttonColor = ConstColour.greenColor;
                  } else if (userListController.userList[index].status ==
                      "Cancelled") {
                    buttonColor = ConstColour.quantityRemove;
                  } else if (userListController.userList[index].status ==
                      "Pending") {
                    buttonColor = Colors.yellow;
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: ConstColour.primaryColor),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(21),
                              ),
                              child: Text(
                                userListController.userList[index].userName,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: ConstFont.poppinsRegular),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: deviceWidth * 0.02),
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                userListController.userList[index].status,
                                style: TextStyle(
                                    color: buttonColor,
                                    fontFamily: ConstFont.poppinsRegular),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
