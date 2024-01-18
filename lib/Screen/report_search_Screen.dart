import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/Controller/report_search_Controller.dart';
import 'package:jewellery_user/Screen/report_Screen.dart';

import '../ConstFile/constColors.dart';
import '../ConstFile/constFonts.dart';

class ReportSearchScreen extends StatefulWidget {
  const ReportSearchScreen({super.key});

  @override
  State<ReportSearchScreen> createState() => _ReportSearchScreenState();
}

class _ReportSearchScreenState extends State<ReportSearchScreen> {

  ReportSearchController reportSearchController = Get.put(ReportSearchController());

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstColour.bgColor,
        centerTitle: true,
        title: Text(
            "Report",
            style: TextStyle(
                color: Colors.white,
                fontFamily: ConstFont.poppinsRegular,
                fontSize: 22,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis)),
        leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_back_ios),
            color: ConstColour.primaryColor),
      ),
      backgroundColor: ConstColour.bgColor,
      body: SingleChildScrollView(
        controller: ScrollController(),
        scrollDirection: Axis.vertical,
        child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  cursorColor: ConstColour.errorImage,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    height: deviceHeight * 0.001,
                    color: ConstColour.errorImage,
                    fontSize: 15,
                    fontFamily: ConstFont.poppinsRegular,
                    overflow: TextOverflow.ellipsis,
                  ),
                  decoration: InputDecoration(
                    fillColor: ConstColour.searchColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: BorderSide.none
                    ),
                    hintText: 'Search',
                    hintStyle: TextStyle(
                        color: ConstColour.errorImage,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        fontFamily: ConstFont.poppinsRegular),
                  ),
                ),
              ),
          ListView.builder(
            controller: ScrollController(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: reportSearchController.reportlist.length,
            itemBuilder: (context, index) {
              Color reportbuttonColor = ConstColour.offerImageColor;

              if(reportSearchController.reportlist[index].btnName == "Completed") {
                reportbuttonColor = ConstColour.greenColor;
              } else if(reportSearchController.reportlist[index].btnName == "Cancelled") {
                reportbuttonColor = ConstColour.quantityRemove;
              } else if(reportSearchController.reportlist[index].btnName == "Pending") {
                reportbuttonColor = Colors.yellow;
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
                    leading: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.asset(
                            "asset/images/jeweller.png",
                            width: deviceWidth * 0.12),
                      ),
                    ),
                    title: Text(
                      reportSearchController.reportlist[index].designCode,
                      style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: ConstFont.poppinsRegular),
                          overflow: TextOverflow.ellipsis,
                        ),
                    subtitle: Text(
                    reportSearchController.reportlist[index].date,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontFamily: ConstFont.poppinsRegular),
                    overflow: TextOverflow.ellipsis,
                  ),
                    trailing: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context, MaterialPageRoute(
                            builder: (context) => ReportScreen(),));
                        },
                        child: Text(
                          reportSearchController.reportlist[index].btnName,
                          style: TextStyle(
                              color: reportButtonColor,
                              fontFamily: ConstFont.poppinsRegular
                          ),
                        ),
                    ),
                  ),
                ),
              );
            },
          ),
        ]),
      ),
    );
  }
}
