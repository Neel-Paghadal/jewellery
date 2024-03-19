import 'dart:math';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/Common/snackbar.dart';
import 'package:jewellery_user/Controller/home_Controller.dart';
import 'package:jewellery_user/Controller/user_list_controller.dart';
import 'package:jewellery_user/Screen/loader.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../../Common/bottom_button_widget.dart';
import '../../ConstFile/constColors.dart';
import '../../ConstFile/constFonts.dart';

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
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    String code = '';

    for (int i = 0; i < length; i++) {
      code += chars[random.nextInt(chars.length)];
    }

    return code;
  }

  var dropdownvalue;
  String? imageStr;
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
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Assign Order",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: ConstFont.poppinsMedium,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: deviceWidth * 0.04),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "CODE : $uniqueCode",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: ConstFont.poppinsBold,
                                  color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                            InkWell(
                              splashColor: ConstColour.btnHowerColor,
                              onTap: () {
                                FlutterClipboard.copy(uniqueCode);
                                Utils().toastMessage("Copied");
                              },
                              borderRadius: BorderRadius.circular(51),
                              child: const Icon(
                                Icons.copy,
                                size: 24,
                                color: ConstColour.primaryColor,
                              ),
                            ),
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
                            alignment: Alignment.centerLeft,
                            iconSize: 30,
                            focusColor: Colors.white,
                            underline: const DropdownButtonHideUnderline(
                                child: SizedBox()),
                            hint: Padding(
                              padding:
                                  EdgeInsets.only(left: deviceWidth * 0.05),
                              child: const Text(
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
                                  color: ConstColour.primaryColor),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: ConstColour.primaryColor),
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
                            labelText: "Notes",
                            alignLabelWithHint: true,
                            floatingLabelAlignment:
                                FloatingLabelAlignment.start,
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

                            if (userListController.userId == "" && userListController.userId == null) {
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

  Future<void> updateAssignOrder(String uniqueCode,String oldUserId,bool ReAssigned) async {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            setState(() {},);
            return Dialog(
              insetAnimationDuration:
              const Duration(seconds: 1),
              insetAnimationCurve: Curves.linear,
              shadowColor: ConstColour.primaryColor,
              backgroundColor: Colors.black45,
              child: Container(
                decoration: BoxDecoration(
                  color: ConstColour.bgColor,
                  borderRadius:
                  BorderRadius.circular(8),
                  border: Border.all(
                    color: ConstColour.primaryColor,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey
                          .withOpacity(0.4),
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
                        padding: EdgeInsets.only(
                          bottom:
                          deviceHeight * 0.01,
                          top: deviceHeight * 0.01,
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                          children: [
                            Text(
                                "  Code : $uniqueCode",
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors
                                        .white,
                                    fontFamily:
                                    ConstFont
                                        .poppinsMedium)),
                            IconButton(
                                onPressed: () {
                                  FlutterClipboard.copy(uniqueCode);
                                  Utils()
                                      .toastMessage(
                                      "Copied");
                                },
                                icon: const Icon(
                                  Icons.copy,
                                  color: ConstColour
                                      .appBar,
                                  size: 20,
                                )),
                            IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: const Icon(
                                  Icons
                                      .cancel_outlined,
                                  color: ConstColour
                                      .primaryColor,
                                  size: 24,
                                ))
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
                            alignment: Alignment.centerLeft,
                            iconSize: 30,
                            focusColor: Colors.white,
                            underline: const DropdownButtonHideUnderline(
                                child: SizedBox()),
                            hint: Padding(
                              padding:
                              EdgeInsets.only(left: deviceWidth * 0.05),
                              child: const Text(
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
                            top:
                            deviceHeight * 0.02,
                            left:
                            deviceWidth * 0.03,
                            right:
                            deviceWidth * 0.03),
                        child: TextFormField(
                          autovalidateMode:
                          AutovalidateMode
                              .onUserInteraction,
                          textAlign:
                          TextAlign.start,
                          keyboardType:
                          TextInputType.text,
                          autocorrect: true,
                          controller:
                          userListController
                              .notesController,
                          validator: (value) {
                            if (value!.trim()
                                .isEmpty) {
                              return "Please Enter Notes";
                            } else {
                              return null;
                            }
                          },
                          decoration:
                          InputDecoration(
                            labelStyle:
                            const TextStyle(
                                color: Colors
                                    .grey),
                            enabledBorder:
                            OutlineInputBorder(
                              borderRadius:
                              BorderRadius
                                  .circular(8),
                              borderSide: const BorderSide(
                                  color: ConstColour
                                      .textFieldBorder),
                            ),
                            disabledBorder:
                            OutlineInputBorder(
                              borderRadius:
                              BorderRadius
                                  .circular(8),
                              borderSide: const BorderSide(
                                  color: ConstColour
                                      .textFieldBorder),
                            ),
                            focusedErrorBorder:
                            OutlineInputBorder(
                              borderRadius:
                              BorderRadius
                                  .circular(8),
                              borderSide: const BorderSide(
                                  color: ConstColour
                                      .primaryColor),
                            ),
                            focusedBorder:
                            const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: ConstColour
                                      .primaryColor),
                              borderRadius:
                              BorderRadius.all(
                                  Radius
                                      .circular(
                                      8)),
                            ),
                            errorBorder:
                            OutlineInputBorder(
                              borderRadius:
                              BorderRadius
                                  .circular(8),
                              borderSide: const BorderSide(
                                  color: ConstColour
                                      .textFieldBorder),
                            ),
                            border:
                            InputBorder.none,
                            filled: true,
                            labelText: "Notes",
                            hintText:
                            "Enter your notes",
                            floatingLabelStyle:
                            const TextStyle(
                                color: Colors
                                    .white),
                            hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontFamily: ConstFont
                                    .poppinsRegular,
                                fontSize: 16,
                                overflow:
                                TextOverflow
                                    .ellipsis),
                          ),
                          minLines: 3,
                          maxLines: 4,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: ConstFont
                                  .poppinsRegular),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: NextButtonSec(
                          btnName: "Update",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              debugPrint("Drop${userListController.userId}");
                              if(userListController.userId != "" && userListController.userId != null){
                                homeController.loadingSec.value = true;
                                userListController.assignUpdate(
                                    oldUserId,
                                    userListController.userId.toString(),
                                    userListController.notesController.text,
                                  ReAssigned
                                );
                                Get.back();
                              }else{
                                Utils().toastMessage("Please select username");
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

  }

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async{
        homeController.homeList.clear();
        homeController.pageIndex = 0;
        homeController.pageSize = 6;
        homeController.loadProducts();
        Get.back();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ConstColour.bgColor,
          centerTitle: true,
          title: const Text("Assign Order",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: ConstFont.poppinsRegular,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis)),
          leading: IconButton(
              tooltip: "Back",
              onPressed: () {
                homeController.homeList.clear();
                homeController.pageIndex = 0;
                homeController.pageSize = 6;
                homeController.loadProducts();
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
                userListController.getUserDropCall(userListController.orderId.toString());
                showUserDialouge(uniqueCode);
                userListController.userId = '';
              });
            },
            btnName: "Assign User",
          ),
        ),
        backgroundColor: ConstColour.bgColor,
        body: Obx(
          () => LiquidPullToRefresh(
            color: Colors.black,
            height: deviceHeight * 0.08,
            onRefresh: userListController.handleRefresh,
            showChildOpacityTransition: false,
            backgroundColor: ConstColour.primaryColor,
            springAnimationDurationInMilliseconds: 1,
            child: userListController.userList.isEmpty
                ? Container(
                    child: userListController.isCall.value == true
                        ? Loaders(
                            items: 12,
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
                        : ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: const Center(
                              child: Text(
                                "No Data Found",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: ConstFont.poppinsRegular,
                                ),
                              )),
                        ),
                      ],
                    ),
                  )
                : ListView(
                  children: [
                    ListView.builder(
                        controller: ScrollController(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: userListController.userList.length,
                        itemBuilder: (BuildContext context, index) {

                          if (userListController.userList[index].status == "Working") {
                            imageStr = "asset/icons/work-in-progress.png";
                          } else if (userListController.userList[index].status == "Complete") {
                            imageStr = "asset/icons/checkmark.png";
                          } else if (userListController.userList[index].status == "Cancel") {
                            imageStr = "asset/icons/cancelled.png";
                          } else if (userListController.userList[index].status == "Pending") {
                            imageStr = "asset/icons/pending.png";
                          } else if (userListController.userList[index].status == "New") {
                            imageStr = "asset/icons/new.png";
                          }

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(11),
                              splashColor: ConstColour.btnHowerColor,
                              onTap: () {
                                userListController.notesController.text = userListController.userList[index].notes.toString();
                                debugPrint("Controller${userListController.notesController.text}");
                                debugPrint("List${userListController.userList[index].notes}");
                                dropdownvalue = null;
                                userListController.userId = null;
                                if (userListController.userList[index].status == "Complete")
                                {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          setState(() {});
                                          return Dialog(
                                            insetAnimationDuration:
                                                const Duration(seconds: 1),
                                            insetAnimationCurve: Curves.linear,
                                            shadowColor: ConstColour.primaryColor,
                                            backgroundColor: Colors.black45,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: ConstColour.bgColor,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: ConstColour.primaryColor,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.4),
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
                                                      padding: EdgeInsets.only(
                                                        bottom:
                                                            deviceHeight * 0.01,
                                                        top: deviceHeight * 0.01,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              "  Code : ${userListController.userList[index].code}",
                                                              style: const TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      ConstFont
                                                                          .poppinsMedium)),
                                                          IconButton(
                                                              onPressed: () {
                                                                FlutterClipboard.copy(
                                                                    userListController
                                                                        .userList[
                                                                            index]
                                                                        .code);
                                                                Utils()
                                                                    .toastMessage(
                                                                        "Copied");
                                                              },
                                                              icon: const Icon(
                                                                Icons.copy,
                                                                color: ConstColour
                                                                    .appBar,
                                                                size: 20,
                                                              )),
                                                          IconButton(
                                                              onPressed: () {
                                                                Get.back();
                                                              },
                                                              icon: const Icon(
                                                                Icons
                                                                    .cancel_outlined,
                                                                color: ConstColour
                                                                    .primaryColor,
                                                                size: 24,
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top:
                                                              deviceHeight * 0.02,
                                                          left:
                                                              deviceWidth * 0.03,
                                                          right:
                                                              deviceWidth * 0.03,
                                                          bottom: deviceHeight *
                                                              0.02),
                                                      child: TextFormField(
                                                        autovalidateMode:
                                                            AutovalidateMode.onUserInteraction,
                                                        textAlign: TextAlign.start,
                                                        keyboardType: TextInputType.none,
                                                        enableInteractiveSelection: false,
                                                        showCursor: false,
                                                        autocorrect: true,
                                                        controller:
                                                            userListController
                                                                .notesController,
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return "Please Enter Notes";
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          labelStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(8),
                                                            borderSide: const BorderSide(
                                                                color: ConstColour
                                                                    .primaryColor),
                                                          ),
                                                          disabledBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(8),
                                                            borderSide: const BorderSide(
                                                                color: ConstColour
                                                                    .primaryColor),
                                                          ),
                                                          focusedErrorBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(8),
                                                            borderSide: const BorderSide(
                                                                color: ConstColour
                                                                    .primaryColor),
                                                          ),
                                                          focusedBorder:
                                                              const OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: ConstColour
                                                                    .primaryColor),
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius
                                                                        .circular(
                                                                            8)),
                                                          ),
                                                          errorBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(8),
                                                            borderSide: const BorderSide(
                                                                color: ConstColour
                                                                    .primaryColor),
                                                          ),
                                                          border:
                                                              InputBorder.none,
                                                          filled: true,
                                                          labelText: "Notes",
                                                          hintText:
                                                              "Enter your notes",
                                                          floatingLabelStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                          hintStyle: const TextStyle(
                                                              color: Colors.grey,
                                                              fontFamily: ConstFont
                                                                  .poppinsRegular,
                                                              fontSize: 16,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ),
                                                        minLines: 3,
                                                        maxLines: 4,
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontFamily: ConstFont
                                                                .poppinsRegular),
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
                                } else {
                                  if(userListController.userList[index].needToReassign == true){
                                    userListController.getUserDropCall(userListController.orderId.toString());
                                    updateAssignOrder(
                                        userListController.userList[index].code,
                                        userListController.userList[index].id,
                                        userListController.userList[index].needToReassign,
                                    );
                                  }else{

                                    if(userListController.userList[index].needToReassign != true && userListController.userList[index].status == "Cancel"){
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return StatefulBuilder(
                                            builder: (context, setState) {
                                              setState(() {});
                                              return Dialog(
                                                insetAnimationDuration:
                                                const Duration(seconds: 1),
                                                insetAnimationCurve: Curves.linear,
                                                shadowColor: ConstColour.primaryColor,
                                                backgroundColor: Colors.black45,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: ConstColour.bgColor,
                                                    borderRadius:
                                                    BorderRadius.circular(8),
                                                    border: Border.all(
                                                      color: ConstColour.primaryColor,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.4),
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
                                                          padding: EdgeInsets.only(
                                                            bottom:
                                                            deviceHeight * 0.01,
                                                            top: deviceHeight * 0.01,
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  "  Code : ${userListController.userList[index].code}",
                                                                  style: const TextStyle(
                                                                      fontSize: 16,
                                                                      color: Colors
                                                                          .white,
                                                                      fontFamily:
                                                                      ConstFont
                                                                          .poppinsMedium)),
                                                              IconButton(
                                                                  onPressed: () {
                                                                    FlutterClipboard.copy(
                                                                        userListController
                                                                            .userList[
                                                                        index]
                                                                            .code);
                                                                    Utils()
                                                                        .toastMessage(
                                                                        "Copied");
                                                                  },
                                                                  icon: const Icon(
                                                                    Icons.copy,
                                                                    color: ConstColour
                                                                        .appBar,
                                                                    size: 20,
                                                                  )),
                                                              IconButton(
                                                                  onPressed: () {
                                                                    Get.back();
                                                                  },
                                                                  icon: const Icon(
                                                                    Icons
                                                                        .cancel_outlined,
                                                                    color: ConstColour
                                                                        .primaryColor,
                                                                    size: 24,
                                                                  ))
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              top:
                                                              deviceHeight * 0.02,
                                                              left:
                                                              deviceWidth * 0.03,
                                                              right:
                                                              deviceWidth * 0.03,
                                                              bottom: deviceHeight *
                                                                  0.02),
                                                          child: TextFormField(
                                                            autovalidateMode:
                                                            AutovalidateMode.onUserInteraction,
                                                            textAlign: TextAlign.start,
                                                            keyboardType: TextInputType.none,
                                                            enableInteractiveSelection: false,
                                                            showCursor: false,
                                                            autocorrect: true,
                                                            controller:
                                                            userListController
                                                                .notesController,
                                                            validator: (value) {
                                                              if (value!.isEmpty) {
                                                                return "Please Enter Notes";
                                                              } else {
                                                                return null;
                                                              }
                                                            },
                                                            decoration:
                                                            InputDecoration(
                                                              labelStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                              enabledBorder:
                                                              OutlineInputBorder(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(8),
                                                                borderSide: const BorderSide(
                                                                    color: ConstColour
                                                                        .primaryColor),
                                                              ),
                                                              disabledBorder:
                                                              OutlineInputBorder(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(8),
                                                                borderSide: const BorderSide(
                                                                    color: ConstColour
                                                                        .primaryColor),
                                                              ),
                                                              focusedErrorBorder:
                                                              OutlineInputBorder(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(8),
                                                                borderSide: const BorderSide(
                                                                    color: ConstColour
                                                                        .primaryColor),
                                                              ),
                                                              focusedBorder:
                                                              const OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: ConstColour
                                                                        .primaryColor),
                                                                borderRadius:
                                                                BorderRadius.all(
                                                                    Radius
                                                                        .circular(
                                                                        8)),
                                                              ),
                                                              errorBorder:
                                                              OutlineInputBorder(
                                                                borderRadius:
                                                                BorderRadius
                                                                    .circular(8),
                                                                borderSide: const BorderSide(
                                                                    color: ConstColour
                                                                        .primaryColor),
                                                              ),
                                                              border:
                                                              InputBorder.none,
                                                              filled: true,
                                                              labelText: "Notes",
                                                              hintText:
                                                              "Enter your notes",
                                                              floatingLabelStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                              hintStyle: const TextStyle(
                                                                  color: Colors.grey,
                                                                  fontFamily: ConstFont
                                                                      .poppinsRegular,
                                                                  fontSize: 16,
                                                                  overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                            ),
                                                            minLines: 3,
                                                            maxLines: 4,
                                                            style: const TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 16,
                                                                fontFamily: ConstFont
                                                                    .poppinsRegular),
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
                                    }else{
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                          builder: (context, setState) {
                                            setState(() {},);
                                            return Dialog(
                                              insetAnimationDuration:
                                              const Duration(seconds: 1),
                                              insetAnimationCurve: Curves.linear,
                                              shadowColor: ConstColour.primaryColor,
                                              backgroundColor: Colors.black45,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: ConstColour.bgColor,
                                                  borderRadius:
                                                  BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: ConstColour.primaryColor,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.4),
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
                                                        padding: EdgeInsets.only(
                                                          bottom:
                                                          deviceHeight * 0.01,
                                                          top: deviceHeight * 0.01,
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Text(
                                                                "  Code : ${userListController.userList[index].code}",
                                                                style: const TextStyle(
                                                                    fontSize: 16,
                                                                    color: Colors
                                                                        .white,
                                                                    fontFamily:
                                                                    ConstFont
                                                                        .poppinsMedium)),
                                                            IconButton(
                                                                onPressed: () {
                                                                  FlutterClipboard.copy(
                                                                      userListController
                                                                          .userList[
                                                                      index]
                                                                          .code);
                                                                  Utils()
                                                                      .toastMessage(
                                                                      "Copied");
                                                                },
                                                                icon: const Icon(
                                                                  Icons.copy,
                                                                  color: ConstColour
                                                                      .appBar,
                                                                  size: 20,
                                                                )),
                                                            IconButton(
                                                                onPressed: () {
                                                                  Get.back();
                                                                },
                                                                icon: const Icon(
                                                                  Icons
                                                                      .cancel_outlined,
                                                                  color: ConstColour
                                                                      .primaryColor,
                                                                  size: 24,
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            top:
                                                            deviceHeight * 0.02,
                                                            left:
                                                            deviceWidth * 0.03,
                                                            right:
                                                            deviceWidth * 0.03),
                                                        child: TextFormField(
                                                          autovalidateMode:
                                                          AutovalidateMode
                                                              .onUserInteraction,
                                                          textAlign:
                                                          TextAlign.start,
                                                          keyboardType:
                                                          TextInputType.text,
                                                          autocorrect: true,
                                                          controller:
                                                          userListController
                                                              .notesController,
                                                          validator: (value) {
                                                            if (value!.trim()
                                                                .isEmpty) {
                                                              return "Please Enter Notes";
                                                            } else {
                                                              return null;
                                                            }
                                                          },
                                                          decoration:
                                                          InputDecoration(
                                                            labelStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                            enabledBorder:
                                                            OutlineInputBorder(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                              borderSide: const BorderSide(
                                                                  color: ConstColour
                                                                      .textFieldBorder),
                                                            ),
                                                            disabledBorder:
                                                            OutlineInputBorder(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                              borderSide: const BorderSide(
                                                                  color: ConstColour
                                                                      .textFieldBorder),
                                                            ),
                                                            focusedErrorBorder:
                                                            OutlineInputBorder(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                              borderSide: const BorderSide(
                                                                  color: ConstColour
                                                                      .primaryColor),
                                                            ),
                                                            focusedBorder:
                                                            const OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: ConstColour
                                                                      .primaryColor),
                                                              borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                      8)),
                                                            ),
                                                            errorBorder:
                                                            OutlineInputBorder(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                              borderSide: const BorderSide(
                                                                  color: ConstColour
                                                                      .textFieldBorder),
                                                            ),
                                                            border:
                                                            InputBorder.none,
                                                            filled: true,
                                                            labelText: "Notes",
                                                            hintText:
                                                            "Enter your notes",
                                                            floatingLabelStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .white),
                                                            hintStyle: const TextStyle(
                                                                color: Colors.grey,
                                                                fontFamily: ConstFont
                                                                    .poppinsRegular,
                                                                fontSize: 16,
                                                                overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                          ),
                                                          minLines: 3,
                                                          maxLines: 4,
                                                          style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 16,
                                                              fontFamily: ConstFont
                                                                  .poppinsRegular),
                                                        ),
                                                      ),

                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: NextButtonSec(
                                                          btnName: "Update",
                                                          onPressed: () {
                                                            if (_formKey
                                                                .currentState!
                                                                .validate()) {
                                                              homeController
                                                                  .loadingSec
                                                                  .value = true;
                                                              userListController.assignUpdate(
                                                                  userListController.userList[index].id,
                                                                  userListController.userList[index].userId,
                                                                  userListController.notesController.text,
                                                                  userListController.userList[index].needToReassign
                                                              );
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
                                  }}

                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  border:
                                      Border.all(color: ConstColour.primaryColor),
                                  borderRadius: BorderRadius.circular(11),
                                  // boxShadow: const [
                                  //   BoxShadow(
                                  //     // color: Colors.grey.withOpacity(0.5),
                                  //     color: ConstColour.primaryColor,
                                  //     spreadRadius: 1,
                                  //     blurRadius: 5,
                                  //     offset: Offset(0, 1),
                                  //   ),
                                  // ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
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
                                          Image.asset(
                                            imageStr.toString(),
                                            width: deviceWidth * 0.07,
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
                                                  MainAxisAlignment.end,
                                              children: [
                                                ElevatedButton(
                                                    style:
                                                        ElevatedButton.styleFrom(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                      minimumSize: Size(
                                                          deviceWidth * 0.2,
                                                          deviceHeight * 0.03),
                                                      maximumSize: Size(
                                                          deviceWidth * 0.31,
                                                          deviceHeight * 0.04),
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      elevation: 3.0,
                                                      // shadowColor: Colors.white,
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
                                                                        seconds:
                                                                            1),
                                                                insetAnimationCurve:
                                                                    Curves.linear,
                                                                shadowColor:
                                                                    ConstColour
                                                                        .primaryColor,
                                                                backgroundColor:
                                                                    Colors
                                                                        .black45,
                                                                child: Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: ConstColour
                                                                        .bgColor,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                8),
                                                                    border: Border
                                                                        .all(
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
                                                                              top:
                                                                                  deviceHeight * 0.01),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsets.only(right: deviceWidth * 0.1),
                                                                                child: Text("Code : ${userListController.userList[index].code}", style: const TextStyle(fontSize: 16, color: Colors.white, fontFamily: ConstFont.poppinsMedium)),
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
                                                                              if (value!.isEmpty) {
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
                                                                                borderRadius: BorderRadius.circular(8),
                                                                                borderSide: const BorderSide(color: ConstColour.textFieldBorder),
                                                                              ),
                                                                              disabledBorder:
                                                                                  OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(8),
                                                                                borderSide: const BorderSide(color: ConstColour.textFieldBorder),
                                                                              ),
                                                                              focusedErrorBorder:
                                                                                  OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(8),
                                                                                borderSide: const BorderSide(color: ConstColour.primaryColor),
                                                                              ),
                                                                              focusedBorder:
                                                                                  const OutlineInputBorder(
                                                                                borderSide: BorderSide(color: ConstColour.primaryColor),
                                                                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                                                              ),
                                                                              errorBorder:
                                                                                  OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(8),
                                                                                borderSide: const BorderSide(color: ConstColour.textFieldBorder),
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
                                                                                color: Colors.white,
                                                                                fontSize: 16,
                                                                                fontFamily: ConstFont.poppinsRegular),
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

                                                                              userListController.assignCancel(userListController.userList[index].id,
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
                                                    child: const Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                          fontFamily: ConstFont
                                                              .poppinsRegular,
                                                          color: Colors.redAccent,
                                                          fontSize: 14),
                                                    )),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: deviceWidth * 0.02),
                                                  child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              minimumSize: Size(
                                                                  deviceWidth *
                                                                      0.2,
                                                                  deviceHeight *
                                                                      0.03),
                                                              maximumSize: Size(
                                                                  deviceWidth *
                                                                      0.31,
                                                                  deviceHeight *
                                                                      0.04),
                                                              elevation: 3.0,
                                                              // shadowColor: Colors.white,
                                                              backgroundColor:
                                                                  Colors.green
                                                                      .shade600),
                                                      onPressed: () {
                                                        showCupertinoModalPopup(
                                                          filter: const ColorFilter
                                                              .mode(
                                                              ConstColour
                                                                  .primaryColor,
                                                              BlendMode.clear),
                                                          semanticsDismissible:
                                                              false,
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),

                                                              shadowColor:
                                                                  Colors.white,
                                                              elevation: 8.0,
                                                              // backgroundColor: Colors.white,
                                                              backgroundColor:
                                                                  Colors.orange
                                                                      .shade100,
                                                              title: const Text(
                                                                'Order',
                                                                style: TextStyle(
                                                                  fontSize: 22,
                                                                  fontFamily:
                                                                      ConstFont
                                                                          .poppinsMedium,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              content: const Text(
                                                                'Are you sure, want to Complete Order?',
                                                                style: TextStyle(
                                                                  fontFamily:
                                                                      ConstFont
                                                                          .poppinsRegular,
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              actions: [
                                                                InkWell(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  onTap: () {
                                                                    Get.back();
                                                                  },
                                                                  splashColor:
                                                                      ConstColour
                                                                          .btnHowerColor,
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            // gradient: const LinearGradient(colors: [Colors.white,Colors.black26]),
                                                                            borderRadius: BorderRadius.circular(
                                                                                5),
                                                                            color:
                                                                                Colors.red),
                                                                    child:
                                                                        const Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              6.0),
                                                                      child: Text(
                                                                        'Cancel',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              ConstFont.poppinsRegular,
                                                                          fontSize:
                                                                              12,
                                                                          color: Colors
                                                                              .white,
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  onTap: () {
                                                                    userListController.assignComplete(
                                                                        userListController
                                                                            .userList[
                                                                                index]
                                                                            .id);
                                                                    Get.back();
                                                                  },
                                                                  splashColor:
                                                                      ConstColour
                                                                          .btnHowerColor,
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            // gradient: const LinearGradient(colors: [Colors.white,Colors.black26]),
                                                                            borderRadius: BorderRadius.circular(
                                                                                5),
                                                                            color:
                                                                                Colors.black),
                                                                    child:
                                                                        const Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              6.0),
                                                                      child: Text(
                                                                        '    Ok    ',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              ConstFont.poppinsRegular,
                                                                          fontSize:
                                                                              12,
                                                                          color: Colors
                                                                              .white,
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: const Text(
                                                        "Complete",
                                                        style: TextStyle(
                                                            fontFamily: ConstFont
                                                                .poppinsRegular,
                                                            color: Colors.white,
                                                            fontSize: 14),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
          ),
        ),
      ),
    );
  }
}
