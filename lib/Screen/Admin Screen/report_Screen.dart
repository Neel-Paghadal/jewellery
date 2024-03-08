import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/Controller/reportScreen_controller.dart';
import 'package:jewellery_user/Screen/loader.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../ConstFile/constColors.dart';
import '../../ConstFile/constFonts.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  ReportScreenController reportScreenController =
      Get.put(ReportScreenController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      body: Obx(
        () => LiquidPullToRefresh(
          color: Colors.black,
          height: deviceHeight * 0.08,
          onRefresh: reportScreenController.handleRefresh,
          showChildOpacityTransition: false,
          backgroundColor: ConstColour.primaryColor,
          springAnimationDurationInMilliseconds: 1,
          child: reportScreenController.reportDetail.isEmpty
              ? Container(
                  child: reportScreenController.isLoaderShow.value == true
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
                                  padding: const EdgeInsets.all(10.0),
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: const BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    // leading: Icon(Icons.image,
                                    //     color: Colors.grey, size: 50),
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
                                    subtitle: Padding(
                                      padding: EdgeInsets.only(
                                          top: deviceHeight * 0.02),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: deviceWidth * 0.4,
                                            height: deviceHeight * 0.01,
                                            color: Colors.grey,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: deviceHeight * 0.01),
                                            child: Container(
                                              width: deviceWidth * 0.4,
                                              height: deviceHeight * 0.01,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
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
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      controller: ScrollController(),
                      itemCount: reportScreenController.reportDetail.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(color: ConstColour.primaryColor),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: deviceWidth * 0.05,
                                  bottom: deviceHeight * 0.01),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    title: Text(
                                      reportScreenController
                                          .reportDetail[index].name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: ConstFont.poppinsRegular,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    minLeadingWidth: -40,
                                    visualDensity:
                                        const VisualDensity(horizontal: -4, vertical: -4),
                                    contentPadding:
                                        const EdgeInsets.only(left: 0.0, right: 10.0),
                                    horizontalTitleGap: 0.0,
                                    // subtitle: Text(
                                    //   "Completed",
                                    //   style: TextStyle(
                                    //       color: ConstColour.greenColor,
                                    //       fontSize: 16,
                                    //       fontFamily: ConstFont.poppinsBold),
                                    //   overflow: TextOverflow.ellipsis,
                                    // ),
                                    trailing: Text(reportScreenController.reportDetail[index].orderStatus,
                                      style: TextStyle(
                                          color: (reportScreenController.reportDetail[index].orderStatus ==
                                              "Complete")
                                              ? ConstColour.completeColor
                                              : (reportScreenController.reportDetail[index].orderStatus ==
                                              "Cancel")
                                              ? ConstColour.cancelColor
                                              : (reportScreenController.reportDetail[index].orderStatus ==
                                              "Pending")
                                              ? ConstColour.pendingColor
                                              : (reportScreenController.reportDetail[index].orderStatus ==
                                              "Working")
                                              ? ConstColour.workingColor
                                              : (reportScreenController.reportDetail[index].orderStatus ==
                                              "New")
                                              ? ConstColour.newColor
                                              : Colors.white,




                                          fontSize: 16,
                                          fontFamily: ConstFont.poppinsBold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    "Created Date : ${reportScreenController.reportDetail[index].orderCreatedDate}",
                                    style: TextStyle(color: Colors.blueGrey.shade200, fontSize: 14,
                                        fontFamily: ConstFont.poppinsRegular),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  reportScreenController.reportDetail[index].assignDate == ""
                                      ? const SizedBox()
                                      : Text(
                                          "Assign Date : ${reportScreenController
                                                  .reportDetail[index]
                                                  .assignDate}",
                                          style: TextStyle(
                                              color: Colors.blueGrey.shade200,
                                              fontSize: 14,
                                              fontFamily: ConstFont.poppinsRegular),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                  reportScreenController.reportDetail[index].completedDate == ""
                                      ? const SizedBox()
                                      : Text(
                                          "Completed Date : ${reportScreenController
                                                  .reportDetail[index]
                                                  .completedDate}",
                                          style: TextStyle(
                                              color: Colors.blueGrey.shade200,
                                              fontSize: 14,
                                              fontFamily: ConstFont.poppinsRegular),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                  reportScreenController.reportDetail[index].cancelledDate == ""
                                      ? const SizedBox()
                                      : Text(
                                          "Cancel Date : ${reportScreenController
                                                  .reportDetail[index]
                                                  .cancelledDate}",
                                          style: TextStyle(
                                              color: Colors.blueGrey.shade200,
                                              fontSize: 14,
                                              fontFamily: ConstFont.poppinsRegular),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                  reportScreenController.reportDetail[index].cancelReason == ""
                                      ? const SizedBox()
                                      : Text(
                                          "Reason : ${reportScreenController
                                                  .reportDetail[index].cancelReason}",
                                          style: TextStyle(
                                              color: Colors.blueGrey.shade200,
                                              fontSize: 14,
                                              fontFamily: ConstFont.poppinsRegular),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 10,
                                        ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
        ),
      ),
    );
  }
}
