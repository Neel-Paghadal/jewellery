import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/Controller/home_Controller.dart';
import 'package:jewellery_user/Controller/reportScreen_controller.dart';
import 'package:jewellery_user/Controller/report_search_Controller.dart';
import 'package:jewellery_user/Models/ordersReport_model.dart';
import 'package:jewellery_user/Screen/loader.dart';
import 'package:jewellery_user/Screen/report_Screen.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../ConstFile/constColors.dart';
import '../ConstFile/constFonts.dart';

class ReportSearchScreen extends StatefulWidget {
  const ReportSearchScreen({super.key});

  @override
  State<ReportSearchScreen> createState() => _ReportSearchScreenState();
}

class _ReportSearchScreenState extends State<ReportSearchScreen> {
  ReportSearchController reportSearchController =
      Get.put(ReportSearchController());
  Color reportbuttonColor = ConstColour.offerImageColor;
  ScrollController _scrollController = ScrollController();
  HomeController homeController = Get.put(HomeController());

  ReportScreenController reportScreenController = Get.put(ReportScreenController());




  int _pageIndex = 0;
  int _pageSize = 10;
  bool _loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reportSearchController.orderReportList.clear();
    _loadProducts();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _handleRefresh() async {
    _pageIndex = 1;
    _pageSize = 10;

    reportSearchController.orderReportList.clear();
    reportSearchController.getReportCall(
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
      final RxList<OrderReport> products =
          await reportSearchController.getReportCall(
        _pageIndex,
        _pageSize,
      );
      setState(() {
        reportSearchController.orderReportList.addAll(products);
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
      appBar: AppBar(
        backgroundColor: ConstColour.bgColor,
        centerTitle: true,
        title: const Text("Report",
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
      backgroundColor: ConstColour.bgColor,
      body: LiquidPullToRefresh(
        color: Colors.black,
        height: deviceHeight * 0.08,
        onRefresh: _handleRefresh,
        showChildOpacityTransition: false,
        backgroundColor: ConstColour.primaryColor,
        springAnimationDurationInMilliseconds: 1,
        child: Obx(
          () => Container(
            child: reportSearchController.orderReportList.isEmpty
                ? Container(
                    child: reportSearchController.isLoaderShow.value == true
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
                                      leading: Icon(Icons.image,
                                          color: Colors.grey, size: 50),
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
                              "No User Found",
                              style: TextStyle(
                                  fontFamily: ConstFont.poppinsMedium,
                                  color: Colors.white,
                                  fontSize: 16),
                            ),
                          ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: reportSearchController.orderReportList.length +
                        (_loading ? 1 : 0),
                    itemBuilder: (context, index) {
                      // if (reportSearchController
                      //         .orderReportList[index].status ==
                      //     "Completed") {
                      //   reportbuttonColor = ConstColour.greenColor;
                      // } else if (reportSearchController
                      //         .orderReportList[index].status ==
                      //     "Cancelled") {
                      //   reportbuttonColor = ConstColour.quantityRemove;
                      // } else if (reportSearchController
                      //         .orderReportList[index].status ==
                      //     "Pending") {
                      //   reportbuttonColor = Colors.yellow;
                      // }

                      if (index ==
                          reportSearchController.orderReportList.length) {
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
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: ConstColour.primaryColor),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: ListTile(
                            onTap: () {
                              reportScreenController.reportDetail.clear();
                              reportScreenController.getReportDetailCall(reportSearchController.orderReportList[index].id);
                              Get.to(() => ReportScreen());
                            },
                            leading: Container(
                                height: double.infinity,
                                width: deviceWidth * 0.115,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: CachedNetworkImage(
                                    imageUrl: reportSearchController
                                        .orderReportList[index].image,
                                    fadeInCurve: Curves.easeInOutQuad, fit: BoxFit.cover,

                                    placeholder: (context, url) => const Icon(
                                        Icons.image,
                                        size: 30,
                                        color: ConstColour.loadImageColor),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error, size: 30),
                                  ),
                                )),
                            title: Text(
                              "# ${reportSearchController.orderReportList[index].orderId}",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: ConstFont.poppinsRegular),
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              reportSearchController
                                  .orderReportList[index].dateCreated,
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                  fontFamily: ConstFont.poppinsRegular),
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Text(
                              reportSearchController
                                  .orderReportList[index].status,
                              style: TextStyle(
                                  color: (reportSearchController
                                              .orderReportList[index].status ==
                                          "Completed")
                                      ? ConstColour.greenColor
                                      : (reportSearchController
                                                  .orderReportList[index]
                                                  .status ==
                                              "Cancelled")
                                          ? ConstColour.quantityRemove
                                          : (reportSearchController
                                                      .orderReportList[index]
                                                      .status ==
                                                  "Pending")
                                              ? Colors.yellow
                                              : null,
                                  fontFamily: ConstFont.poppinsBold),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
