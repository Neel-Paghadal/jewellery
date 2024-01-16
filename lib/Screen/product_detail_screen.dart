import 'dart:core';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Common/bottom_button_widget.dart';
import '../ConstFile/constColors.dart';
import '../ConstFile/constFonts.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  TextEditingController _createDateController = TextEditingController();
  TextEditingController _deliveryDateController = TextEditingController();

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
          actions: [
            IconButton(
              onPressed: () {},
              icon: Image.asset("asset/images/Group.png"),
            ),
          ],
        leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_back_ios),
            color: ConstColour.primaryColor),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: NextButton(
          onPressed: () {},
          btnName: "Save",
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(21),
                  ),
                  child: Image.asset("asset/images/jeweller.png"),
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
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(21),
                            ),
                            child: Image.asset("asset/images/jeweller.png",
                                width: deviceWidth * 0.2
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
              padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: ConstFont.poppinsRegular,
                    overflow: TextOverflow.ellipsis,
                  ),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(
                            color: ConstColour.primaryColor
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(
                            color: ConstColour.primaryColor
                        ),),
                    labelText: 'Design Name',
                    labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontFamily: ConstFont.poppinsRegular),
                  ),
                ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: ConstFont.poppinsRegular,
                  overflow: TextOverflow.ellipsis,
                ),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: BorderSide(
                        color: ConstColour.primaryColor
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: BorderSide(
                        color: ConstColour.primaryColor
                    ),),
                  labelText: 'Party Name',
                  labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontFamily: ConstFont.poppinsRegular),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: ConstFont.poppinsRegular,
                        overflow: TextOverflow.ellipsis,
                      ),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: BorderSide(
                              color: ConstColour.primaryColor
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: BorderSide(
                              color: ConstColour.primaryColor
                          ),),
                        labelText: 'Carat',
                        labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: ConstFont.poppinsRegular),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: ConstFont.poppinsRegular,
                        overflow: TextOverflow.ellipsis,
                      ),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: BorderSide(
                              color: ConstColour.primaryColor
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: BorderSide(
                              color: ConstColour.primaryColor
                          ),),
                        labelText: 'Weight',
                        labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: ConstFont.poppinsRegular),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _createDateController,
                readOnly: true,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: ConstFont.poppinsRegular,
                  overflow: TextOverflow.ellipsis,
                ),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: BorderSide(
                        color: ConstColour.primaryColor
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: BorderSide(
                        color: ConstColour.primaryColor
                    ),),
                  labelText: 'Create Date',
                  labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontFamily: ConstFont.poppinsRegular),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime(2100),
                    builder: (BuildContext context, picker) {
                      return Theme(
                          data: ThemeData.dark().copyWith(
                            colorScheme: ColorScheme.dark(
                              primary: Colors.white,
                              onPrimary: Colors.black,
                              surface: ConstColour.bgColor,
                              onSurface: Colors.white
                            ),
                            dialogBackgroundColor: ConstColour.primaryColor
                          ),
                          child: picker!
                      );
                    },
                  );
                  if (pickedDate != null && pickedDate != DateTime.now()) {
                    String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                    _createDateController.text = formattedDate;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _deliveryDateController,
                readOnly: true,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: ConstFont.poppinsRegular,
                  overflow: TextOverflow.ellipsis,
                ),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: BorderSide(
                        color: ConstColour.primaryColor
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: BorderSide(
                        color: ConstColour.primaryColor
                    ),),
                  labelText: 'Delivery Date',
                  labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontFamily: ConstFont.poppinsRegular),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    lastDate: DateTime(2100),
                    builder: (BuildContext context, picker) {
                      return Theme(
                          data: ThemeData.dark().copyWith(
                              colorScheme: ColorScheme.dark(
                                  primary: Colors.white,
                                  onPrimary: Colors.black,
                                  surface: ConstColour.bgColor,
                                  onSurface: Colors.white
                              ),
                              dialogBackgroundColor: ConstColour.primaryColor
                          ),
                          child: picker!
                      );
                    },
                  );

                  if (pickedDate != null && pickedDate != DateTime.now()) {
                    String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                    _deliveryDateController.text = formattedDate;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                maxLines: 3,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: ConstFont.poppinsRegular,
                  overflow: TextOverflow.ellipsis,
                ),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: BorderSide(
                        color: ConstColour.primaryColor
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: BorderSide(
                        color: ConstColour.primaryColor
                    ),),
                  labelText: 'Description',
                  labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontFamily: ConstFont.poppinsRegular),
                ),
              ),
            ),
            Divider(
              height: deviceHeight * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}
