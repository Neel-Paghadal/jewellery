import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstColour.bgColor,
        centerTitle: true,
        title: Text(
          "User List",
          style: TextStyle(
            color: Colors.white,
            fontFamily: ConstFont.poppinsRegular,
            fontSize: 22,
            fontWeight: FontWeight.w500,
            overflow: TextOverflow.ellipsis)),
        leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_back_ios),
          color: ConstColour.primaryColor),
      ),
      bottomNavigationBar: Padding(
          padding: EdgeInsets.all(8.0),
        child: NextButton(
          onPressed: () {},
          btnName: "Assign User",
        ),
      ),
      backgroundColor: ConstColour.bgColor,
      body: SingleChildScrollView(
        controller: ScrollController(),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            ListView.builder(
              controller: ScrollController(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: userListController.userlists.length,
              itemBuilder: (BuildContext context, index) {

                Color buttonColor = ConstColour.offerImageColor;

                if(userListController.userlists[index].btnName == "In Progress") {
                  buttonColor = ConstColour.offerImageColor;
                } else if(userListController.userlists[index].btnName == "Completed") {
                  buttonColor = ConstColour.greenColor;
                } else if(userListController.userlists[index].btnName == "Cancelled") {
                  buttonColor = ConstColour.quantityRemove;
                } else if(userListController.userlists[index].btnName == "Pending") {
                  buttonColor = Colors.yellow;
                }

                return Padding(
                    padding: EdgeInsets.all(8.0),
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
                            padding: EdgeInsets.all(15.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(21),
                              ),
                              child: Text(
                                userListController.userlists[index].name,
                                style: TextStyle(
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
                                  userListController.userlists[index].btnName,
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
          ],
        ),
      ),
    );
  }
}
