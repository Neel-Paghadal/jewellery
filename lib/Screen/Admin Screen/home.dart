import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/ConstFile/constColors.dart';
import 'package:jewellery_user/ConstFile/constFonts.dart';
import 'package:jewellery_user/Controller/home_Controller.dart';
import 'package:jewellery_user/Controller/newRegister_controller.dart';
import 'package:jewellery_user/Controller/order_controller.dart';
import 'package:jewellery_user/Controller/product_controller.dart';
import 'package:jewellery_user/Controller/user_list_controller.dart';
import 'package:jewellery_user/Screen/Admin%20Screen/multiOrderDelete.dart';
import 'package:jewellery_user/Screen/List%20Screen/adminList_screen.dart';
import 'package:jewellery_user/Screen/List%20Screen/userlist_screen.dart';
import 'package:jewellery_user/Screen/loader.dart';
import 'package:jewellery_user/Screen/Admin%20Screen/productdetail.dart';
import 'package:jewellery_user/Screen/videoplayer_screen.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../../ConstFile/constPreferences.dart';
import 'order.dart';
import 'report_search_Screen.dart';
import 'user_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.put(HomeController());
  final ScrollController _scrollController = ScrollController();
  UserListController userListController = Get.put(UserListController());
  ProductController productController = Get.put(ProductController());
  NewRegisterCon newRegisterCon = Get.put(NewRegisterCon());
  OrderController orderController = Get.put(OrderController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    homeController.loadProducts();
    _scrollController.addListener(_onScroll);
    homeController.checkUser();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // User has reached the end of the list, load more products
      homeController.loadProducts();
    }
  }

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
          backgroundColor: ConstColour.black,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            /*IconButton(onPressed: () {
              Get.to(() => const ReportSearchScreen());
            }, icon: Image.asset("asset/icons/statistics.png"), color: Colors.white,)*/

            Tooltip(
              message: "Report",
              child: InkWell(
                  onTap: () {
                    Get.to(() => const ReportSearchScreen());
                  },
                  borderRadius: BorderRadius.circular(34),
                  child: Image.asset(
                    "asset/icons/statistics.png",
                    scale: 3,
                    color: Colors.white,
                  )),
            ),
          ],
          title: const Text("Dashboard",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: ConstFont.poppinsRegular,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis)),
        ),
        drawer: Drawer(
            backgroundColor: ConstColour.primaryColor,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: deviceHeight * 0.07,
                            bottom: deviceHeight * 0.02),
                        child: Image.asset("asset/images/men_chair.png",
                            width: deviceWidth * 0.5),
                      ),
                      Obx(
                        () => Visibility(
                          visible: homeController.isShow.value,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              tileColor: ConstColour.bgColor,
                              splashColor: ConstColour.btnHowerColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(
                                      color: ConstColour.primaryColor)),
                              onTap: () {
                                Get.back();
                                Get.to(() => const AdminListScreen());
                              },
                              trailing: const Icon(Icons.arrow_forward,
                                  size: 24, color: ConstColour.primaryColor),
                              title: const Text("Add New Admin",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: ConstFont.poppinsRegular,
                                  ),
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          tileColor: ConstColour.bgColor,
                          splashColor: ConstColour.btnHowerColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                  color: ConstColour.primaryColor)),
                          onTap: () {
                            Get.back();

                            Get.to(() => const UserList());
                          },
                          trailing: const Icon(Icons.arrow_forward,
                              size: 24, color: ConstColour.primaryColor),
                          title: const Text("User Directory",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily: ConstFont.poppinsRegular,
                              ),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      Obx(
                        () => Visibility(
                          visible: homeController.isShow.value,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              tileColor: ConstColour.bgColor,
                              splashColor: ConstColour.btnHowerColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(
                                      color: ConstColour.primaryColor)),
                              onTap: () {
                                Get.back();
                                deleteOrderDialog(context);
                              },
                              trailing: const Icon(Icons.delete,
                                  size: 24, color: ConstColour.primaryColor),
                              title: const Text("Delete Multi Order",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: ConstFont.poppinsRegular,
                                  ),
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          tileColor: ConstColour.bgColor,
                          splashColor: ConstColour.btnHowerColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                  color: ConstColour.primaryColor)),
                          onTap: () {
                            Get.back();
                            _showLogoutDialog(context);
                          },
                          trailing: const Icon(Icons.exit_to_app,
                              size: 24, color: ConstColour.primaryColor),
                          title: const Text("Log out",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily: ConstFont.poppinsRegular,
                              ),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    "Version 1.0.0",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: ConstFont.poppinsMedium),
                  )
                ])),
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: ConstColour.primaryColor,
            splashColor: ConstColour.btnHowerColor,
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {
              orderController.clearController();
              orderController.imageNotes = null;
              Get.to(() => const OrderScreen());
            },
            label: const Text(
              "Add Design",
              style: TextStyle(
                  fontFamily: ConstFont.poppinsMedium,
                  color: Colors.black,
                  fontSize: 16),
            )),
        backgroundColor: ConstColour.bgColor,
        body: Obx(
          () => LiquidPullToRefresh(
            color: Colors.black,
            height: deviceHeight * 0.08,
            onRefresh: homeController.handleRefresh,
            showChildOpacityTransition: false,
            backgroundColor: ConstColour.primaryColor,
            springAnimationDurationInMilliseconds: 1,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: homeController.homeList.isEmpty
                  ? Container(
                      child: homeController.isLoaderShow.value == true
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
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: ConstColour.primaryColor),
                                          borderRadius: BorderRadius.circular(11),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.image,
                                                size: 100,
                                                color: Colors.grey.shade400,
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: deviceHeight * 0.035),
                                                  child: Container(
                                                    height: deviceHeight * 0.01,
                                                    width: deviceWidth * 0.5,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: deviceHeight * 0.01),
                                                  child: Container(
                                                    height: deviceHeight * 0.01,
                                                    width: deviceWidth * 0.5,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: deviceWidth * 0.37,
                                                      top: deviceHeight * 0.035),
                                                  child: Container(
                                                    width: deviceWidth * 0.2,
                                                    height: deviceHeight * 0.01,
                                                    color: Colors.grey,
                                                  ),
                                                )
                                              ],
                                            )
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
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: deviceHeight * 0.125),
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              controller: _scrollController,
                              itemCount: homeController.homeList.length +
                                  (homeController.loadingPage.value ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == homeController.homeList.length) {
                                  // Loading indicator
                                  return homeController.loadingPage.value
                                      ? Padding(
                                          padding: const EdgeInsets.only(bottom: 30,top: 10),
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
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(11),
                                    onTap: () {
                                      productController.isFilterApplyed.value = false;
                                      Get.to(() => const ProductDetailScreen());
                                      productController.productIndex = index;
                                      productController.getProductDetailCall(
                                          homeController.homeList[index].id);
                                    },
                                    splashColor: ConstColour.btnHowerColor,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        border:
                                            Border.all(color: ConstColour.primaryColor),
                                        borderRadius: BorderRadius.circular(11),
                                      ),
                                      child: Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                                  height: deviceHeight * 0.13,
                                                  width: deviceWidth * 0.28,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(8),
                                                      color: Colors.white),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(8),
                                                    child: homeController
                                                            .homeList[index].image
                                                            .endsWith('.mp4')
                                                        ? VideoItem(
                                                            url: homeController
                                                                .homeList[index].image)
                                                        : CachedNetworkImage(
                                                            width: double.infinity,
                                                            fit: BoxFit.cover,
                                                            imageUrl: homeController
                                                                .homeList[index].image
                                                                .toString(),
                                                            fadeInCurve:
                                                                Curves.easeInOutQuad,
                                                            placeholder: (context,
                                                                    url) =>
                                                                const Icon(Icons.image,
                                                                    size: 65,
                                                                    color: ConstColour
                                                                        .loadImageColor),
                                                            errorWidget: (context, url,
                                                                    error) =>
                                                                const Icon(Icons.error,
                                                                    size: 45),
                                                          ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: ListTile(
                                                  contentPadding:
                                                      const EdgeInsets.all(0),
                                                  title: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            right: deviceWidth * 0.08),
                                                        child: Text(
                                                          homeController
                                                              .homeList[index].name,
                                                          style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 16,
                                                              fontFamily: ConstFont
                                                                  .poppinsRegular),
                                                          overflow:
                                                              TextOverflow.ellipsis,
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                      Text(
                                                        homeController
                                                            .homeList[index].orderId
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 14,
                                                            fontFamily: ConstFont
                                                                .poppinsRegular),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                  subtitle: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: deviceHeight * 0.032),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          homeController.homeList[index]
                                                              .dateCreated,
                                                          style: const TextStyle(
                                                              color: Colors.grey,
                                                              fontSize: 14,
                                                              fontFamily: ConstFont
                                                                  .poppinsRegular),
                                                          overflow:
                                                              TextOverflow.ellipsis,
                                                        ),
                                                        Text(
                                                          "${homeController.homeList[index].orderStatus}  ",
                                                          style: TextStyle(
                                                              color: (homeController
                                                                          .homeList[
                                                                              index]
                                                                          .orderStatus ==
                                                                      "Complete")
                                                                  ? ConstColour
                                                                      .completeColor
                                                                  : (homeController
                                                                              .homeList[
                                                                                  index]
                                                                              .orderStatus ==
                                                                          "Cancel")
                                                                      ? ConstColour
                                                                          .cancelColor
                                                                      : (homeController
                                                                                  .homeList[
                                                                                      index]
                                                                                  .orderStatus ==
                                                                              "Pending")
                                                                          ? ConstColour
                                                                              .pendingColor
                                                                          : (homeController
                                                                                      .homeList[
                                                                                          index]
                                                                                      .orderStatus ==
                                                                                  "Working")
                                                                              ? ConstColour
                                                                                  .workingColor
                                                                              : (homeController.homeList[index].orderStatus ==
                                                                                      "New")
                                                                                  ? ConstColour
                                                                                      .newColor
                                                                                  : Colors
                                                                                      .white,
                                                              fontSize: 14,
                                                              fontFamily: ConstFont
                                                                  .poppinsRegular),
                                                          overflow:
                                                              TextOverflow.ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              IconButton(
                                                  tooltip: "Assign Order",
                                                  onPressed: () {
                                                    userListController.orderId =
                                                        homeController
                                                            .homeList[index].id;
                                                    userListController.userList.clear();
                                                    Get.to(
                                                        () => const UserListScreen());
                                                  },
                                                  icon: const Icon(
                                                    CupertinoIcons.person_add_solid,
                                                    size: 30,
                                                    color: ConstColour.primaryColor,
                                                  )),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: deviceHeight * 0.03),
                                                child: IconButton(
                                                    tooltip: "Delete",
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder:
                                                            (BuildContext context) {
                                                          return AlertDialog(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                10)),
                                                            shadowColor: Colors.white,
                                                            elevation: 8.0,
                                                            // backgroundColor: Colors.white,
                                                            backgroundColor:
                                                                Colors.orange.shade100,
                                                            title: const Text(
                                                              'Delete Order',
                                                              style: TextStyle(
                                                                fontSize: 22,
                                                                fontFamily: ConstFont
                                                                    .poppinsMedium,
                                                                color: Colors.black,
                                                              ),
                                                              overflow:
                                                                  TextOverflow.ellipsis,
                                                            ),
                                                            content: const Text(
                                                              'Are you sure, want to delete order?',
                                                              style: TextStyle(
                                                                fontFamily: ConstFont
                                                                    .poppinsRegular,
                                                                fontSize: 16,
                                                                color: Colors.black,
                                                              ),
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow.ellipsis,
                                                            ),
                                                            actions: [
                                                              InkWell(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(5),
                                                                onTap: () {
                                                                  Get.back();
                                                                },
                                                                splashColor: ConstColour
                                                                    .btnHowerColor,
                                                                child: Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          // gradient: const LinearGradient(colors: [Colors.white,Colors.black26]),
                                                                          borderRadius:
                                                                              BorderRadius
                                                                                  .circular(
                                                                                      5),
                                                                          color: Colors
                                                                              .red),
                                                                  child: const Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            6.0),
                                                                    child: Text(
                                                                      'Cancel',
                                                                      style: TextStyle(
                                                                        fontFamily:
                                                                            ConstFont
                                                                                .poppinsRegular,
                                                                        fontSize: 12,
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
                                                                        .circular(5),
                                                                onTap: () {},
                                                                splashColor: ConstColour
                                                                    .btnHowerColor,
                                                                child: TextButton(
                                                                  onPressed: () {
                                                                    homeController
                                                                        .orderDeleteCall(
                                                                            homeController
                                                                                .homeList[
                                                                                    index]
                                                                                .id);
                                                                    Get.back();
                                                                  },
                                                                  child: const Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            2.0),
                                                                    child: Text(
                                                                      '  Yes  ',
                                                                      style: TextStyle(
                                                                        fontFamily:
                                                                            ConstFont
                                                                                .poppinsMedium,
                                                                        fontSize: 14,
                                                                        color: Colors
                                                                            .black,
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
                                                    icon: const Icon(
                                                      CupertinoIcons.delete,
                                                      size: 24,
                                                      color: Colors.white,
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                        ),
                      ),
                    ],
                  ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          shadowColor: Colors.white,
          elevation: 8.0,
          backgroundColor: Colors.white,
          title: const Text(
            'Logout',
            style: TextStyle(
              fontSize: 22,
              fontFamily: ConstFont.poppinsMedium,
              color: Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          content: const Text(
            'Are you sure, want to logout?',
            style: TextStyle(
              fontFamily: ConstFont.poppinsRegular,
              fontSize: 16,
              color: Colors.black,
            ),
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
                  ConstPreferences().clearPreferences();
                  SystemNavigator.pop();
                },
                child: const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontFamily: ConstFont.poppinsMedium,
                      fontSize: 13,
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
}
