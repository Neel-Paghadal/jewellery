import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/Common/bottom_button_widget.dart';
import 'package:jewellery_user/ConstFile/constColors.dart';
import 'package:jewellery_user/ConstFile/constFonts.dart';
import 'package:jewellery_user/Controller/home_Controller.dart';
import 'package:jewellery_user/Controller/user_list_controller.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../Models/dashboard_model.dart';
import 'order.dart';
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

  int _pageIndex = 0;
  int _pageSize = 5;
  bool _loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadProducts();
    _scrollController.addListener(_onScroll);
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
    return await Future.delayed(Duration(seconds: 1));
  }

  Future<void> _loadProducts() async {
    setState(() {
      _loading = true;
    });
    _pageIndex++;

    debugPrint("Page Order index" + _pageIndex.toString());
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
            TextButton(
                onPressed: () {},
                child: Text("Report",
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
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: NextButton(
            onPressed: () {
              Get.to(() => OrderScreen());
            },
            btnName: "Add Design",
          ),
        ),
        backgroundColor: ConstColour.bgColor,
        body: LiquidPullToRefresh(
          color: Colors.black,
          height: deviceHeight * 0.08,
          onRefresh: _handleRefresh,
          showChildOpacityTransition: false,
          backgroundColor: ConstColour.primaryColor,
          springAnimationDurationInMilliseconds: 1,
          child: Obx(
            () => ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: homeController.homeList.length + (_loading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == homeController.homeList.length) {
                  // Loading indicator
                  return _loading
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: const CircularProgressIndicator(
                                color: ConstColour.primaryColor),
                            widthFactor: deviceWidth * 0.1,
                          ),
                        )
                      : Container();
                }

                final product = homeController.homeList[index];

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
                            height: deviceHeight * 0.13,
                            width: deviceWidth * 0.28,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(21),
                            ),
                            child: Image.network(errorBuilder:
                                    (BuildContext context, Object exception,
                                        StackTrace? stackTrace) {
                              // Custom error widget to display when image fails to load
                              return Icon(
                                Icons.image,
                                size: 80,
                                color: Colors.grey,
                              );
                            }, homeController.homeList[index].image.toString(),
                                width: deviceWidth * 0.1),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: deviceHeight * 0.01,
                              ),
                              child: Text(
                                homeController.homeList[index].name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: ConstFont.poppinsRegular),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: deviceHeight * 0.015,
                                  bottom: deviceHeight * 0.01),
                              child: Text(
                                homeController.homeList[index].dateCreated,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontFamily: ConstFont.poppinsRegular),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: deviceWidth * 0.4),
                              child: TextButton(
                                onPressed: () {
                                  userListController.orderId = homeController.homeList[index].id;
                                  userListController.getUserCall();


                                },
                                child: Text(
                                  "User",
                                  style: TextStyle(
                                      color: ConstColour.primaryColor,
                                      fontSize: 16,
                                      fontFamily: ConstFont.poppinsMedium),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
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
