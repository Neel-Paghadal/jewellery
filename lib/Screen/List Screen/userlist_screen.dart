import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/ConstFile/constColors.dart';
import 'package:jewellery_user/ConstFile/constFonts.dart';
import 'package:jewellery_user/Controller/User_Controller/adminList_controller.dart';
import 'package:jewellery_user/Controller/home_Controller.dart';
import 'package:jewellery_user/Controller/userProfileDetail_controller.dart';
import 'package:jewellery_user/Controller/userlistScreen_controller.dart';
import 'package:jewellery_user/Models/userDetail_model.dart';
import 'package:jewellery_user/Screen/List%20Screen/deleteUserAdminDialouge.dart';
import 'package:jewellery_user/Screen/List%20Screen/forgot_password_dialog.dart';
import 'package:jewellery_user/Screen/List%20Screen/userDetail_screen.dart';
import 'package:jewellery_user/Screen/loader.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'dart:math';


class StickyColors {
  static final List colors = [
    const Color(0xffF1F7E6),
    const Color(0xffF4F5F0),
    const Color(0xffF2DAC1),
    const Color(0xffF8EEEC),
    const Color(0xffFFF7E7),
    const Color(0xffEDF4FA),
    const Color(0xffFBFBF9),
    const Color(0xffEEE8E6),
    const Color(0xffFFF2D0),
    const Color(0xffE6DBAC),
    const Color(0xffEDE8BA),
    const Color(0xffFDEFB2),
    const Color(0xffF8F8E8),
    const Color(0xffF2F7FD),
    const Color(0xffFDEFB2),
    const Color(0xffFEC5E5),
  ];
}
class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}



