import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/Common/bottom_button_widget.dart';
import 'package:jewellery_user/ConstFile/constColors.dart';
import 'package:jewellery_user/ConstFile/constFonts.dart';
import 'package:jewellery_user/Controller/home_Controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ConstColour.bgColor,
          centerTitle: true,
          actions: [
            TextButton(onPressed: () {

            }, child: Text("Report",style: TextStyle(
      color: ConstColour.primaryColor,
          fontFamily: ConstFont.poppinsBold,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          overflow: TextOverflow.ellipsis)))

          ],
          title: const Text("Dashboard",style: TextStyle(
              color: Colors.white,
              fontFamily: ConstFont.poppinsRegular,
              fontSize: 22,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis)),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: NextButton(onPressed: () {
            homeController.getOrderCall();
          },btnName: "Add Design",
          ),
        ),
        backgroundColor: ConstColour.bgColor,
        body: SingleChildScrollView(
          controller: ScrollController(),
          scrollDirection: Axis.vertical,
          child: Column(children: [
            ListView.builder(
              controller: ScrollController(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: 15,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: ConstColour.primaryColor),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(21),
                            ),
                            child: Image.asset("asset/images/jeweller.png",
                                width: deviceWidth * 0.3),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: deviceHeight * 0.01,),
                              child: Text(
                                "Manga Mala",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: ConstFont.poppinsRegular),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: deviceHeight * 0.015,bottom: deviceHeight * 0.015),
                              child: Text(
                                "Create Date : 02/01/2024",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontFamily: ConstFont.poppinsRegular),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ConstColour.primaryColor,
                                    ),
                                    onPressed: () {},
                                    child: Text(
                                      "Genrate Code",
                                      style: TextStyle(
                                          fontFamily: ConstFont.poppinsBold,
                                          color: Colors.black),
                                    )),
                                Padding(
                                  padding:  EdgeInsets.only(left: deviceWidth * 0.1),
                                  child: Text(
                                    "USERS",
                                    style: TextStyle(
                                        color: ConstColour.primaryColor,
                                        fontSize: 14,
                                        fontFamily: ConstFont.poppinsMedium),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),

                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            )
          ]),
        ),
      ),
    );
  }
}
