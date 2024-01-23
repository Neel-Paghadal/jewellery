import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/ConstFile/constColors.dart';
import 'package:jewellery_user/ConstFile/constPreferences.dart';
import 'package:jewellery_user/Controller/User_Controller/productdetail_controller.dart';
import 'package:jewellery_user/Controller/User_Controller/user_home_con.dart';
import 'package:jewellery_user/Screen/auth_screen/login.dart';
import '../../ConstFile/constFonts.dart';
import 'prodcut_detail.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  UserHomeCon userHomeCon = Get.put(UserHomeCon());
  UserProductController userProductController =
      Get.put(UserProductController());
  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ConstColour.bgColor,
      appBar: AppBar(
        backgroundColor: ConstColour.bgColor,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              ConstPreferences().clearPreferences();
              Get.to(() => LoginScreen());
            },
            icon: Icon(Icons.exit_to_app)),
        title: Text('dashboard'.tr,
            style: const TextStyle(
                color: Colors.white,
                fontFamily: ConstFont.poppinsRegular,
                fontSize: 22,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis)),
        actions: [
          // Padding(
          //   padding: EdgeInsets.only(right:deviceWidth * 0.01),
          //   child: IconButton(onPressed: () {
          //
          //   }, icon: Image.asset("asset/icons/languages.png",width: deviceWidth * 0.1,)),
          // )
          Flexible(
            child: DropdownButton(
              dropdownColor: const Color(0xff3D3542),
              alignment: Alignment.bottomRight,
              borderRadius: BorderRadius.circular(5),
              underline: Container(),
              icon: const Icon(
                Icons.arrow_drop_down,
                size: 30,
              ),
              iconEnabledColor: Colors.white,
              // isExpanded: true,
              value: userHomeCon.selectedItem,
              hint: Text(userHomeCon.selectedItem.toString(),
                  style: const TextStyle(color: Colors.white)),

              onChanged: (newValue) {
                setState(() {
                  userHomeCon.selectedItem = newValue!;
                  if (newValue == "English") {
                    ConstPreferences().setLanguages('English');
                    Get.updateLocale(const Locale('en', 'US'));
                  } else if (newValue == "ગુજરાતી") {
                    setState(() {
                      ConstPreferences().setLanguages('ગુજરાતી');
                      Get.updateLocale(const Locale('gu', 'IN'));
                    });
                  } else if (newValue == "हिंदी") {
                    setState(() {
                      ConstPreferences().setLanguages('हिंदी');
                      Get.updateLocale(const Locale('hi', 'IN'));
                    });
                  }
                });
                debugPrint(userHomeCon.selectedItem);
              },
              items: userHomeCon.itemSort.map((sort) {
                return DropdownMenuItem(
                  value: sort,
                  child: Text(
                    sort,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => userHomeCon.userHome.isEmpty
                    ? Text(
                        "noData".tr,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: ConstFont.poppinsRegular),
                        overflow: TextOverflow.ellipsis,
                      )
                    : ListView.builder(
                        controller: ScrollController(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: userHomeCon.userHome.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              onTap: () {
                                userProductController.orderUserId =
                                    userHomeCon.userHome[index].orderUserId;
                                debugPrint("Order userId : " +
                                    userProductController.orderUserId);
                                userProductController.getProductDetailCall(
                                    userHomeCon.userHome[index].id);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(
                                    color: ConstColour.primaryColor),
                              ),
                              leading: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Image.asset(
                                      "asset/images/jeweller.png",
                                      width: deviceWidth * 0.1,
                                    ),
                                  )),
                              title: Text(
                                userHomeCon.userHome[index].name,
                                style: const TextStyle(
                                  fontFamily: ConstFont.poppinsRegular,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                "createdate".tr +
                                    userHomeCon.userHome[index].deliveryDate,
                                style: const TextStyle(
                                  fontFamily: ConstFont.poppinsRegular,
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              cursorColor: ConstColour.errorImage,
              keyboardType: TextInputType.text,
              controller: userHomeCon.codeController,
              style: TextStyle(
                height: deviceHeight * 0.001,
                color: ConstColour.errorImage,
                fontSize: 15,
                fontFamily: ConstFont.poppinsRegular,
                overflow: TextOverflow.ellipsis,
              ),
              onChanged: (value) {
                userHomeCon.userHome.clear();
              },
              decoration: InputDecoration(
                fillColor: ConstColour.searchColor,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: BorderSide.none),
                hintText: 'EnterCode'.tr,
                hintStyle: const TextStyle(
                  color: ConstColour.errorImage,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: ConstFont.poppinsRegular,
                ),
                suffixIcon: TextButton(
                  style: TextButton.styleFrom(
                      // minimumSize: Size(deviceWidth * 0.1, deviceHeight * 0.04),
                      maximumSize:
                          Size(deviceWidth * 0.4, deviceHeight * 0.05)),
                  onPressed: () {
                    userHomeCon.getProductCall(userHomeCon.codeController.text);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.black,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: deviceWidth * 0.03,
                          vertical: deviceHeight * 0.003),
                      child: Text(
                        'Apply'.tr,
                        style: const TextStyle(
                            color: ConstColour.primaryColor,
                            fontSize: 14,
                            fontFamily: ConstFont.poppinsRegular),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
