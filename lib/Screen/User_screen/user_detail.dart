import 'package:flutter/material.dart';

import '../../Common/bottom_button_widget.dart';
import '../../ConstFile/constColors.dart';
import '../../ConstFile/constFonts.dart';

class UserDetail extends StatefulWidget {
  const UserDetail({super.key});

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstColour.bgColor,
        centerTitle: true,
        title: Text(
            "Product Detail",
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
      bottomNavigationBar: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: NextButton(
                onPressed: () {},
                btnName: "Complete",
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    minimumSize: Size(deviceWidth * 0.9, deviceHeight * 0.06),
                    maximumSize: Size(deviceWidth * 1.0, deviceHeight * 0.07),
                  backgroundColor: Colors.black
                ),
                onPressed: () {},
                child: Text(
                    'Cancel',
                  style: const TextStyle(
                      fontFamily: ConstFont.poppinsRegular,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,color: Colors.white
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: ConstColour.bgColor,
      body: SingleChildScrollView(
        controller: ScrollController(),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Container(
                  height: deviceHeight * 0.4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Image.asset(
                          "asset/images/jeweller.png",),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: deviceHeight * 0.1,
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: ScrollController(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.white,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Image.asset(
                                    "asset/images/jeweller.png",
                                    width: deviceWidth * 0.18),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: deviceHeight * 0.01,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Design Name',
                      style: TextStyle(
                        color: ConstColour.btnHowerColor,
                        fontSize: 15,
                        fontFamily: ConstFont.poppinsRegular,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      ': Mangal Mala',
                      style: TextStyle(
                        color: ConstColour.textColor,
                        fontSize: 16,
                        fontFamily: ConstFont.poppinsRegular,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Party Name',
                      style: TextStyle(
                        color: ConstColour.btnHowerColor,
                        fontSize: 15,
                        fontFamily: ConstFont.poppinsRegular,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      ': Hitesh Gothadiya',
                      style: TextStyle(
                        color: ConstColour.textColor,
                        fontSize: 16,
                        fontFamily: ConstFont.poppinsRegular,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Carat',
                      style: TextStyle(
                        color: ConstColour.btnHowerColor,
                        fontSize: 15,
                        fontFamily: ConstFont.poppinsRegular,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      ': 22 Carat',
                      style: TextStyle(
                        color: ConstColour.textColor,
                        fontSize: 16,
                        fontFamily: ConstFont.poppinsRegular,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Weight',
                      style: TextStyle(
                        color: ConstColour.btnHowerColor,
                        fontSize: 15,
                        fontFamily: ConstFont.poppinsRegular,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      ': 70 Gm',
                      style: TextStyle(
                        color: ConstColour.textColor,
                        fontSize: 16,
                        fontFamily: ConstFont.poppinsRegular,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Create Date',
                      style: TextStyle(
                        color: ConstColour.btnHowerColor,
                        fontSize: 15,
                        fontFamily: ConstFont.poppinsRegular,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      ': 08/01/2024',
                      style: TextStyle(
                        color: ConstColour.textColor,
                        fontSize: 16,
                        fontFamily: ConstFont.poppinsRegular,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Delivery Date',
                      style: TextStyle(
                        color: ConstColour.btnHowerColor,
                        fontSize: 15,
                        fontFamily: ConstFont.poppinsRegular,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      ': 15/01/2024',
                      style: TextStyle(
                        color: ConstColour.textColor,
                        fontSize: 16,
                        fontFamily: ConstFont.poppinsRegular,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Description',
                      style: TextStyle(
                        color: ConstColour.btnHowerColor,
                        fontSize: 15,
                        fontFamily: ConstFont.poppinsRegular,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      ": Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's",
                      maxLines: 7,
                      style: TextStyle(
                        color: ConstColour.textColor,
                        fontSize: 16,
                        fontFamily: ConstFont.poppinsRegular,
                        overflow: TextOverflow.ellipsis,
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
