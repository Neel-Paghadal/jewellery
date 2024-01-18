import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/ConstFile/constColors.dart';
import 'package:jewellery_user/Controller/User_Controller/user_home_con.dart';

import '../../ConstFile/constFonts.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {

  UserHomeCon userHomeCon = Get.put(UserHomeCon());

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ConstColour.bgColor,
      appBar: AppBar(
          backgroundColor: ConstColour.bgColor,
          centerTitle: true,
          title: Text('dashboard'.tr,
              style: TextStyle(
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
              hint: Text(userHomeCon.selectedItem.toString(),style: const TextStyle(color: Colors.white)),

              onChanged: (newValue) {
                setState(() {
                  userHomeCon.selectedItem = newValue!;
                  if (newValue == "English") {
                    Get.updateLocale(Locale('en', 'US'));

                  } else if (newValue == "ગુજરાતી") {
                    setState(() {
                      Get.updateLocale(Locale('gu', 'IN'));
                    });
                  } else if (newValue == "हिंदी") {
                    setState(() {
                      Get.updateLocale(Locale('hi', 'IN'));

                    });
                  }
                });
                print(userHomeCon.selectedItem);
              },
              items: userHomeCon.itemSort.map((sort) {
                return DropdownMenuItem(
                  value: sort,
                  child: Text(sort,style:  const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500
                  ),),
                );
              }
              ).toList(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              cursorColor: ConstColour.errorImage,
              keyboardType: TextInputType.text,
              style: TextStyle(
                height: deviceHeight * 0.001,
                color: ConstColour.errorImage,
                fontSize: 15,
                fontFamily: ConstFont.poppinsRegular,
                overflow: TextOverflow.ellipsis,
              ),
              decoration: InputDecoration(
                fillColor: ConstColour.searchColor,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: BorderSide.none),
                hintText: 'EnterCode'.tr,
                hintStyle: TextStyle(
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
                  onPressed: () {},
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
                        style: TextStyle(
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
          ListView.builder(
            controller: ScrollController(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: userHomeCon.reportlist.length,
            itemBuilder: (context, index) {


              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: ConstColour.primaryColor),
                  ),
                  leading: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset("asset/images/jeweller.png",width: deviceWidth * 0.1,),
                      )),
                  title: Text(userHomeCon.reportlist[index].designCode,
                      style: TextStyle(fontFamily: ConstFont.poppinsRegular,fontSize: 14,color: Colors.white,),
                  overflow: TextOverflow.ellipsis,
                  ),
                  subtitle:  Text("createdate".tr+userHomeCon.reportlist[index].date,
                    style: TextStyle(fontFamily: ConstFont.poppinsRegular,fontSize: 14,color: Colors.grey,),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
