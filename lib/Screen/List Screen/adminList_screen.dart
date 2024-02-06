import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/Common/bottom_button_widget.dart';
import 'package:jewellery_user/ConstFile/constColors.dart';
import 'package:jewellery_user/ConstFile/constFonts.dart';
import 'package:jewellery_user/Controller/User_Controller/adminList_controller.dart';
import 'package:jewellery_user/Controller/home_Controller.dart';
import 'package:jewellery_user/Screen/home.dart';
import 'package:jewellery_user/Screen/loader.dart';
import 'package:jewellery_user/Screen/newUser_register.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../../Models/adminList_model.dart';

class AdminListScreen extends StatefulWidget {
  const AdminListScreen({super.key});

  @override
  State<AdminListScreen> createState() => _AdminListScreenState();
}

class _AdminListScreenState extends State<AdminListScreen> {
  ScrollController _scrollController = ScrollController();
  AdminListController adminListController = Get.put(AdminListController());
  HomeController homeController = Get.put(HomeController());

  int _pageIndex = 0;
  int _pageSize = 10;
  bool _loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    adminListController.adminList.clear();
    _loadProducts();
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
                  padding: EdgeInsets.all(6.0),
                  child: Text(
                    'Release',
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

  Future<void> _handleRefresh() async {
    _pageIndex = 1;
    _pageSize = 10;

    adminListController.adminList.clear();
    adminListController.getAdminCall(
      _pageIndex,
      _pageSize,
    );
    debugPrint("ScreenRefresh");
    return await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> _loadProducts() async {
    setState(() {
      _loading = true;
    });
    _pageIndex++;

    debugPrint("Page Order index$_pageIndex");
    try {
      final RxList<AdminDetail> products =
          await adminListController.getAdminCall(
        _pageIndex,
        _pageSize,
      );
      setState(() {
        adminListController.adminList.addAll(products);
      });
    } catch (e) {
      // Handle errors
      debugPrint('Error loading products: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // User has reached the end of the list, load more products
      _loadProducts();
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
        title: const Text("Admins",
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: NextButton(
          onPressed: () {
            Get.to(() => const NewUserRegister());
          },
          btnName: "Add New Admin",
        ),
      ),
      body: LiquidPullToRefresh(
        color: Colors.black,
        height: deviceHeight * 0.08,
        onRefresh: _handleRefresh,
        showChildOpacityTransition: false,
        backgroundColor: ConstColour.primaryColor,
        springAnimationDurationInMilliseconds: 1,
        child: Container(
          child: adminListController.adminList.isEmpty
              ? Container(
                  child: adminListController.isLoaderShow.value == true
                      ? Loaders(
                          items: 12,
                          direction: LoaderDirection.ltr,
                          baseColor: Colors.grey,
                          highLightColor: Colors.white,
                          builder: Padding(
                            padding: EdgeInsets.only(right: deviceWidth * 0.01),
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
                  controller: _scrollController,
                  itemCount:
                      adminListController.adminList.length + (_loading ? 1 : 0),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    if (index == adminListController.adminList.length) {
                      // Loading indicator
                      return _loading
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
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



                          shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: ConstColour.primaryColor),
                              borderRadius: BorderRadius.circular(21)),
                          title: Text(
                            "👤 " +
                                adminListController.adminList[index].firstName +
                                " " +
                                adminListController.adminList[index].lastName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: ConstFont.poppinsMedium),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            "✆  ${adminListController.adminList[index].mobileNumber}",
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
                              side: BorderSide(
                                color: ConstColour.primaryColor
                              ),
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
                                    releaseDeviceDialog(context, adminListController.adminList[index].id);
                                  },
                                  child: Text("Release",style: TextStyle(color: Colors.black,fontSize: 16,fontFamily: ConstFont.poppinsMedium),overflow: TextOverflow.ellipsis),
                                  value: '/Release',
                                ),
                                PopupMenuItem(
                                  enabled: false,
                                  onTap: () {

                                  },
                                  child: Text("Forgot Password",style: TextStyle(color: Colors.black,fontSize: 16,fontFamily: ConstFont.poppinsMedium),overflow: TextOverflow.ellipsis),
                                  value: '/Forgot Password',
                                ),
                              ];
                            },
                          )),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
