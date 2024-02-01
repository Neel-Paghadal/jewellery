import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:jewellery_user/Controller/User_Controller/productdetail_controller.dart';
import 'package:jewellery_user/Controller/User_Controller/user_home_con.dart';
import 'package:jewellery_user/Controller/home_Controller.dart';
import 'package:photo_view/photo_view.dart';

import '../../Common/bottom_button_widget.dart';
import '../../ConstFile/constColors.dart';
import '../../ConstFile/constFonts.dart';
import '../loader.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  UserProductController userProductController = Get.put(UserProductController());
  HomeController homeController = Get.put(HomeController());
  UserHomeCon userHomeCon = Get.put(UserHomeCon());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstColour.bgColor,
        centerTitle: true,
        title: Text(
            'productDetail'.tr,
            style: const TextStyle(
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
      bottomNavigationBar: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: NextButton(
                onPressed: () {
                  homeController.loading.value = true;
                  userProductController.assignComplete(
                      userProductController.orderUserId,
                      userProductController.reasonController.text
                  );

                },
                btnName: "complete".tr,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    minimumSize: Size(deviceWidth * 0.9, deviceHeight * 0.06),
                    maximumSize: Size(deviceWidth * 1.0, deviceHeight * 0.07),
                  backgroundColor: Colors.black
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          setState(() {

                          },);
                          return Dialog(
                            insetAnimationDuration: const Duration(seconds: 1),
                            insetAnimationCurve: Curves.linear,
                            shadowColor: ConstColour.primaryColor,
                            backgroundColor: Colors.black45,
                            child: Container(
                              decoration: BoxDecoration(
                                color: ConstColour.bgColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: ConstColour.primaryColor,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom: deviceHeight * 0.01,left: deviceWidth * 0.25,top: deviceHeight * 0.01),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            userHomeCon.codeController.text,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontFamily: ConstFont.poppinsBold,
                                                color: Colors.white),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                         IconButton(onPressed : () {
                                           Get.back();
                                         }, icon: Icon(Icons.cancel_outlined,color: ConstColour.primaryColor,size: 24,))
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: deviceHeight * 0.02,
                                          left: deviceWidth * 0.03,
                                          right: deviceWidth * 0.03),
                                      child: TextFormField(
                                        autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                        textAlign: TextAlign.start,
                                        keyboardType: TextInputType.text,
                                        autocorrect: true,
                                        controller:  userProductController.reasonController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please Enter Reason";
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                          labelStyle:
                                          const TextStyle(color: Colors.grey),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                                color: ConstColour.textFieldBorder),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                                color: ConstColour.textFieldBorder),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                                color: ConstColour.primaryColor),
                                          ),
                                          focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: ConstColour.primaryColor),
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(8)),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                                color: ConstColour.textFieldBorder),
                                          ),
                                          border: InputBorder.none,
                                          filled: true,
                                          labelText: "Reason",
                                          hintText: "Enter your reason",
                                          floatingLabelStyle:
                                          const TextStyle(color: Colors.white),
                                          hintStyle: const TextStyle(
                                              color: Colors.grey,
                                              fontFamily: ConstFont.poppinsRegular,
                                              fontSize: 16,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                        minLines: 3,
                                        maxLines: 4,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontFamily: ConstFont.poppinsRegular),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: NextButton(
                                        btnName: "orderCancel".tr,
                                        onPressed: () {
                                          if(_formKey.currentState!.validate()){

                                              homeController.loading.value = true;
                                              userProductController.assignCancel(
                                                  userProductController.orderUserId,
                                                userProductController.reasonController.text
                                              );

                                          }

                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );

                },
                child: Text(
                    'cancel'.tr,
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
        child: Obx(
          () =>  userProductController.productDetail.isEmpty
              ?
          Loaders(
            items: 1,
            direction: LoaderDirection.ltr,
            baseColor: Colors.grey,
            highLightColor: Colors.white,
            builder: Padding(
              padding: EdgeInsets.only(right: deviceWidth * 0.01),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.image, size: 300, color: Colors.grey),
                  Container(
                    height: deviceHeight * 0.1,
                    child: Row(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: 6,
                            controller: ScrollController(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.image,
                                  color: Colors.grey,
                                  size: 80,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: BorderSide(color: Colors.grey,width: deviceWidth * 0.005)
                      ),
                      title: Container(width: deviceWidth *0.1,height: deviceHeight * 0.005,color: Colors.grey),

                    ),
                  ),     Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: BorderSide(color: Colors.grey,width: deviceWidth * 0.005)
                      ),
                      title: Container(width: deviceWidth *0.1,height: deviceHeight * 0.005,color: Colors.grey),

                    ),
                  ),     Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: BorderSide(color: Colors.grey,width: deviceWidth * 0.005)
                      ),
                      title: Container(width: deviceWidth *0.1,height: deviceHeight * 0.005,color: Colors.grey),

                    ),
                  ),     Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: BorderSide(color: Colors.grey,width: deviceWidth * 0.005)
                      ),
                      title: Container(width: deviceWidth *0.1,height: deviceHeight * 0.005,color: Colors.grey),

                    ),
                  ),     Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: BorderSide(color: Colors.grey,width: deviceWidth * 0.005)
                      ),
                      title: Container(width: deviceWidth *0.1,height: deviceHeight * 0.005,color: Colors.grey),

                    ),
                  ),
                ],
              ),
            ),
          )
              :
          Column(
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
                      child:
                      // Image.network(
                      //     errorBuilder:
                      //         (BuildContext context, Object exception,
                      //         StackTrace? stackTrace) {
                      //       Custom error widget to display when image fails to load
                            // return  Icon(
                            //   Icons.image,
                            //   size: 150,
                            //   color: Colors.grey,
                            // );
                          // },
                          // userProductController.productDetail[0].image),
                      CachedNetworkImage(
                        width: double.infinity,
                        imageUrl: userProductController.productDetail[0].image.toString(),
                        fadeInCurve: Curves.easeInOutQuad,
                        placeholder: (context, url) => Icon(Icons.image,size: 100,color : ConstColour.loadImageColor),
                        errorWidget: (context, url, error) => Icon(Icons.error,size: 100),
                      )
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.1,
                child: Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: ScrollController(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: userProductController.productDetail[0].orderImages.length,
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
                                         BoxDecoration(
                                            color:
                                            Colors.transparent),
                                        imageProvider:
                                        NetworkImage(userProductController.productDetail[0].orderImages[index].path),
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
                                  child:
                                  // Image.network(
                                  //     errorBuilder:
                                  //         (BuildContext context, Object exception,
                                  //         StackTrace? stackTrace) {
                                        // Custom error widget to display when image fails to load
                                        // return const Icon(
                                        //   Icons.image,
                                        //   size: 60,
                                        //   color: Colors.grey,
                                        // );
                                      // },
                                      // userProductController.productDetail[0].orderImages[index].path,
                                      // width: deviceWidth * 0.16
                                  CachedNetworkImage(
                                    width: deviceWidth * 0.16,
                                    imageUrl: userProductController.productDetail[0].orderImages[index].path,
                                    fadeInCurve: Curves.easeInOutQuad,
                                    placeholder: (context, url) => Icon(Icons.image,size: 65,color : ConstColour.loadImageColor),
                                    errorWidget: (context, url, error) => Icon(Icons.error,size: 45),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'designName'.tr,
                        style: const TextStyle(
                          color: ConstColour.btnHowerColor,
                          fontSize: 15,
                          fontFamily: ConstFont.poppinsRegular,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                     Expanded(
                      child: Text(
                        ': ${userProductController.design}',
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
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'carat'.tr,
                        style: const TextStyle(
                          color: ConstColour.btnHowerColor,
                          fontSize: 15,
                          fontFamily: ConstFont.poppinsRegular,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                     Expanded(
                      child: Text(
                        ': ${userProductController.carat} Carat',
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
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'weight'.tr,
                        style: const TextStyle(
                          color: ConstColour.btnHowerColor,
                          fontSize: 15,
                          fontFamily: ConstFont.poppinsRegular,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        ': ${userProductController.weight} Gm',
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
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'createdate'.tr,
                        style: const TextStyle(
                          color: ConstColour.btnHowerColor,
                          fontSize: 15,
                          fontFamily: ConstFont.poppinsRegular,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                     Expanded(
                      child: Text(
                        ': ${userProductController.createDate}',
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
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'deliveryDate'.tr,
                        style: const TextStyle(
                          color: ConstColour.btnHowerColor,
                          fontSize: 15,
                          fontFamily: ConstFont.poppinsRegular,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        ': ${userProductController.deliveryDate}',
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
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'description'.tr,
                        style: const TextStyle(
                          color: ConstColour.btnHowerColor,
                          fontSize: 15,
                          fontFamily: ConstFont.poppinsRegular,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        ": ${userProductController.description}",
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
      ),
    );
  }
}
