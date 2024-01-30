import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/Common/bottom_button_widget.dart';
import 'package:jewellery_user/ConstFile/constColors.dart';
import 'package:jewellery_user/ConstFile/constFonts.dart';
import 'package:jewellery_user/Controller/home_Controller.dart';
import 'package:jewellery_user/Controller/newRegister_controller.dart';
import 'package:jewellery_user/Controller/product_controller.dart';
import 'package:jewellery_user/Controller/user_list_controller.dart';
import 'package:jewellery_user/Screen/User_screen/List%20Screen/adminList_screen.dart';
import 'package:jewellery_user/Screen/User_screen/List%20Screen/userlist_screen.dart';
import 'package:jewellery_user/Screen/loader.dart';
import 'package:jewellery_user/Screen/productdetail.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../ConstFile/constPreferences.dart';
import '../Models/dashboard_model.dart';
import 'auth_screen/login.dart';
import 'newUser_register.dart';
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
  ScrollController _scrollController = ScrollController();
  UserListController userListController = Get.put(UserListController());
  ProductController productController = Get.put(ProductController());
  NewRegisterCon newRegisterCon = Get.put(NewRegisterCon());

  int _pageIndex = 0;
  int _pageSize = 5;
  bool _loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadProducts();
    _scrollController.addListener(_onScroll);
    homeController.checkUser();
    newRegisterCon.clearController();
  }

  Future<void> _handleRefresh() async {
    _pageIndex = 1;
    _pageSize = 5;

    homeController.homeList.clear();
    homeController.getOrderCall(
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
      final RxList<Order> products = await homeController.getOrderCall(
        _pageIndex,
        _pageSize,
      );
      setState(() {
        homeController.homeList.addAll(products);
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
                  Get.to(() => const LoginScreen());
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
          actions: [
            TextButton(
                onPressed: () {
                  Get.to(() => const ReportSearchScreen());
                },
                child: const Text("Report",
                    style: TextStyle(
                        color: ConstColour.primaryColor,
                        fontFamily: ConstFont.poppinsBold,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis)))
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

                            Get.to(() => UserList());
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
                      )
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
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: NextButton(
            onPressed: () {
              Get.to(() => const OrderScreen());
            },
            btnName: "Add Design",
          ),
        ),
        backgroundColor: ConstColour.bgColor,
        body: Obx(
          () => LiquidPullToRefresh(
            color: Colors.black,
            height: deviceHeight * 0.08,
            onRefresh: _handleRefresh,
            showChildOpacityTransition: false,
            backgroundColor: ConstColour.primaryColor,
            springAnimationDurationInMilliseconds: 1,
            child:
              homeController.homeList.isEmpty ?
                Container(
                  child: homeController.isLoaderShow.value == true ?
                  Loaders(
                            items: 6,
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
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: ConstColour.primaryColor),
                                        borderRadius: BorderRadius.circular(11),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                  :    const Center(
                        child: Text(
                        "No Data Found",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: ConstFont.poppinsRegular,
                        ),
                      )),
                )
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount:
                            homeController.homeList.length + (_loading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == homeController.homeList.length) {
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
                            child: InkWell(
                              onTap: () {
                                Get.to(const ProductDetailScreen());

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
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        child: CachedNetworkImage(
                                          width: double.infinity,
                                          imageUrl: homeController
                                              .homeList[index].image
                                              .toString(),
                                          fadeInCurve: Curves.easeInOutQuad,
                                          placeholder: (context, url) =>
                                              const Icon(Icons.image,
                                                  size: 65,
                                                  color:
                                                      ConstColour.loadImageColor),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error, size: 45),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: deviceHeight * 0.01,
                                          ),
                                          child: Text(
                                            homeController.homeList[index].name,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily:
                                                    ConstFont.poppinsRegular),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: deviceHeight * 0.015,
                                              bottom: deviceHeight * 0.01),
                                          child: Text(
                                            "Create Date : ${homeController.homeList[index].dateCreated}",
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14,
                                                fontFamily:
                                                    ConstFont.poppinsRegular),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: deviceWidth * 0.4),
                                          child: TextButton(
                                            onPressed: () {
                                              userListController.orderId =
                                                  homeController
                                                      .homeList[index].id;
                                              Get.to(
                                                  () => const UserListScreen());
                                              // userListController.getUserCall(userListController.orderId.toString());
                                            },
                                            child: const Text(
                                              "User",
                                              style: TextStyle(
                                                  color: ConstColour.primaryColor,
                                                  fontSize: 16,
                                                  fontFamily:
                                                      ConstFont.poppinsMedium),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        controller: _scrollController,
                      ),

          ),
        ),
      ),
    );
  }
}
