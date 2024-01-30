import 'dart:math';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/Common/snackbar.dart';
import 'package:jewellery_user/Controller/home_Controller.dart';
import 'package:jewellery_user/Controller/user_list_controller.dart';
import 'package:jewellery_user/Screen/loader.dart';
import '../Common/bottom_button_widget.dart';
import '../ConstFile/constColors.dart';
import '../ConstFile/constFonts.dart';


class CustomDropdown extends StatefulWidget {
  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.grey[200],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedOption,
          hint: Text('Select an option'),
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 32.0,
          elevation: 16,
          style: TextStyle(color: Colors.black, fontSize: 16.0),
          onChanged: (String? newValue) {
            setState(() {
              selectedOption = newValue;
              if (selectedOption == 'Complete') {
                // Handle "Complete" option
                print('Complete option selected');
              } else if (selectedOption == 'Cancel') {
                // Handle "Cancel" option
                print('Cancel option selected');
              }
            });
          },
          items: <String>['Complete', 'Cancel']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}

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
    userListController.getUserCall(userListController.orderId.toString());
  }

  @override
  void dispose() {
    // Clear the selected user when the dialog is closed
    dropdownvalue = null;
    userListController.userId = null;
    super.dispose();
  }

  Future<void> showUserDialouge(String uniqueCode) async {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    dropdownvalue = null;
    userListController.userId = null;
    showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  controller: ScrollController(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: deviceHeight * 0.01),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                  backgroundColor: ConstColour.primaryColor),
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
                      Padding(
                        padding: EdgeInsets.only(
                            top: deviceHeight * 0.02,
                            left: deviceWidth * 0.03,
                            right: deviceWidth * 0.03),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(color: ConstColour.primaryColor)),
                          child: DropdownButton(
                            isExpanded: true,
                            borderRadius: BorderRadius.circular(8),
                            iconEnabledColor: ConstColour.primaryColor,
                            dropdownColor: Colors.white,
                            autofocus: true,
                            elevation: 5,
                            alignment: Alignment.bottomCenter,
                            iconSize: 30,
                            focusColor: Colors.white,
                            underline: const DropdownButtonHideUnderline(
                                child: SizedBox()),
                            hint: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Select username',
                                style: TextStyle(
                                    fontFamily: ConstFont.poppinsRegular,
                                    fontSize: 14,
                                    color: Colors.white),
                              ),
                            ),
                            value: dropdownvalue,
                            items: userListController.userListDrop.map((item) {
                              return DropdownMenuItem(
                                  value: item.id.toString(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      item.name.toString(),
                                      style: const TextStyle(
                                          fontFamily: ConstFont.poppinsRegular,
                                          fontSize: 14,
                                          color: ConstColour.primaryColor),
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
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: deviceHeight * 0.02,
                            left: deviceWidth * 0.03,
                            right: deviceWidth * 0.03),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.text,
                          autocorrect: true,
                          controller: userListController.notesCon,
                          // validator: (value) {
                          //   if (value!.isEmpty) {
                          //     return "Please Enter Note";
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
                                  color: ConstColour.primaryColor),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: ConstColour.primaryColor),
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
                            debugPrint("UserId :${userListController.userId}");

                            if (userListController.userId == "") {
                              Utils().toastMessage("Please select username");
                            } else {
                              debugPrint("ELSE");
                              homeController.loading.value = true;
                              userListController.assignOrder(
                                  userListController.userId.toString(),
                                  uniqueCode,
                                  userListController.notesCon.text,
                                  userListController.orderId.toString());
                              Get.back();
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
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios),
            color: ConstColour.primaryColor),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: NextButton(
          onPressed: () {
            setState(() {
              String uniqueCode = generateUniqueCode(12);
              debugPrint('Generated Unique Code: $uniqueCode');
              userListController
                  .getUserDropCall(userListController.orderId.toString());
              showUserDialouge(uniqueCode);
              // if (userListController.userListDrop.isEmpty) {
              //   Future.delayed(
              //     Duration(seconds: 1),
              //     () {
              //       userListController
              //           .getUserDropCall(userListController.orderId.toString());
              //     },
              //   );
              // } else {
              userListController.userId = '';
            });
          },
          btnName: "Assign User",
        ),
      ),
      backgroundColor: ConstColour.bgColor,
      body: SingleChildScrollView(
        controller: ScrollController(),
        scrollDirection: Axis.vertical,
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              userListController.userList.isEmpty
                  ? Container(
                      child: userListController.isCall.value == true
                          ? Loaders(
                              items: 6,
                              direction: LoaderDirection.ltr,
                              baseColor: Colors.grey,
                              highLightColor: Colors.white,
                              builder: Padding(
                                padding:
                                    EdgeInsets.only(right: deviceWidth * 0.01),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          side: const BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: deviceWidth * 0.4,
                                              height: deviceHeight * 0.01,
                                              color: Colors.grey,
                                            ),
                                            Container(
                                              width: deviceWidth * 0.2,
                                              height: deviceHeight * 0.01,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )

                          : Padding(
                              padding: EdgeInsets.only(
                                top: deviceHeight * 0.35,
                              ),
                              child: const Center(
                                child: Text(
                                  "No User Found",
                                  style: TextStyle(
                                      fontFamily: ConstFont.poppinsMedium,
                                      color: Colors.white,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                    )
                  : ListView.builder(
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

                        // return Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: ListTile(
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(11),
                        //         side:
                        //             BorderSide(color: ConstColour.primaryColor),
                        //       ),
                        //       title: Text(
                        //         userListController.userList[index].userName,
                        //         style: const TextStyle(
                        //             color: Colors.white,
                        //             fontSize: 16,
                        //             fontFamily: ConstFont.poppinsMedium),
                        //         overflow: TextOverflow.ellipsis,
                        //       ),
                        //       subtitle: Text(
                        //         userListController.userList[index].status,
                        //         style: TextStyle(
                        //             color: buttonColor,
                        //             fontFamily: ConstFont.poppinsMedium,
                        //             fontSize: 16),
                        //         overflow: TextOverflow.ellipsis,
                        //       ),
                        //       trailing:
                        //           (userListController.userList[index].status ==
                        //                       "In Progress" ||
                        //                   userListController
                        //                           .userList[index].status ==
                        //                       "Pending")
                        //               ? IconButton(
                        //                   onPressed: () {
                        //                     CustomDropdown();
                        //                   },
                        //                   icon: Icon(CupertinoIcons.ellipsis_circle_fill ,
                        //                       color: ConstColour.primaryColor))
                        //               : SizedBox()),
                        // );
                        //fdrefr

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border:
                                  Border.all(color: ConstColour.primaryColor),
                              borderRadius: BorderRadius.circular(11),
                              boxShadow: const [
                                  BoxShadow(
                                  // color: Colors.grey.withOpacity(0.5),
                                  color: ConstColour.primaryColor,
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: deviceWidth * 0.03,
                                      right: deviceWidth * 0.03,
                                      top: deviceHeight * 0.01,
                                      bottom: deviceHeight * 0.01),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userListController
                                            .userList[index].userName,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontFamily:
                                                ConstFont.poppinsMedium),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        userListController
                                            .userList[index].status,
                                        style: TextStyle(
                                            color: buttonColor,
                                            fontFamily: ConstFont.poppinsMedium,
                                            fontSize: 16),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                (userListController.userList[index].status ==
                                            "In Progress" ||
                                        userListController
                                                .userList[index].status ==
                                            "Pending")
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            left: deviceWidth * 0.03,
                                            right: deviceWidth * 0.03),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12)),
                                                    minimumSize: Size(
                                                        deviceWidth * 0.4,
                                                        deviceHeight * 0.03),
                                                    maximumSize: Size(
                                                        deviceWidth * 0.5,
                                                        deviceHeight * 0.04),
                                                    elevation: 3.0,
                                                    shadowColor: Colors.white,
                                                    backgroundColor: ConstColour
                                                        .primaryColor),
                                                onPressed: () {
                                                  userListController
                                                      .assignComplete(
                                                          userListController
                                                              .userList[index]
                                                              .id);
                                                },
                                                child: const Text(
                                                  "Complete",
                                                  style: TextStyle(
                                                      fontFamily: ConstFont
                                                          .poppinsRegular,
                                                      color: Colors.black,
                                                      fontSize: 14),
                                                )),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  minimumSize: Size(
                                                      deviceWidth * 0.4,
                                                      deviceHeight * 0.03),
                                                  maximumSize: Size(
                                                      deviceWidth * 0.5,
                                                      deviceHeight * 0.04),
                                                  backgroundColor:
                                                      ConstColour.primaryColor,
                                                  elevation: 3.0,
                                                  shadowColor: Colors.white,
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return StatefulBuilder(
                                                        builder: (context,
                                                            setState) {
                                                          setState(
                                                            () {},
                                                          );
                                                          return Dialog(
                                                            insetAnimationDuration:
                                                                const Duration(
                                                                    seconds: 1),
                                                            insetAnimationCurve:
                                                                Curves.linear,
                                                            shadowColor:
                                                                ConstColour
                                                                    .primaryColor,
                                                            backgroundColor:
                                                                Colors.black45,
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    ConstColour
                                                                        .bgColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                border:
                                                                    Border.all(
                                                                  color: ConstColour
                                                                      .primaryColor,
                                                                ),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.4),
                                                                    spreadRadius:
                                                                        2,
                                                                    blurRadius:
                                                                        2,
                                                                    offset:
                                                                        const Offset(
                                                                            0,
                                                                            2),
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Form(
                                                                key: _formKey,
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsets.only(
                                                                          bottom: deviceHeight *
                                                                              0.01,
                                                                          top: deviceHeight *
                                                                              0.01),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.only(right: deviceWidth * 0.1),
                                                                            child:
                                                                                Text("Code : ${userListController.userList[index].code}", style: const TextStyle(fontSize: 16, color: Colors.white, fontFamily: ConstFont.poppinsMedium)),
                                                                          ),
                                                                          IconButton(
                                                                              onPressed: () {
                                                                                Get.back();
                                                                              },
                                                                              icon: const Icon(
                                                                                Icons.cancel_outlined,
                                                                                color: ConstColour.primaryColor,
                                                                                size: 24,
                                                                              ))
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.only(
                                                                          top: deviceHeight *
                                                                              0.02,
                                                                          left: deviceWidth *
                                                                              0.03,
                                                                          right:
                                                                              deviceWidth * 0.03),
                                                                      child:
                                                                          TextFormField(
                                                                        autovalidateMode:
                                                                            AutovalidateMode.onUserInteraction,
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        keyboardType:
                                                                            TextInputType.text,
                                                                        autocorrect:
                                                                            true,
                                                                        controller:
                                                                            userListController.reasonController,
                                                                        validator:
                                                                            (value) {
                                                                          if (value!
                                                                              .isEmpty) {
                                                                            return "Please Enter Reason";
                                                                          } else {
                                                                            return null;
                                                                          }
                                                                        },
                                                                        decoration:
                                                                            InputDecoration(
                                                                          labelStyle:
                                                                              const TextStyle(color: Colors.grey),
                                                                          enabledBorder:
                                                                              OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                            borderSide:
                                                                                const BorderSide(color: ConstColour.textFieldBorder),
                                                                          ),
                                                                          disabledBorder:
                                                                              OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                            borderSide:
                                                                                const BorderSide(color: ConstColour.textFieldBorder),
                                                                          ),
                                                                          focusedErrorBorder:
                                                                              OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                            borderSide:
                                                                                const BorderSide(color: ConstColour.primaryColor),
                                                                          ),
                                                                          focusedBorder:
                                                                              const OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(color: ConstColour.primaryColor),
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(8)),
                                                                          ),
                                                                          errorBorder:
                                                                              OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                            borderSide:
                                                                                const BorderSide(color: ConstColour.textFieldBorder),
                                                                          ),
                                                                          border:
                                                                              InputBorder.none,
                                                                          filled:
                                                                              true,
                                                                          labelText:
                                                                              "Reason",
                                                                          hintText:
                                                                              "Enter your reason",
                                                                          floatingLabelStyle:
                                                                              const TextStyle(color: Colors.white),
                                                                          hintStyle: const TextStyle(
                                                                              color: Colors.grey,
                                                                              fontFamily: ConstFont.poppinsRegular,
                                                                              fontSize: 16,
                                                                              overflow: TextOverflow.ellipsis),
                                                                        ),
                                                                        minLines:
                                                                            3,
                                                                        maxLines:
                                                                            4,
                                                                        style: const TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                16,
                                                                            fontFamily:
                                                                                ConstFont.poppinsRegular),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                      child:
                                                                          NextButton(
                                                                        btnName:
                                                                            "orderCancel".tr,
                                                                        onPressed:
                                                                            () {
                                                                          // if(_formKey.currentState!.validate()){

                                                                          userListController.assignCancel(
                                                                              userListController.userList[index].id,
                                                                              userListController.reasonController.text);
                                                                          Get.back();
                                                                          // }
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
                                                },
                                                child: const Text("Cancel")),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
              // FutureBuilder<dynamic>(
              //   future: userListController
              //       .getUserCall(userListController.orderId.toString()),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       // Display shimmer effect while waiting for the response
              //       return Loaders(
              //         items: 6,
              //         direction: LoaderDirection.ltr,
              //         baseColor: Colors.grey,
              //         highLightColor: Colors.white,
              //         builder: Padding(
              //           padding: EdgeInsets.only(right: deviceWidth * 0.01),
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Padding(
              //                 padding: const EdgeInsets.all(8.0),
              //                 child: ListTile(
              //                   shape: RoundedRectangleBorder(
              //                     borderRadius: BorderRadius.circular(8),
              //                     side: const BorderSide(
              //                       color: Colors.grey,
              //                     ),
              //                   ),
              //                   title: Row(
              //                     mainAxisAlignment:
              //                         MainAxisAlignment.spaceBetween,
              //                     children: [
              //                       Container(
              //                         width: deviceWidth * 0.4,
              //                         height: deviceHeight * 0.01,
              //                         color: Colors.grey,
              //                       ),
              //                       Container(
              //                         width: deviceWidth * 0.2,
              //                         height: deviceHeight * 0.01,
              //                         color: Colors.grey,
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               )
              //             ],
              //           ),
              //         ),
              //       );
              //     } else if (snapshot.hasError) {
              //       // Display an error message if the API call fails
              //       return const Center(
              //         child: Text('Error fetching users. Please try again.',
              //             style: TextStyle(
              //                 fontFamily: ConstFont.poppinsRegular,
              //                 fontSize: 16,
              //                 color: Colors.white),
              //             overflow: TextOverflow.ellipsis),
              //       );
              //     } else if (snapshot.data == null || snapshot.data!.isEmpty) {
              //       // Display a message if no users are found
              //       return Padding(
              //         padding: EdgeInsets.only(top: deviceHeight * 0.35),
              //         child: const Center(
              //           child: Text('No users found',
              //               style: TextStyle(
              //                   fontFamily: ConstFont.poppinsRegular,
              //                   fontSize: 16,
              //                   color: Colors.white),
              //               overflow: TextOverflow.ellipsis),
              //         ),
              //       );
              //     } else {
              //       // Display the list of users
              //       return ListView.builder(
              //         controller: ScrollController(),
              //         scrollDirection: Axis.vertical,
              //         shrinkWrap: true,
              //         itemCount: userListController.userList.length,
              //         itemBuilder: (BuildContext context, index) {
              //           Color buttonColor = ConstColour.offerImageColor;
              //
              //           if (userListController.userList[index].status ==
              //               "In Progress") {
              //             buttonColor = ConstColour.offerImageColor;
              //           } else if (userListController.userList[index].status ==
              //               "Completed") {
              //             buttonColor = ConstColour.greenColor;
              //           } else if (userListController.userList[index].status ==
              //               "Cancelled") {
              //             buttonColor = ConstColour.quantityRemove;
              //           } else if (userListController.userList[index].status ==
              //               "Pending") {
              //             buttonColor = Colors.yellow;
              //           }
              //
              //           return Padding(
              //             padding: const EdgeInsets.all(8.0),
              //             child: Container(
              //               decoration: BoxDecoration(
              //                 color: Colors.black,
              //                 border:
              //                     Border.all(color: ConstColour.primaryColor),
              //                 borderRadius: BorderRadius.circular(11),
              //                 boxShadow: [
              //                   BoxShadow(
              //                     // color: Colors.grey.withOpacity(0.5),
              //                     color: ConstColour.primaryColor,
              //                     spreadRadius: 1,
              //                     blurRadius: 5,
              //                     offset: Offset(0, 3),
              //                   ),
              //                 ],
              //               ),
              //               child: Column(
              //                 children: [
              //                   Padding(
              //                     padding: EdgeInsets.only(
              //                         left: deviceWidth * 0.03,
              //                         right: deviceWidth * 0.03,
              //                         top: deviceHeight * 0.01,
              //                         bottom: deviceHeight * 0.01),
              //                     child: Row(
              //                       mainAxisAlignment:
              //                           MainAxisAlignment.spaceBetween,
              //                       crossAxisAlignment:
              //                           CrossAxisAlignment.start,
              //                       children: [
              //                         Text(
              //                           userListController
              //                               .userList[index].userName,
              //                           style: const TextStyle(
              //                               color: Colors.white,
              //                               fontSize: 16,
              //                               fontFamily:
              //                                   ConstFont.poppinsMedium),
              //                           overflow: TextOverflow.ellipsis,
              //                         ),
              //                         Text(
              //                           userListController
              //                               .userList[index].status,
              //                           style: TextStyle(
              //                               color: buttonColor,
              //                               fontFamily: ConstFont.poppinsMedium,
              //                               fontSize: 16),
              //                           overflow: TextOverflow.ellipsis,
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                   (userListController.userList[index].status ==
              //                               "In Progress" ||
              //                           userListController
              //                                   .userList[index].status ==
              //                               "Pending")
              //                       ? Padding(
              //                           padding: EdgeInsets.only(
              //                               left: deviceWidth * 0.03,
              //                               right: deviceWidth * 0.03),
              //                           child: Row(
              //                             mainAxisAlignment:
              //                                 MainAxisAlignment.spaceBetween,
              //                             children: [
              //                               ElevatedButton(
              //                                   style: ElevatedButton.styleFrom(
              //                                       shape:
              //                                           RoundedRectangleBorder(
              //                                               borderRadius:
              //                                                   BorderRadius
              //                                                       .circular(
              //                                                           12)),
              //                                       minimumSize: Size(
              //                                           deviceWidth * 0.4,
              //                                           deviceHeight * 0.03),
              //                                       maximumSize: Size(
              //                                           deviceWidth * 0.5,
              //                                           deviceHeight * 0.04),
              //                                       elevation: 3.0,
              //                                       shadowColor: Colors.white,
              //                                       backgroundColor: ConstColour
              //                                           .primaryColor),
              //                                   onPressed: () {
              //                                     userListController
              //                                         .assignComplete(
              //                                             userListController
              //                                                 .userList[index]
              //                                                 .id);
              //                                   },
              //                                   child: const Text(
              //                                     "Complete",
              //                                     style: TextStyle(
              //                                         fontFamily: ConstFont
              //                                             .poppinsRegular,
              //                                         color: Colors.black,
              //                                         fontSize: 14),
              //                                   )),
              //                               ElevatedButton(
              //                                   style: ElevatedButton.styleFrom(
              //                                     shape: RoundedRectangleBorder(
              //                                         borderRadius:
              //                                             BorderRadius.circular(
              //                                                 12)),
              //                                     minimumSize: Size(
              //                                         deviceWidth * 0.4,
              //                                         deviceHeight * 0.03),
              //                                     maximumSize: Size(
              //                                         deviceWidth * 0.5,
              //                                         deviceHeight * 0.04),
              //                                     backgroundColor:
              //                                         ConstColour.primaryColor,
              //                                     elevation: 3.0,
              //                                     shadowColor: Colors.white,
              //                                   ),
              //                                   onPressed: () {
              //                                     showDialog(
              //                                       context: context,
              //                                       builder: (context) {
              //                                         return StatefulBuilder(
              //                                           builder: (context,
              //                                               setState) {
              //                                             setState(
              //                                               () {},
              //                                             );
              //                                             return Dialog(
              //                                               insetAnimationDuration:
              //                                                   const Duration(
              //                                                       seconds: 1),
              //                                               insetAnimationCurve:
              //                                                   Curves.linear,
              //                                               shadowColor:
              //                                                   ConstColour
              //                                                       .primaryColor,
              //                                               backgroundColor:
              //                                                   Colors.black45,
              //                                               child: Container(
              //                                                 decoration:
              //                                                     BoxDecoration(
              //                                                   color:
              //                                                       ConstColour
              //                                                           .bgColor,
              //                                                   borderRadius:
              //                                                       BorderRadius
              //                                                           .circular(
              //                                                               8),
              //                                                   border:
              //                                                       Border.all(
              //                                                     color: ConstColour
              //                                                         .primaryColor,
              //                                                   ),
              //                                                   boxShadow: [
              //                                                     BoxShadow(
              //                                                       color: Colors
              //                                                           .grey
              //                                                           .withOpacity(
              //                                                               0.4),
              //                                                       spreadRadius:
              //                                                           2,
              //                                                       blurRadius:
              //                                                           2,
              //                                                       offset:
              //                                                           const Offset(
              //                                                               0,
              //                                                               2),
              //                                                     ),
              //                                                   ],
              //                                                 ),
              //                                                 child: Form(
              //                                                   key: _formKey,
              //                                                   child: Column(
              //                                                     mainAxisSize:
              //                                                         MainAxisSize
              //                                                             .min,
              //                                                     children: [
              //                                                       Padding(
              //                                                         padding: EdgeInsets.only(
              //                                                             bottom: deviceHeight *
              //                                                                 0.01,
              //                                                             top: deviceHeight *
              //                                                                 0.01),
              //                                                         child:
              //                                                             Row(
              //                                                           mainAxisAlignment:
              //                                                               MainAxisAlignment.end,
              //                                                           children: [
              //                                                             Padding(
              //                                                               padding:
              //                                                                   EdgeInsets.only(right: deviceWidth * 0.1),
              //                                                               child:
              //                                                                   Text("Code : " + userListController.userList[index].code, style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: ConstFont.poppinsMedium)),
              //                                                             ),
              //                                                             IconButton(
              //                                                                 onPressed: () {
              //                                                                   Get.back();
              //                                                                 },
              //                                                                 icon: const Icon(
              //                                                                   Icons.cancel_outlined,
              //                                                                   color: ConstColour.primaryColor,
              //                                                                   size: 24,
              //                                                                 ))
              //                                                           ],
              //                                                         ),
              //                                                       ),
              //                                                       Padding(
              //                                                         padding: EdgeInsets.only(
              //                                                             top: deviceHeight *
              //                                                                 0.02,
              //                                                             left: deviceWidth *
              //                                                                 0.03,
              //                                                             right:
              //                                                                 deviceWidth * 0.03),
              //                                                         child:
              //                                                             TextFormField(
              //                                                           autovalidateMode:
              //                                                               AutovalidateMode.onUserInteraction,
              //                                                           textAlign:
              //                                                               TextAlign.start,
              //                                                           keyboardType:
              //                                                               TextInputType.text,
              //                                                           autocorrect:
              //                                                               true,
              //                                                           controller:
              //                                                               userListController.reasonController,
              //                                                           validator:
              //                                                               (value) {
              //                                                             if (value!
              //                                                                 .isEmpty) {
              //                                                               return "Please Enter Reason";
              //                                                             } else {
              //                                                               return null;
              //                                                             }
              //                                                           },
              //                                                           decoration:
              //                                                               InputDecoration(
              //                                                             labelStyle:
              //                                                                 const TextStyle(color: Colors.grey),
              //                                                             enabledBorder:
              //                                                                 OutlineInputBorder(
              //                                                               borderRadius:
              //                                                                   BorderRadius.circular(8),
              //                                                               borderSide:
              //                                                                   const BorderSide(color: ConstColour.textFieldBorder),
              //                                                             ),
              //                                                             disabledBorder:
              //                                                                 OutlineInputBorder(
              //                                                               borderRadius:
              //                                                                   BorderRadius.circular(8),
              //                                                               borderSide:
              //                                                                   const BorderSide(color: ConstColour.textFieldBorder),
              //                                                             ),
              //                                                             focusedErrorBorder:
              //                                                                 OutlineInputBorder(
              //                                                               borderRadius:
              //                                                                   BorderRadius.circular(8),
              //                                                               borderSide:
              //                                                                   const BorderSide(color: ConstColour.primaryColor),
              //                                                             ),
              //                                                             focusedBorder:
              //                                                                 const OutlineInputBorder(
              //                                                               borderSide:
              //                                                                   BorderSide(color: ConstColour.primaryColor),
              //                                                               borderRadius:
              //                                                                   BorderRadius.all(Radius.circular(8)),
              //                                                             ),
              //                                                             errorBorder:
              //                                                                 OutlineInputBorder(
              //                                                               borderRadius:
              //                                                                   BorderRadius.circular(8),
              //                                                               borderSide:
              //                                                                   const BorderSide(color: ConstColour.textFieldBorder),
              //                                                             ),
              //                                                             border:
              //                                                                 InputBorder.none,
              //                                                             filled:
              //                                                                 true,
              //                                                             labelText:
              //                                                                 "Reason",
              //                                                             hintText:
              //                                                                 "Enter your reason",
              //                                                             floatingLabelStyle:
              //                                                                 const TextStyle(color: Colors.white),
              //                                                             hintStyle: const TextStyle(
              //                                                                 color: Colors.grey,
              //                                                                 fontFamily: ConstFont.poppinsRegular,
              //                                                                 fontSize: 16,
              //                                                                 overflow: TextOverflow.ellipsis),
              //                                                           ),
              //                                                           minLines:
              //                                                               3,
              //                                                           maxLines:
              //                                                               4,
              //                                                           style: const TextStyle(
              //                                                               color: Colors
              //                                                                   .white,
              //                                                               fontSize:
              //                                                                   16,
              //                                                               fontFamily:
              //                                                                   ConstFont.poppinsRegular),
              //                                                         ),
              //                                                       ),
              //                                                       Padding(
              //                                                         padding: const EdgeInsets
              //                                                             .all(
              //                                                             8.0),
              //                                                         child:
              //                                                             NextButton(
              //                                                           btnName:
              //                                                               "orderCancel".tr,
              //                                                           onPressed:
              //                                                               () {
              //                                                             // if(_formKey.currentState!.validate()){
              //
              //                                                             userListController.assignCancel(
              //                                                                 userListController.userList[index].id,
              //                                                                 userListController.reasonController.text);
              //                                                             Get.back();
              //                                                             // }
              //                                                           },
              //                                                         ),
              //                                                       ),
              //                                                     ],
              //                                                   ),
              //                                                 ),
              //                                               ),
              //                                             );
              //                                           },
              //                                         );
              //                                       },
              //                                     );
              //                                   },
              //                                   child: const Text("Cancel")),
              //                             ],
              //                           ),
              //                         )
              //                       : SizedBox(),
              //                 ],
              //               ),
              //             ),
              //           );
              //         },
              //       );
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
