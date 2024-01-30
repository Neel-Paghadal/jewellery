import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/Common/bottom_button_widget.dart';
import 'package:jewellery_user/ConstFile/constColors.dart';
import 'package:jewellery_user/ConstFile/constFonts.dart';
import 'package:jewellery_user/Controller/User_Controller/adminList_controller.dart';
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

  int _pageIndex = 0;
  int _pageSize = 10;
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
                  overflow: TextOverflow.ellipsis))),
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
              ?     Container(
            child: adminListController.isLoaderShow.value == true
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
            itemCount: adminListController.adminList.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
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
                ),
              );
            },
          ),
        ),
      ),
    );;
  }
}
