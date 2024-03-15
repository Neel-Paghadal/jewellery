import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/Controller/order_controller.dart';

import '../../ConstFile/constColors.dart';
import '../../ConstFile/constFonts.dart';


Future mainImageCancelDialog(context,) {

  OrderController orderController = Get.put(OrderController());

  return showCupertinoModalPopup(
    filter: const ColorFilter.mode(ConstColour.primaryColor, BlendMode.clear),
    semanticsDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        shadowColor: Colors.white,
        elevation: 8.0,
        // backgroundColor: Colors.white,
        backgroundColor: Colors.orange.shade100,
        // title: const Text(
        //   'Order',
        //   style: TextStyle(
        //     fontSize: 22,
        //     fontFamily: ConstFont
        //         .poppinsMedium,
        //     color: Colors.black,
        //   ),
        //   overflow: TextOverflow
        //       .ellipsis,
        // ),
        content: const Text(
          'Are you sure, want to delete?',
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
            onTap: () {
              orderController.imageNotes = null;
              // orderController.imageNotesLocal = null;
              orderController.imgList.clear();
              Get.back();
            },
            splashColor: ConstColour.btnHowerColor,
            child: Container(
              decoration: BoxDecoration(
                  // gradient: const LinearGradient(colors: [Colors.white,Colors.black26]),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black),
              child: const Padding(
                padding: EdgeInsets.all(6.0),
                child: Text(
                  '    Ok    ',
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
        ],
      );
    },
  );
}
