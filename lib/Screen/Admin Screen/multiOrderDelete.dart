import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/Common/snackbar.dart';
import 'package:jewellery_user/ConstFile/constColors.dart';
import 'package:jewellery_user/ConstFile/constFonts.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_user/Controller/home_Controller.dart';

void deleteOrderDialog(context) {
  HomeController homeController = Get.put(HomeController());

  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _endDate =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
  var startdate = DateTime(DateTime.now().year, DateTime.now().month, 1)
      .millisecondsSinceEpoch
      .obs;
  var enddate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0)
      .millisecondsSinceEpoch
      .obs;

  var fromDate;
  var toDate;

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
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Delete Orders",
                  style: TextStyle(
                      fontFamily: ConstFont.poppinsMedium, fontSize: 18)),
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
                      fromDate  = pickedDate.millisecondsSinceEpoch;

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
                                  startdate.value = pickedDate.millisecondsSinceEpoch;
                                  fromDate  = pickedDate.millisecondsSinceEpoch;

                                  setState(() {
                                    _startDate = pickedDate;
                                    _endDate = _startDate;
                                  });
                                }

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
                    if (_endDate ==
                        DateTime(
                            DateTime.now().year, DateTime.now().month + 1, 0)) {
                      Utils()
                          .toastMessage("Please select the 'From' date first");
                    }
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
                      enddate.value = pickedDate.add(const Duration(hours: 23, minutes: 59)).millisecondsSinceEpoch;
                      toDate = pickedDate.add(const Duration(hours: 23, minutes: 59)).millisecondsSinceEpoch;

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
                                if (_endDate ==
                                    DateTime(DateTime.now().year,
                                        DateTime.now().month + 1, 0)) {
                                  Utils().toastMessage(
                                      "Please select the 'From' date first");
                                }

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
                                  enddate.value = pickedDate.add(const Duration(hours: 23, minutes: 59)).millisecondsSinceEpoch;
                                  toDate = pickedDate.add(const Duration(hours: 23, minutes: 59)).millisecondsSinceEpoch;
                                  setState(() {
                                    _endDate = pickedDate;
                                  });
                                }
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
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ConstColour.primaryColor,
                  maximumSize: Size(deviceWidth * 0.4, deviceHeight * 0.055),
                  minimumSize: Size(deviceWidth * 0.3, deviceHeight * 0.05),
                  // backgroundColor: Colors.white
                ),
                onPressed: () {
                  if(fromDate == null){
                    Utils().toastMessage("Select the From Date");
                  }else if(toDate == null){
                    Utils().toastMessage("Select the Date To Date");
                  }else{
                    Get.back();
                    deleteMulti(
                        context,
                        DateFormat('yyyy-MM-dd')
                            .format(DateTime.fromMillisecondsSinceEpoch(
                            startdate.value))
                            .toString(),
                        DateFormat('yyyy-MM-dd')
                            .format(DateTime.fromMillisecondsSinceEpoch(
                            enddate.value))
                            .toString());
                  }


                },
                child: const Text(
                  "Delete",
                  style: TextStyle(
                      color: Colors.black,
                      overflow: TextOverflow.ellipsis,
                      fontFamily: ConstFont.poppinsMedium,
                      fontSize: 14),
                )),
            SizedBox(
              height: deviceHeight * 0.01,
            ),
          ],
        ),
      )),
    ),
  ).whenComplete(() {
    // if (reportSearchController.isFilterApplyed.value == false) {
    //   _handleRefresh();
    // }
  });
}

void deleteMulti(context, String fromDate, String toDate) {
  HomeController homeController = Get.put(HomeController());

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        shadowColor: Colors.white,
        elevation: 8.0,
        // backgroundColor: Colors.white,
        backgroundColor: Colors.orange.shade100,
        title: const Text(
          'Delete Orders',
          style: TextStyle(
            fontSize: 22,
            fontFamily: ConstFont.poppinsMedium,
            color: Colors.black,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        content: const Text(
          'Are you sure, want to delete Multiple Orders?',
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
            onTap: () {},
            splashColor: ConstColour.btnHowerColor,
            child: TextButton(
              onPressed: () {
                homeController.orderDeleteMultiCall(fromDate, toDate);
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