class _UserListState extends State<UserList> {
  ScrollController _scrollController = ScrollController();
  UserListScreenController userListScreenController = Get.put(UserListScreenController());
  UserProfileDetailController userProfileController = Get.put(UserProfileDetailController());
  AdminListController adminListController = Get.put(AdminListController());
  HomeController homeController = Get.put(HomeController());
  int _pageIndex = 0;
  int _pageSize = 10;
  bool _loading = false;
  final _random = Random();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userListScreenController.loadProducts();
    _scrollController.addListener(_onScroll);
  }

  void releaseDeviceDialog(BuildContext context, String userID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          shadowColor: Colors.white,
          elevation: 8.0,
          // backgroundColor: Colors.white,
          backgroundColor: Colors.orange.shade100,
          title: const Text(
            'Release Device',
            style: TextStyle(
              fontSize: 22,
              fontFamily: ConstFont.poppinsMedium,
              color: Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          content: const Text(
            'Are you sure, want to release device?',
            style: TextStyle(
              fontFamily: ConstFont.poppinsRegular,
              fontSize: 16,
              color: Colors.black,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: () {
                Get.back();
              },
              splashColor: ConstColour.btnHowerColor,
              child: Container(
                decoration: BoxDecoration(
                    // gradient: const LinearGradient(colors: [Colors.white,Colors.black26]),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.red),
                child: const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: ConstFont.poppinsRegular,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: () {
                Get.back();
              },
              splashColor: ConstColour.btnHowerColor,
              child: TextButton(
                onPressed: () {
                  adminListController.releaseDeviceCall(userID);
                  Get.back();
                },
                child: const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text(
                    '  Yes  ',
                    style: TextStyle(
                      fontFamily: ConstFont.poppinsMedium,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Future<void> _handleRefresh() async {
  //   _pageIndex = 1;
  //   _pageSize = 10;
  //
  //   userListScreenController.usersList.clear();
  //   userListScreenController.getUserCall(
  //     _pageIndex,
  //     _pageSize,
  //   );
  //   debugPrint("ScreenRefresh");
  //   return await Future.delayed(const Duration(seconds: 1));
  // }

  // Future<void> _loadProducts() async {
  //   setState(() {
  //     _loading = true;
  //   });
  //   _pageIndex++;
  //
  //   debugPrint("Page Order index$_pageIndex");
  //   try {
  //     final RxList<UserDetail> products =
  //         await userListScreenController.getUserCall(
  //       _pageIndex,
  //       _pageSize,
  //     );
  //     setState(() {
  //       userListScreenController.usersList.addAll(products);
  //     });
  //   } catch (e) {
  //     // Handle errors
  //     debugPrint('Error loading products: $e');
  //   } finally {
  //     setState(() {
  //       _loading = false;
  //     });
  //   }
  // }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // User has reached the end of the list, load more products
      // _loadProducts();
      userListScreenController.loadProducts();
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
        title: const Text("Users",
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

      body: Obx(
        () => LiquidPullToRefresh(
          color: Colors.black,
          height: deviceHeight * 0.08,
          onRefresh: userListScreenController.handleRefresh,
          showChildOpacityTransition: false,
          backgroundColor: ConstColour.primaryColor,
          springAnimationDurationInMilliseconds: 1,
          child: Container(
            child: userListScreenController.usersList.isEmpty
                ? Container(
                    child: userListScreenController.isLoaderShow.value == true
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
                                        borderRadius: BorderRadius.circular(8),
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
                        : const Center(
                            child: Text(
                              "No Data Found",
                              style: TextStyle(
                                  fontFamily: ConstFont.poppinsMedium,
                                  color: Colors.white,
                                  fontSize: 16),
                            ),
                          ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: userListScreenController.usersList.length + (userListScreenController.loadingPage.value ? 1 : 0),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      if (index == userListScreenController.usersList.length) {
                        // Loading indicator
                        return userListScreenController.loadingPage.value
                            ? Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: Center(
                                  widthFactor: deviceWidth * 0.1,
                                  child: const CircularProgressIndicator(
                                      color: ConstColour.primaryColor),
                                ),
                              )
                            : Container();
                      }

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () {
                            userProfileController.userId = userListScreenController.usersList[index].id;
                            Get.to(() => UserDetailScreen());
                          },
                            splashColor: ConstColour.btnHowerColor,
                            leading: Container(
                              width: deviceWidth * 0.13,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:  StickyColors.colors[_random.nextInt(15)]
                                ),
                                child: Center(
                                  child: Text(userListScreenController.usersList[index].firstName.substring(0,1).toUpperCase(),style: TextStyle(
                                      color: Colors.black,fontSize: 20,fontFamily: ConstFont.poppinsMedium),),
                                )),
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: ConstColour.primaryColor),
                                borderRadius: BorderRadius.circular(21)),
                            title: Text(
                              " ${userListScreenController.usersList[index].firstName} ${userListScreenController.usersList[index].lastName}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: ConstFont.poppinsMedium),
                              overflow: TextOverflow.ellipsis,
                            ),
                            dense: true,
                            subtitle: Text(
                              " ${userListScreenController.usersList[index].mobileNumber}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: ConstFont.poppinsMedium),
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: PopupMenuButton(
                              tooltip: 'Options',
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(
                                    color: ConstColour.primaryColor),
                              ),
                              elevation: 5.0,
                              enableFeedback: true,
                              shadowColor: ConstColour.primaryColor,
                              iconSize: 24,
                              color: Colors.white,
                              iconColor: ConstColour.primaryColor,
                              onSelected: (value) {
                                // your logic
                                debugPrint(value);
                              },
                              itemBuilder: (BuildContext bc) {
                                return [
                                  PopupMenuItem(
                                    enabled: true,
                                    onTap: () {
                                      debugPrint(userListScreenController
                                          .usersList[index].firstName);
                                      releaseDeviceDialog(
                                          context,
                                          userListScreenController
                                              .usersList[index].id);
                                    },
                                    value: '/Release',
                                    child: const Text("Release",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily:
                                                ConstFont.poppinsMedium),
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  PopupMenuItem(
                                    enabled: true,
                                    onTap: () {
                                      forgotPasswordDialouge(context, userListScreenController.usersList[index].id);
                                    },
                                    value: '/Reset Password',
                                    child: const Text("Reset Password",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily:
                                                ConstFont.poppinsMedium),
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  PopupMenuItem(
                                    enabled: true,
                                    onTap: () {

                                      deleteUserDialoge(context, userListScreenController.usersList[index].id);

                                    },
                                    value: '/Delete User',
                                    child: const Text("Delete User",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily:
                                                ConstFont.poppinsMedium),
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ];
                              },
                            )),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
