import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/Common/snackbar.dart';
import 'package:jewellery_user/Controller/home_Controller.dart';
import 'package:jewellery_user/Controller/reportScreen_controller.dart';
import 'package:jewellery_user/Controller/report_search_Controller.dart';
import 'package:jewellery_user/Models/ordersReport_model.dart';
import 'package:jewellery_user/Screen/loader.dart';
import 'package:jewellery_user/Screen/Admin%20Screen/report_Screen.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../../ConstFile/constColors.dart';
import '../../ConstFile/constFonts.dart';
import 'package:intl/intl.dart';

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
  ReportScreenController reportScreenController =
      Get.put(ReportScreenController());
  // DateTime _startDate = DateTime.now();
  // DateTime _endDate = DateTime.now();

  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _endDate =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  // var startdate = DateTime.now().add(Duration(hours: -TimeOfDay.now().hour, minutes: -TimeOfDay.now().minute)).millisecondsSinceEpoch.obs;
  // var enddate = DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch.obs;

  var startdate = DateTime(DateTime.now().year, DateTime.now().month, 1)
      .millisecondsSinceEpoch
      .obs;
  var enddate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0)
      .millisecondsSinceEpoch
      .obs;

  var dropdownvalue;

  DateTime? fromDate;
  DateTime? toDate;

  int status = 0;

  void _showDialog(context) {
    dropdownvalue = null;
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;

    showDialog(
      useSafeArea: true,
      barrierDismissible: true,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
            child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("   Select Filter",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontFamily: ConstFont.poppinsMedium)),
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.black,
                        size: 24,
                      ))
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: deviceHeight * 0.02,
                    left: deviceWidth * 0.03,
                    right: deviceWidth * 0.03),
                child: reportSearchController.isDropLoader.value == true
                    ? const CircularProgressIndicator(
                        color: ConstColour.primaryColor,
                      )
                    : Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(color: ConstColour.primaryColor)),
                        child: DropdownButton(
                          isExpanded: true,
                          borderRadius: BorderRadius.circular(8),
                          iconEnabledColor: ConstColour.primaryColor,
                          dropdownColor: Colors.white,
                          autofocus: true,
                          elevation: 5,
                          alignment: Alignment.centerLeft,
                          iconSize: 30,
                          focusColor: Colors.white,
                          underline: const DropdownButtonHideUnderline(
                              child: SizedBox()),
                          hint: Padding(
                            padding: EdgeInsets.only(left: deviceWidth * 0.05),
                            child: Text(
                              (reportSearchController.partyName == null &&
                                      reportSearchController.partyName.isNull)
                                  ? 'Select Party'
                                  : reportSearchController.partyName.toString(),
                              style: TextStyle(
                                  fontFamily: ConstFont.poppinsRegular,
                                  fontSize: 14,
                                  color: Colors.black),
                            ),
                          ),
                          value: dropdownvalue,
                          items:
                              reportSearchController.userListDrop.map((item) {
                            return DropdownMenuItem(
                                value: item.toString(),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    item.toString(),
                                    style: const TextStyle(
                                        fontFamily: ConstFont.poppinsRegular,
                                        fontSize: 14,
                                        color: ConstColour.primaryColor),
                                  ),
                                ));
                          }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              dropdownvalue = newVal;
                              reportSearchController.partyName =
                                  newVal.toString();
                              debugPrint(dropdownvalue.toString());
                            });
                          },
                        ),
                      ),
              ),
              Divider(height: deviceHeight * 0.01, color: Colors.grey.shade200),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: deviceWidth * 0.05, right: deviceWidth * 0.12),
                    child: const Text(
                      "From Date :     ",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: ConstFont.poppinsMedium,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  const Text(
                    "To Date :     ",
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: ConstFont.poppinsMedium,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    splashColor: ConstColour.btnHowerColor,
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: Get.context!,
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                        initialDate: _startDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: ConstColour.primaryColor,
                                // header background color
                                onPrimary: Colors.black,
                                // header text color
                                onSurface: Colors.black, // body text color
                              ),
                              // textButtonTheme: TextButtonThemeData(
                              //   style: TextButton.styleFrom(
                              //     foregroundColor: Colors.red, // button text color
                              //   ),
                              // ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedDate != null) {
                        startdate.value = pickedDate.millisecondsSinceEpoch;
                        setState(() {
                          _startDate = pickedDate;
                          _endDate = _startDate;
                        });
                      }
                    },
                    child: Card(
                      color: ConstColour.cardBgColor,
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: deviceWidth * 0.02,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () async {
                                  final DateTime? pickedDate =
                                      await showDatePicker(
                                    context: Get.context!,
                                    initialEntryMode:
                                        DatePickerEntryMode.calendarOnly,
                                    initialDate: _startDate,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime.now(),
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary: ConstColour.primaryColor,
                                            // header background color
                                            onPrimary: Colors.black,
                                            // header text color
                                            onSurface:
                                                Colors.black, // body text color
                                          ),
                                          // textButtonTheme: TextButtonThemeData(
                                          //   style: TextButton.styleFrom(
                                          //     foregroundColor: Colors.red, // button text color
                                          //   ),
                                          // ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (pickedDate != null) {
                                    startdate.value =
                                        pickedDate.millisecondsSinceEpoch;
                                    setState(() {
                                      _startDate = pickedDate;
                                      _endDate = _startDate;
                                    });
                                  }

                                  // final DateTime? pickedDate = await showDatePicker(
                                  //   context: Get.context!,
                                  //   initialEntryMode: DatePickerEntryMode.calendarOnly, // <- this
                                  //
                                  //   initialDate: startDate,
                                  //   firstDate: DateTime(2000),
                                  //   lastDate: DateTime.now(),
                                  //   // initialDate:DateTime.now() ,
                                  //   // firstDate: _startDate,
                                  //   // lastDate: DateTime.now(),
                                  //   builder: (context, child) {
                                  //     return Theme(
                                  //       data: Theme.of(context)
                                  //           .copyWith(
                                  //         colorScheme: const ColorScheme
                                  //             .light(
                                  //           primary: ConstColour
                                  //               .primaryColor,
                                  //           // header background color
                                  //           onPrimary: Colors.black,
                                  //           // header text color
                                  //           onSurface: Colors
                                  //               .black, // body text color
                                  //         ),
                                  //         // textButtonTheme: TextButtonThemeData(
                                  //         //   style: TextButton.styleFrom(
                                  //         //     foregroundColor: Colors.red, // button text color
                                  //         //   ),
                                  //         // ),
                                  //       ),
                                  //       child: child!,
                                  //     );
                                  //   },
                                  // );
                                  // if (pickedDate != null) {
                                  //   startdate.value = pickedDate
                                  //       .millisecondsSinceEpoch;
                                  //   setState(() {
                                  //     _startDate = pickedDate;
                                  //     endDate = startDate;
                                  //   });
                                  // }
                                  // debugPrint(
                                  //     DateFormat('yyyy-MM-dd').format(_startDate));
                                  // debugPrint("millisecond$startDate");
                                },
                                icon: const Icon(Icons.calendar_month_rounded)),
                            Text(DateFormat('dd-MM-yyyy').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    startdate.value))),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: ConstColour.btnHowerColor,
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: Get.context!,
                        initialDate: _endDate,
                        firstDate: _startDate,
                        lastDate: DateTime.now(),
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: ConstColour.primaryColor,
                                // header background color
                                onPrimary: Colors.black,
                                // header text color
                                onSurface: Colors.black, // body text color
                              ),
                              // textButtonTheme: TextButtonThemeData(
                              //   style: TextButton.styleFrom(
                              //     foregroundColor: Colors.red, // button text color
                              //   ),
                              // ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedDate != null) {
                        enddate.value = pickedDate
                            .add(Duration(hours: 23, minutes: 59))
                            .millisecondsSinceEpoch;
                        setState(() {
                          _endDate = pickedDate;
                        });
                      }
                    },
                    child: Card(
                      color: ConstColour.cardBgColor,
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: deviceWidth * 0.02,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () async {
                                  final DateTime? pickedDate =
                                      await showDatePicker(
                                    context: Get.context!,
                                    initialDate: _endDate,
                                    firstDate: _startDate,
                                    lastDate: DateTime.now(),
                                    initialEntryMode:
                                        DatePickerEntryMode.calendarOnly,
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary: ConstColour.primaryColor,
                                            // header background color
                                            onPrimary: Colors.black,
                                            // header text color
                                            onSurface:
                                                Colors.black, // body text color
                                          ),
                                          // textButtonTheme: TextButtonThemeData(
                                          //   style: TextButton.styleFrom(
                                          //     foregroundColor: Colors.red, // button text color
                                          //   ),
                                          // ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (pickedDate != null) {
                                    enddate.value = pickedDate
                                        .add(Duration(hours: 23, minutes: 59))
                                        .millisecondsSinceEpoch;
                                    setState(() {
                                      _endDate = pickedDate;
                                    });
                                  }

                                  // final DateTime? pickedDate = await showDatePicker(
                                  //   context: Get.context!,
                                  //   initialEntryMode: DatePickerEntryMode.calendarOnly, // <- this
                                  //   initialDate: endDate,
                                  //   firstDate: startDate,
                                  //   lastDate: DateTime.now(),
                                  //   // initialDate: DateTime.now(),
                                  //   // firstDate: _startDate,
                                  //   // lastDate: _endDate,
                                  //   builder: (context, child) {
                                  //     return Theme(
                                  //       data: Theme.of(context)
                                  //           .copyWith(
                                  //         colorScheme: const ColorScheme
                                  //             .light(
                                  //           primary: ConstColour
                                  //               .primaryColor,
                                  //           // header background color
                                  //           onPrimary: Colors.black,
                                  //           // header text color
                                  //           onSurface: Colors
                                  //               .black, // body text color
                                  //         ),
                                  //         // textButtonTheme: TextButtonThemeData(
                                  //         //   style: TextButton.styleFrom(
                                  //         //     foregroundColor: Colors.red, // button text color
                                  //         //   ),
                                  //         // ),
                                  //       ),
                                  //       child: child!,
                                  //     );
                                  //   },
                                  // );
                                  // if (pickedDate != null) {
                                  //   enddate.value = pickedDate.add(const Duration(hours: 23, minutes: 59)).millisecondsSinceEpoch;
                                  //   setState(() {
                                  //     _endDate = pickedDate;
                                  //   });
                                  // }
                                  // debugPrint(
                                  //     DateFormat('yyyy-MM-dd').format(
                                  //         _endDate));
                                  // debugPrint("millisecond$enddate");
                                  // getDateFromUser();
                                },
                                icon: const Icon(Icons.calendar_month_rounded)),
                            Text(DateFormat('dd-MM-yyyy').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    enddate.value)))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: deviceHeight * 0.01,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                child: Column(
                  children: [
                    RadioListTile(
                      dense: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                          side: const BorderSide(color: Colors.black)),
                      activeColor: ConstColour.primaryColor,
                      title: const Text("In Process",
                          style: TextStyle(
                              color: Colors.black,
                              overflow: TextOverflow.ellipsis,
                              fontFamily: ConstFont.poppinsRegular,
                              fontSize: 14),
                          maxLines: 2,
                          textAlign: TextAlign.center),
                      value: 1,
                      groupValue: status,
                      onChanged: (value) {
                        setState(() {
                          status = value!.toInt();
                        });
                      },
                    ),
                    SizedBox(
                      height: deviceHeight * 0.01,
                    ),
                    RadioListTile(
                      dense: true,
                      activeColor: ConstColour.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                          side: const BorderSide(color: Colors.black)),
                      title: const Text(
                        "Working",
                        style: TextStyle(
                            color: Colors.black,
                            overflow: TextOverflow.ellipsis,
                            fontFamily: ConstFont.poppinsRegular,
                            fontSize: 14),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                      value: 2,
                      groupValue: status,
                      onChanged: (value) {
                        setState(() {
                          status = value!.toInt();
                        });
                      },
                    ),
                    SizedBox(
                      height: deviceHeight * 0.01,
                    ),
                    RadioListTile(
                      dense: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                          side: const BorderSide(color: Colors.black)),
                      activeColor: ConstColour.primaryColor,
                      title: const Text(
                        "Complete",
                        style: TextStyle(
                            color: Colors.black,
                            overflow: TextOverflow.ellipsis,
                            fontFamily: ConstFont.poppinsRegular,
                            fontSize: 14),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                      value: 3,
                      groupValue: status,
                      onChanged: (value) {
                        setState(() {
                          status = value!.toInt();
                        });
                      },
                    ),
                    SizedBox(
                      height: deviceHeight * 0.01,
                    ),
                    RadioListTile(
                      dense: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                          side: const BorderSide(color: Colors.black)),
                      activeColor: ConstColour.primaryColor,
                      title: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.black,
                          overflow: TextOverflow.ellipsis,
                          fontFamily: ConstFont.poppinsRegular,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                      value: 4,
                      groupValue: status,
                      onChanged: (value) {
                        setState(() {
                          status = value!.toInt();
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ConstColour.primaryColor,
                        maximumSize:
                            Size(deviceWidth * 0.4, deviceHeight * 0.055),
                        minimumSize:
                            Size(deviceWidth * 0.3, deviceHeight * 0.05),
                        // backgroundColor: Colors.white
                      ),
                      onPressed: () {
                        if (reportSearchController.partyName == null &&
                            reportSearchController.partyName.isNull) {
                          Utils().toastMessage("Select Party");
                        } else {
                          reportSearchController.orderReportList.clear();
                          reportSearchController.isFilterApplyed.value = true;
                          setState(() {});
                          reportSearchController.getFilterReportCall(
                            reportSearchController.partyName.toString(),
                            DateFormat('yyyy-MM-dd')
                                .format(DateTime.fromMillisecondsSinceEpoch(
                                    startdate.value))
                                .toString(),
                            DateFormat('yyyy-MM-dd')
                                .format(DateTime.fromMillisecondsSinceEpoch(
                                    enddate.value))
                                .toString(),
                            1,
                            20,
                          );
                          Get.back();
                        }
                      },
                      child: const Text(
                        "Apply",
                        style: TextStyle(
                            color: Colors.black,
                            overflow: TextOverflow.ellipsis,
                            fontFamily: ConstFont.poppinsMedium,
                            fontSize: 14),
                      )),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ConstColour.primaryColor,
                        maximumSize:
                            Size(deviceWidth * 0.4, deviceHeight * 0.055),
                        minimumSize:
                            Size(deviceWidth * 0.3, deviceHeight * 0.05),
                        // backgroundColor: Colors.white
                      ),
                      onPressed: () {
                        startdate = DateTime(
                                DateTime.now().year, DateTime.now().month, 1)
                            .millisecondsSinceEpoch
                            .obs;
                        enddate = DateTime(DateTime.now().year,
                                DateTime.now().month + 1, 0)
                            .millisecondsSinceEpoch
                            .obs;
                        reportSearchController.isFilterApplyed.value = false;
                        reportSearchController.partyName = null;
                        _startDate = DateTime.now();
                        _endDate = DateTime.now();
                        setState(() {});
                        Get.back();
                      },
                      child: const Text(
                        "Clear All",
                        style: TextStyle(
                            color: Colors.black,
                            overflow: TextOverflow.ellipsis,
                            fontFamily: ConstFont.poppinsMedium,
                            fontSize: 14),
                      ))
                ],
              ),
              SizedBox(
                height: deviceHeight * 0.01,
              ),
            ],
          ),
        )),
      ),
    ).whenComplete(() {
      if (reportSearchController.isFilterApplyed.value == false) {
        _handleRefresh();
      }
      setState(() {});
    });
  }

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
      "",
      null,
      null,
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
        "",
        null,
        null,
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
        actions: [
          Obx(() => IconButton(
                onPressed: () {
                  reportSearchController.userListDrop.clear();
                  reportSearchController.getPartyCall();
                  _showDialog(context);
                },
                icon: Icon(
                    reportSearchController.isFilterApplyed.value == true
                        ? Icons.filter_alt_off_rounded
                        : Icons.filter_alt_rounded,
                    color: ConstColour.primaryColor,
                    size: 25),
              )),
        ],
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
                                      leading: const Icon(Icons.image,
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
                              reportScreenController.getReportDetailCall(
                                  reportSearchController
                                      .orderReportList[index].id);
                              Get.to(() => const ReportScreen());
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
                                    fadeInCurve: Curves.easeInOutQuad,
                                    fit: BoxFit.cover,
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
