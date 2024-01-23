import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ConstFile/constColors.dart';
import '../ConstFile/constFonts.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstColour.bgColor,
        centerTitle: true,
        title: const Text(
            "Report",
            style: TextStyle(
                color: Colors.white,
                fontFamily: ConstFont.poppinsRegular,
                fontSize: 22,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis)),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios),
            color: ConstColour.primaryColor),
      ),
      backgroundColor: ConstColour.bgColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: deviceHeight * 0.22,
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: ConstColour.primaryColor),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Column(
            children: [
              ListTile(
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
                title: const Text(
                  "# 2352",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: ConstFont.poppinsRegular),
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: const Text(
                  "Create Date: 02/01/2024",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      fontFamily: ConstFont.poppinsRegular),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "completed",
                    style: TextStyle(
                        color: ConstColour.greenColor,
                        fontFamily: ConstFont.poppinsRegular
                    ),
                  ),
                ),
              ),
              const Divider(
                color: ConstColour.primaryColor,
                thickness: 1,
                indent: 10,
                endIndent: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: deviceWidth * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Amaan Shaikh',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: ConstFont.poppinsRegular,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            "asset/icons/report_icon.png",
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: deviceWidth * 0.05,
                    ),
                    child: const Text(
                      'Assign Date: 05/01/2024',
                      style: TextStyle(
                          color: ConstColour.btnHowerColor,
                          fontSize: 14,
                          fontFamily: ConstFont.poppinsRegular),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: deviceHeight * 0.002,
                        left: deviceWidth * 0.05,
                    ),
                    child: const Text(
                      'Complet Date: 09/01/2024',
                      style: TextStyle(
                          color: ConstColour.btnHowerColor,
                          fontSize: 14,
                          fontFamily: ConstFont.poppinsRegular),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
