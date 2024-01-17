import 'dart:core';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_user/Controller/product_controller.dart';
import 'package:photo_view/photo_view.dart';

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
  ProductController productController = Get.put(ProductController());
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
              icon: Image.asset("asset/icons/edit.png"),
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
                  height: deviceHeight * 0.4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                        errorBuilder:
                            (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          // Custom error widget to display when image fails to load
                          return const Icon(
                            Icons.image,
                            size: 150,
                            color: Colors.grey,
                          );
                        },
                        productController.productDetail[0].image),
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
                      itemCount: productController.productDetail[0].orderImages.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: Container(
                                    color: Colors.transparent,
                                    child: PhotoView(
                                      tightMode: true,
                                      backgroundDecoration:
                                      const BoxDecoration(
                                          color:
                                          Colors.transparent),
                                      imageProvider:
                                      NetworkImage(productController.productDetail[0].orderImages[index].path),
                                      heroAttributes:
                                      const PhotoViewHeroAttributes(
                                          tag: "someTag"),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Image.network(
                                    errorBuilder:
                                        (BuildContext context, Object exception,
                                        StackTrace? stackTrace) {
                                      // Custom error widget to display when image fails to load
                                      return const Icon(
                                        Icons.image,
                                        size: 60,
                                        color: Colors.grey,
                                      );
                                    },
                                    productController.productDetail[0].orderImages[index].path,
                                    width: deviceWidth * 0.16
                                ),
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
              padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.text,
                  controller: productController.designT,
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
                controller: productController.partyT,
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
                      controller: productController.caratT,

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
                      controller: productController.weightT,

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
                controller: productController.descripT,

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
