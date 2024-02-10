import 'dart:core';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jewellery_user/Controller/product_controller.dart';
import 'package:jewellery_user/Screen/loader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import '../Common/bottom_button_widget.dart';
import '../ConstFile/constColors.dart';
import '../ConstFile/constFonts.dart';
import 'package:intl/intl.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ProductController productController = Get.put(ProductController());
  var _startDate;
  var startdate = DateTime.now()
      .add(Duration(
          hours: -TimeOfDay.now().hour, minutes: -TimeOfDay.now().minute))
      .millisecondsSinceEpoch
      .obs;

  // List<File> _imageList = [];
  File? imageNotes;
  final _formKey = GlobalKey<FormState>();


  Future<void> _checkPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future getImageCamera() async {
    _checkPermission();

    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;

    final imageTemporary = File(image.path);
    setState(() {
      imageNotes = imageTemporary;
      productController.isLoading.value = true;
      productController.uploadFile(imageNotes!);
      debugPrint(imageNotes.toString());
    });
  }

  Future getImageGallery() async {
    _checkPermission();
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final imageTemporary = File(image.path);
    setState(() {
      imageNotes = imageTemporary;
      productController.isLoading.value = true;
      productController.uploadFile(imageNotes!);

      debugPrint(imageNotes.toString());
    });
  }

  Future<void> _pickImages() async {
    List<XFile>? pickedImages = await ImagePicker().pickMultiImage(
      imageQuality: 50,
      maxWidth: 800,
    );

    setState(() {
      productController.imageList.addAll(pickedImages.map((image) => File(image.path)));
      productController.isLoadingSec.value = true;
      productController.uploadFileMulti(productController.imageList);
    });
  }

  void replaceString() {
    List<String> strings = [
      "http://208.64.33.118:8558/Files/Test\\1d369079-a66e-4fcd-a2fb-3e1dedfe79d1_scaled_1000090691.jpg",
      // Add other strings as needed
    ];

    // Common string to remove
    String commonStringToRemove = "http://208.64.33.118:8558/";

    // Remove common string from each element in the list
    List<String> modifiedStrings = strings.map((str) {
      return str.replaceAll(commonStringToRemove, '');
    }).toList();

    // Print the modified list of strings
    modifiedStrings.forEach(print);
  }

  void imageSelectionDialoge() {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                    side: const BorderSide(color: ConstColour.primaryColor)),
                tileColor: ConstColour.bgColor,
                title: const Text("Camera",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: ConstFont.poppinsMedium,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis),
                onTap: () {
                  Get.back();
                  getImageCamera();
                },
                leading: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: deviceHeight * 0.01),
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                    side: const BorderSide(color: ConstColour.primaryColor)),
                tileColor: ConstColour.bgColor,
                title: const Text("Gallery",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: ConstFont.poppinsMedium,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis),
                onTap: () {
                  Get.back();
                  getImageGallery();
                },
                leading: const Icon(
                  Icons.photo_library_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ConstColour.bgColor,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text("Product Detail",
            style: TextStyle(
                color: Colors.white,
                fontFamily: ConstFont.poppinsRegular,
                fontSize: 22,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis)),
        actions: [
          Obx(
            () =>  (productController.isLoading.value == true || productController.isLoadingSec.value == true) ? const SizedBox(): IconButton(
                onPressed: () {
                  // if (productController.isFilterApplyed.value == false) {
                  //   debugPrint("If calls");
                  //   productController.isFilterApplyed.value = true;
                  // } else {
                    if(_formKey.currentState!.validate()) {
                      String date;
                      if (_startDate == null) {
                        var dates;
                        dates = DateFormat('dd/MM/yyyy')
                            .parse(productController.deliveryDateController.text);
                        debugPrint(dates.toString());

                        date = DateFormat('yyyy-MM-dd').format(dates);
                      } else {
                        date = DateFormat('yyyy-MM-dd').format(_startDate);
                      }

                      debugPrint(date);

                      productController.updateProductCall(
                          productController.productDetail[0].id,
                          productController.designT.text,
                          productController.partyT.text,
                          double.parse(productController.caratT.text),
                          double.parse(productController.weightT.text),
                          date,
                          productController.descripT.text);

                      productController.isFilterApplyed.value = false;
                    }
                    debugPrint("Else calls");
                  // }
                  // setState(() {});
                },
                // icon: productController.isFilterApplyed.value == true
                //     ?
               icon : const Icon(Icons.done,color: ConstColour.primaryColor, size: 25)
                    // : Image.asset(
                    //     "asset/icons/edit.png",
                    //     width: deviceWidth * 0.06,
                    //   ),
              )  ,
          )
        ],
        leading: IconButton(
            tooltip: "Back",
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios),
            color: ConstColour.primaryColor),
      ),
      // bottomNavigationBar: productController.isFilterApplyed.value == true
      //     ? Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: NextButton(
      //           onPressed: () {
      //             if(_formKey.currentState!.validate()) {
      //               String date;
      //               if (_startDate == null) {
      //                 var dates;
      //                 dates = DateFormat('dd/MM/yyyy')
      //                     .parse(productController.deliveryDateController.text);
      //                 debugPrint(dates.toString());
      //
      //                 date = DateFormat('yyyy-MM-dd').format(dates);
      //               } else {
      //                 date = DateFormat('yyyy-MM-dd').format(_startDate);
      //               }
      //
      //               debugPrint(date);
      //
      //               productController.updateProductCall(
      //                   productController.productDetail[0].id,
      //                   productController.designT.text,
      //                   productController.partyT.text,
      //                   double.parse(productController.caratT.text),
      //                   double.parse(productController.weightT.text),
      //                   date,
      //                   productController.descripT.text);
      //
      //               productController.isFilterApplyed.value = false;
      //             }
      //           },
      //           btnName: "Save",
      //         ),
      //       )
      //     : const SizedBox(),
      backgroundColor: ConstColour.bgColor,
      body: SingleChildScrollView(
        controller: ScrollController(),
        scrollDirection: Axis.vertical,
        child: Obx(
          () => productController.productDetail.isEmpty
              ? Loaders(
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
                        const Icon(Icons.image, size: 300, color: Colors.grey),
                        SizedBox(
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
                                    return const Padding(
                                      padding: EdgeInsets.all(4.0),
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
                                borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: deviceWidth * 0.005)),
                            title: Container(
                                width: deviceWidth * 0.1,
                                height: deviceHeight * 0.005,
                                color: Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                                borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: deviceWidth * 0.005)),
                            title: Container(
                                width: deviceWidth * 0.1,
                                height: deviceHeight * 0.005,
                                color: Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                                borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: deviceWidth * 0.005)),
                            title: Container(
                                width: deviceWidth * 0.1,
                                height: deviceHeight * 0.005,
                                color: Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                                borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: deviceWidth * 0.005)),
                            title: Container(
                                width: deviceWidth * 0.1,
                                height: deviceHeight * 0.005,
                                color: Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                                borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: deviceWidth * 0.005)),
                            title: Container(
                                width: deviceWidth * 0.1,
                                height: deviceHeight * 0.005,
                                color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              :
          // productController.isFilterApplyed.value == true
          //         ?

          Obx(
                () => Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Container(
                                      height: deviceHeight * 0.4,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          color: Colors.white),
                                      child: productController.isLoading.value ==
                                              true
                                          ? const Center(
                                              child: CircularProgressIndicator(
                                                color: ConstColour.primaryColor,
                                              ),
                                            )
                                          : ClipRRect(
                                              borderRadius:  BorderRadius.circular(16),
                                              child: CachedNetworkImage(
                                                width: double.infinity,
                                                fit: BoxFit.contain,
                                                progressIndicatorBuilder:
                                                    (context, url,
                                                            downloadProgress) =>
                                                        Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          value: downloadProgress
                                                              .progress,
                                                          color: ConstColour
                                                              .primaryColor),
                                                ),
                                                imageUrl: productController
                                                    .productDetail[0].image
                                                    .toString(),
                                                fadeInCurve: Curves.easeInOutQuad,
                                                // placeholder: (context, url) => const Icon(Icons.image,size: 65, color: ConstColour.loadImageColor),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error,
                                                            size: 45),
                                              ),
                                            ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: productController
                                                  .imgList.isNotEmpty
                                              ? IconButton(
                                                  onPressed: () {

                                                    showCupertinoModalPopup(
                                                      filter: const ColorFilter.mode(
                                                          ConstColour
                                                              .primaryColor,
                                                          BlendMode.clear),
                                                      semanticsDismissible: false,
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  10)),

                                                          shadowColor:
                                                          Colors.white,
                                                          elevation: 8.0,
                                                          // backgroundColor: Colors.white,
                                                          backgroundColor: Colors
                                                              .orange.shade100,
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
                                                              fontFamily: ConstFont
                                                                  .poppinsRegular,
                                                              fontSize: 16,
                                                              color: Colors.black,
                                                            ),
                                                            maxLines: 2,
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                          ),
                                                          actions: [
                                                            InkWell(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  5),
                                                              onTap: () {
                                                                Get.back();
                                                              },
                                                              splashColor:
                                                              ConstColour
                                                                  .btnHowerColor,
                                                              child: Container(
                                                                decoration:
                                                                BoxDecoration(
                                                                  // gradient: const LinearGradient(colors: [Colors.white,Colors.black26]),
                                                                    borderRadius:
                                                                    BorderRadius.circular(
                                                                        5),
                                                                    color: Colors
                                                                        .red),
                                                                child:
                                                                const Padding(
                                                                  padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                      6.0),
                                                                  child: Text(
                                                                    'Cancel',
                                                                    style:
                                                                    TextStyle(
                                                                      fontFamily:
                                                                      ConstFont
                                                                          .poppinsRegular,
                                                                      fontSize:
                                                                      12,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            InkWell(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  5),
                                                              onTap: () {
                                                                setState(() {
                                                                  imageNotes = null;
                                                                  productController.imgList.clear();
                                                                  productController.isLoading.value = true;
                                                                  productController.passOldImage();
                                                                });
                                                                Get.back();
                                                              },
                                                              splashColor:
                                                              ConstColour
                                                                  .btnHowerColor,
                                                              child: Container(
                                                                decoration:
                                                                BoxDecoration(
                                                                  // gradient: const LinearGradient(colors: [Colors.white,Colors.black26]),
                                                                    borderRadius:
                                                                    BorderRadius.circular(
                                                                        5),
                                                                    color: Colors
                                                                        .black),
                                                                child:
                                                                const Padding(
                                                                  padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                      6.0),
                                                                  child: Text(
                                                                    '    Ok    ',
                                                                    style:
                                                                    TextStyle(
                                                                      fontFamily:
                                                                      ConstFont
                                                                          .poppinsRegular,
                                                                      fontSize:
                                                                      12,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );





                                                  },
                                                  icon: const Icon(
                                                    Icons.cancel_outlined,
                                                    color: Colors.red,
                                                    size: 24,
                                                  ))
                                              : const SizedBox(),
                                        ),
                                        productController.imgList.isEmpty ?   Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black,
                                            ),
                                            child: IconButton(
                                                splashColor:
                                                    ConstColour.btnHowerColor,
                                                splashRadius: deviceWidth * 0.1,
                                                iconSize: 30,
                                                onPressed: () {
                                                  imageSelectionDialoge();
                                                },
                                                // icon: Image.asset("asset/icons/image-editing.gif",width: deviceWidth * 0.15,)
                                                icon: const Icon(
                                                  CupertinoIcons
                                                      .camera_on_rectangle,
                                                  color: ConstColour.primaryColor,
                                                )),
                                          ),
                                        ) : const SizedBox()
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),


                            Container(
                              child:
                                  // productController
                                  //         .productDetail[0].orderImages.isEmpty
                                  //     ? const SizedBox()
                                  //     :
                                  SizedBox(
                                height: deviceHeight * 0.09,
                                child: Row(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: ConstColour.primaryColor,
                                                  strokeAlign: BorderSide
                                                      .strokeAlignInside,
                                                  style: BorderStyle.solid)),
                                          child: InkWell(
                                              onTap: () {
                                                _pickImages();
                                              },
                                              child: const Icon(
                                                Icons.add,
                                                size: 60,
                                                color: Colors.grey,
                                              )),
                                        )),
                                    productController.isLoadingSec.value == true
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                left: deviceWidth * 0.3),
                                            child:
                                                const CircularProgressIndicator(
                                              color: ConstColour.primaryColor,
                                            ),
                                          )
                                        : Expanded(
                                            child: ListView.builder(
                                              controller: ScrollController(),
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              itemCount: productController
                                                  .productDetail[0]
                                                  .orderImages
                                                  .length,
                                              itemBuilder: (context, index) {
                                                debugPrint(productController
                                                    .productDetail[0]
                                                    .orderImages[index]
                                                    .path);
                                                return InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder:
                                                          (BuildContext context) {
                                                        return Dialog(
                                                          child: Container(
                                                            color: Colors
                                                                .transparent,
                                                            child: PhotoView(
                                                              tightMode: true,
                                                              backgroundDecoration:
                                                                  const BoxDecoration(
                                                                      color: Colors
                                                                          .transparent),
                                                              imageProvider: productController.productDetail[0].orderImages[index].path.startsWith('http://') ?
                                                              NetworkImage(
                                                                productController.productDetail[0].orderImages[index].path,
                                                              ) : NetworkImage(
                                                                "http://208.64.33.118:8558/Files/" +  productController.productDetail[0].orderImages[index].path,
                                                              ),
                                                              heroAttributes:
                                                                  const PhotoViewHeroAttributes(
                                                                      tag:
                                                                          "someTag"),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Stack(
                                                    alignment: Alignment.topRight,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                                5.0),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          child: Container(
                                                            height: deviceHeight *
                                                                0.09,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            child: productController.productDetail[0].orderImages[index].path.startsWith('http://')
                                                                ? CachedNetworkImage(
                                                                    imageUrl: productController.productDetail[0].orderImages[index].path,
                                                                    fit: BoxFit.contain,
                                                                    fadeInCurve: Curves.easeInOutQuad,
                                                                    width: deviceWidth * 0.16,
                                                                    placeholder: (context, url) =>
                                                                        const Icon(
                                                                            Icons.image,
                                                                            size: 65,
                                                                            color: ConstColour.loadImageColor),
                                                                    errorWidget: (context, url,
                                                                            error) =>
                                                                        const Icon(
                                                                            Icons
                                                                                .error,
                                                                            size:
                                                                                45),
                                                                  )
                                                                : CachedNetworkImage(
                                                                    fit: BoxFit
                                                                        .contain,
                                                                    imageUrl: "http://208.64.33.118:8558/Files/" +
                                                                        productController
                                                                            .productDetail[
                                                                                0]
                                                                            .orderImages[
                                                                                index]
                                                                            .path,
                                                                    fadeInCurve:
                                                                        Curves
                                                                            .easeInOutQuad,
                                                                    width:
                                                                        deviceWidth *
                                                                            0.16,
                                                                    placeholder: (context,
                                                                            url) =>
                                                                        const Icon(
                                                                            Icons
                                                                                .image,
                                                                            size:
                                                                                65,
                                                                            color:
                                                                                ConstColour.loadImageColor),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        const Icon(
                                                                            Icons
                                                                                .error,
                                                                            size:
                                                                                45),
                                                                  ),
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        left: deviceWidth * 0.1,
                                                        bottom:
                                                            deviceHeight * 0.05,
                                                        child: Container(
                                                          child: productController
                                                                      .productDetail[
                                                                          0]
                                                                      .orderImages !=
                                                                  null
                                                              ? IconButton(
                                                                  onPressed: () {
                                                                    showCupertinoModalPopup(
                                                                      filter: const ColorFilter.mode(
                                                                          ConstColour
                                                                              .primaryColor,
                                                                          BlendMode.clear),
                                                                      semanticsDismissible: false,
                                                                      context: context,
                                                                      builder: (BuildContext context) {
                                                                        return AlertDialog(
                                                                          shape: RoundedRectangleBorder(
                                                                              borderRadius:
                                                                              BorderRadius
                                                                                  .circular(
                                                                                  10)),

                                                                          shadowColor:
                                                                          Colors.white,
                                                                          elevation: 8.0,
                                                                          // backgroundColor: Colors.white,
                                                                          backgroundColor: Colors
                                                                              .orange.shade100,
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
                                                                              fontFamily: ConstFont
                                                                                  .poppinsRegular,
                                                                              fontSize: 16,
                                                                              color: Colors.black,
                                                                            ),
                                                                            maxLines: 2,
                                                                            overflow: TextOverflow
                                                                                .ellipsis,
                                                                          ),
                                                                          actions: [
                                                                            InkWell(
                                                                              borderRadius:
                                                                              BorderRadius
                                                                                  .circular(
                                                                                  5),
                                                                              onTap: () {
                                                                                Get.back();
                                                                              },
                                                                              splashColor:
                                                                              ConstColour
                                                                                  .btnHowerColor,
                                                                              child: Container(
                                                                                decoration:
                                                                                BoxDecoration(
                                                                                  // gradient: const LinearGradient(colors: [Colors.white,Colors.black26]),
                                                                                    borderRadius:
                                                                                    BorderRadius.circular(
                                                                                        5),
                                                                                    color: Colors
                                                                                        .red),
                                                                                child:
                                                                                const Padding(
                                                                                  padding:
                                                                                  EdgeInsets
                                                                                      .all(
                                                                                      6.0),
                                                                                  child: Text(
                                                                                    'Cancel',
                                                                                    style:
                                                                                    TextStyle(
                                                                                      fontFamily:
                                                                                      ConstFont
                                                                                          .poppinsRegular,
                                                                                      fontSize:
                                                                                      12,
                                                                                      color: Colors
                                                                                          .white,
                                                                                    ),
                                                                                    overflow:
                                                                                    TextOverflow
                                                                                        .ellipsis,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            InkWell(
                                                                              borderRadius:
                                                                              BorderRadius
                                                                                  .circular(
                                                                                  5),
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  productController.productDetail[0].orderImages.removeAt(index);
                                                                                });
                                                                                Get.back();
                                                                              },
                                                                              splashColor:
                                                                              ConstColour
                                                                                  .btnHowerColor,
                                                                              child: Container(
                                                                                decoration:
                                                                                BoxDecoration(
                                                                                  // gradient: const LinearGradient(colors: [Colors.white,Colors.black26]),
                                                                                    borderRadius:
                                                                                    BorderRadius.circular(
                                                                                        5),
                                                                                    color: Colors
                                                                                        .black),
                                                                                child:
                                                                                const Padding(
                                                                                  padding:
                                                                                  EdgeInsets
                                                                                      .all(
                                                                                      6.0),
                                                                                  child: Text(
                                                                                    '    Ok    ',
                                                                                    style:
                                                                                    TextStyle(
                                                                                      fontFamily:
                                                                                      ConstFont
                                                                                          .poppinsRegular,
                                                                                      fontSize:
                                                                                      12,
                                                                                      color: Colors
                                                                                          .white,
                                                                                    ),
                                                                                    overflow:
                                                                                    TextOverflow
                                                                                        .ellipsis,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    );

                                                                  },
                                                                  icon:
                                                                      const Icon(
                                                                    Icons
                                                                        .cancel_outlined,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 20,
                                                                  ))
                                                              : const SizedBox(),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),

                            Divider(
                              height: deviceHeight * 0.01,
                             ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,

                                controller: productController.designT,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please Enter Design";
                                  } else {
                                    return null;
                                  }
                                },
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: ConstFont.poppinsRegular,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                decoration: InputDecoration(
                                  isDense: true,
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
                                    borderSide:
                                    const BorderSide(color: ConstColour.primaryColor),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: ConstColour.primaryColor),
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: ConstColour.textFieldBorder),
                                  ),
                                  labelText: 'Design Name',
                                  labelStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontFamily: ConstFont.poppinsRegular),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: productController.partyT,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please Enter Partyname";
                                  } else {
                                    return null;
                                  }
                                },
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: ConstFont.poppinsRegular,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                decoration: InputDecoration(
                                  isDense: true,
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
                                    borderSide:
                                    const BorderSide(color: ConstColour.primaryColor),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: ConstColour.primaryColor),
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: ConstColour.textFieldBorder),
                                  ),
                                  labelText: 'Party Name',
                                  labelStyle: const TextStyle(
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
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      controller: productController.caratT,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please Enter Carat";
                                        } else {
                                          return null;
                                        }
                                      },
                                      inputFormatters: [
                                        FilteringTextInputFormatter.deny(
                                            RegExp(r'\s')),
                                      ],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: ConstFont.poppinsRegular,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      decoration: InputDecoration(
                                        isDense: true,
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
                                          borderSide:
                                          const BorderSide(color: ConstColour.primaryColor),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: ConstColour.primaryColor),
                                          borderRadius: BorderRadius.all(Radius.circular(8)),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                              color: ConstColour.textFieldBorder),
                                        ),
                                        labelText: 'Carat',
                                        labelStyle: const TextStyle(
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
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      controller: productController.weightT,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please Enter Weight";
                                        } else {
                                          return null;
                                        }
                                      },
                                      inputFormatters: [
                                        FilteringTextInputFormatter.deny(
                                            RegExp(r'\s')),
                                      ],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: ConstFont.poppinsRegular,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      decoration: InputDecoration(
                                        isDense: true,
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
                                          borderSide:
                                          const BorderSide(color: ConstColour.primaryColor),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide:
                                          BorderSide(color: ConstColour.primaryColor),
                                          borderRadius: BorderRadius.all(Radius.circular(8)),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: const BorderSide(
                                              color: ConstColour.textFieldBorder),
                                        ),
                                        labelText: 'Weight',
                                        labelStyle: const TextStyle(
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
                              padding: EdgeInsets.only(
                                  top: deviceHeight * 0.01,
                                  left: deviceWidth * 0.03,
                                  right: deviceWidth * 0.03),
                              child: TextFormField(
                                onTap: () async {
                                  final DateTime? pickedDate =
                                      await showDatePicker(
                                    context: Get.context!,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2050),
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
                                    });
                                  }
                                  debugPrint(DateFormat('dd-MM-yyyy')
                                      .format(_startDate!));
                                  productController.deliveryDateController.text =
                                      DateFormat('dd-MM-yyyy')
                                          .format(_startDate!)
                                          .toString();
                                },
                                textAlign: TextAlign.start,
                                enableInteractiveSelection: false,
                                keyboardType: TextInputType.none,
                                controller:
                                    productController.deliveryDateController,
                                autocorrect: true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                showCursor: false,
                                decoration: InputDecoration(
                                    isDense: true,
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
                                    errorStyle: const TextStyle(
                                        color: ConstColour.errorHint),
                                    border: InputBorder.none,
                                    filled: true,
                                    enabled: true,
                                    labelText: "Delivery Date",
                                    hintText: _startDate == null
                                        ? "Select Date"
                                        : DateFormat('dd-MM-yyyy')
                                            .format(_startDate)
                                            .toString(),
                                    hintStyle:
                                        const TextStyle(color: Colors.white),
                                    floatingLabelStyle:
                                        const TextStyle(color: Colors.white),
                                    suffixIcon: const Icon(
                                      Icons.calendar_month_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    )),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Select Delivery Date";
                                  }
                                  return null;
                                },
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: ConstFont.poppinsRegular),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                maxLines: 3,
                                controller: productController.descripT,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please Enter Description";
                                  } else {
                                    return null;
                                  }
                                },
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: ConstFont.poppinsRegular,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                decoration: InputDecoration(
                                  isDense: true,
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
                                    borderSide:
                                    const BorderSide(color: ConstColour.primaryColor),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: ConstColour.primaryColor),
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                        color: ConstColour.textFieldBorder),
                                  ),
                                  labelText: 'Description',
                                  labelStyle: const TextStyle(
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
                    )
                  // : Obx(
                  //     () => Column(
                  //       children: [
                  //         Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: Center(
                  //             child: Container(
                  //               height: deviceHeight * 0.4,
                  //               width: double.infinity,
                  //               decoration: BoxDecoration(
                  //                   borderRadius: BorderRadius.circular(16),
                  //                   color: Colors.white),
                  //               child: ClipRRect(
                  //                 borderRadius: BorderRadius.circular(16),
                  //                 child: CachedNetworkImage(
                  //                   width: double.infinity,
                  //                   fadeInCurve: Curves.easeInOutQuad,
                  //                   fit: BoxFit.contain,
                  //                   imageUrl: productController.productDetail[0].image.toString(),
                  //                   placeholder: (context, url) => const Icon(
                  //                       Icons.image,
                  //                       size: 65,
                  //                       color: ConstColour.loadImageColor),
                  //                   errorWidget: (context, url, error) =>
                  //                       const Icon(Icons.error, size: 45),
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //         Container(
                  //           child: productController.productDetail[0].orderImages.isEmpty
                  //               ? const SizedBox()
                  //               : SizedBox(
                  //                   height: deviceHeight * 0.09,
                  //                   child: Row(
                  //                     children: [
                  //                       Expanded(
                  //                         child: ListView.builder(
                  //                           controller: ScrollController(),
                  //                           scrollDirection: Axis.horizontal,
                  //                           shrinkWrap: true,
                  //                           itemCount: productController.productDetail[0].orderImages.length,
                  //                           itemBuilder: (context, index) {
                  //                             return InkWell(
                  //                               onTap: () {
                  //                                 showDialog(
                  //                                   context: context,
                  //                                   builder:
                  //                                       (BuildContext context) {
                  //                                     return Dialog(
                  //                                       child: Container(
                  //                                         color: Colors
                  //                                             .transparent,
                  //                                         child: PhotoView(
                  //                                           tightMode: true,
                  //                                           backgroundDecoration:
                  //                                               const BoxDecoration(
                  //                                                   color: Colors
                  //                                                       .transparent),
                  //                                           imageProvider:
                  //                                               NetworkImage(
                  //                                             productController.productDetail[0]
                  //                                                 .orderImages[
                  //                                                     index]
                  //                                                 .path,
                  //                                           ),
                  //                                           heroAttributes:
                  //                                               const PhotoViewHeroAttributes(
                  //                                                   tag:
                  //                                                       "someTag"),
                  //                                         ),
                  //                                       ),
                  //                                     );
                  //                                   },
                  //                                 );
                  //                               },
                  //                               child: Padding(
                  //                                 padding:
                  //                                     const EdgeInsets.all(5.0),
                  //                                 child: Container(
                  //                                   decoration: BoxDecoration(
                  //                                     color: Colors.white,
                  //                                     borderRadius:
                  //                                         BorderRadius.circular(
                  //                                             8),
                  //                                   ),
                  //                                   child: ClipRRect(
                  //                                     borderRadius:
                  //                                         BorderRadius.circular(
                  //                                             8),
                  //                                     child: CachedNetworkImage(
                  //                                       imageUrl:
                  //                                           productController
                  //                                               .productDetail[
                  //                                                   0]
                  //                                               .orderImages[
                  //                                                   index]
                  //                                               .path,
                  //                                       fit: BoxFit.contain,
                  //                                       fadeInCurve: Curves
                  //                                           .easeInOutQuad,
                  //                                       width:
                  //                                           deviceWidth * 0.16,
                  //                                       placeholder: (context,
                  //                                               url) =>
                  //                                           const Icon(
                  //                                               Icons.image,
                  //                                               size: 65,
                  //                                               color: ConstColour
                  //                                                   .loadImageColor),
                  //                                       errorWidget: (context,
                  //                                               url, error) =>
                  //                                           const Icon(
                  //                                               Icons.error,
                  //                                               size: 45),
                  //                                     ),
                  //                                   ),
                  //                                 ),
                  //                               ),
                  //                             );
                  //                           },
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //         ),
                  //         Divider(
                  //           height: deviceHeight * 0.01,
                  //         ),
                  //         Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: TextField(
                  //             controller: productController.designT,
                  //             enableInteractiveSelection: false,
                  //             keyboardType: TextInputType.none,
                  //             showCursor: false,
                  //             // inputFormatters: [
                  //             //
                  //             // ],
                  //             style: const TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 18,
                  //               fontFamily: ConstFont.poppinsRegular,
                  //               overflow: TextOverflow.ellipsis,
                  //             ),
                  //             decoration: InputDecoration(
                  //               enabledBorder: OutlineInputBorder(
                  //                 borderRadius: BorderRadius.circular(11),
                  //                 borderSide: const BorderSide(
                  //                     color: ConstColour.primaryColor),
                  //               ),
                  //               focusedBorder: OutlineInputBorder(
                  //                 borderRadius: BorderRadius.circular(11),
                  //                 borderSide: const BorderSide(
                  //                     color: ConstColour.primaryColor),
                  //               ),
                  //               labelText: 'Design Name',
                  //               labelStyle: const TextStyle(
                  //                   color: Colors.white,
                  //                   fontSize: 17,
                  //                   fontFamily: ConstFont.poppinsRegular),
                  //             ),
                  //           ),
                  //         ),
                  //         Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: TextFormField(
                  //             enableInteractiveSelection: false,
                  //             keyboardType: TextInputType.none,
                  //             showCursor: false,
                  //             controller: productController.partyT,
                  //             style: const TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 18,
                  //               fontFamily: ConstFont.poppinsRegular,
                  //               overflow: TextOverflow.ellipsis,
                  //             ),
                  //             decoration: InputDecoration(
                  //               enabledBorder: OutlineInputBorder(
                  //                 borderRadius: BorderRadius.circular(11),
                  //                 borderSide: const BorderSide(
                  //                     color: ConstColour.primaryColor),
                  //               ),
                  //               focusedBorder: OutlineInputBorder(
                  //                 borderRadius: BorderRadius.circular(11),
                  //                 borderSide: const BorderSide(
                  //                     color: ConstColour.primaryColor),
                  //               ),
                  //               labelText: 'Party Name',
                  //               labelStyle: const TextStyle(
                  //                   color: Colors.white,
                  //                   fontSize: 17,
                  //                   fontFamily: ConstFont.poppinsRegular),
                  //             ),
                  //           ),
                  //         ),
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Expanded(
                  //               child: Padding(
                  //                 padding: const EdgeInsets.all(8.0),
                  //                 child: TextFormField(
                  //                   controller: productController.caratT,
                  //                   enableInteractiveSelection: false,
                  //                   keyboardType: TextInputType.none,
                  //                   showCursor: false,
                  //                   style: const TextStyle(
                  //                     color: Colors.white,
                  //                     fontSize: 18,
                  //                     fontFamily: ConstFont.poppinsRegular,
                  //                     overflow: TextOverflow.ellipsis,
                  //                   ),
                  //                   decoration: InputDecoration(
                  //                     enabledBorder: OutlineInputBorder(
                  //                       borderRadius: BorderRadius.circular(11),
                  //                       borderSide: const BorderSide(
                  //                           color: ConstColour.primaryColor),
                  //                     ),
                  //                     focusedBorder: OutlineInputBorder(
                  //                       borderRadius: BorderRadius.circular(11),
                  //                       borderSide: const BorderSide(
                  //                           color: ConstColour.primaryColor),
                  //                     ),
                  //                     labelText: 'Carat',
                  //                     labelStyle: const TextStyle(
                  //                         color: Colors.white,
                  //                         fontSize: 17,
                  //                         fontFamily: ConstFont.poppinsRegular),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //             Expanded(
                  //               child: Padding(
                  //                 padding: const EdgeInsets.all(8.0),
                  //                 child: TextFormField(
                  //                   controller: productController.weightT,
                  //                   enableInteractiveSelection: false,
                  //                   keyboardType: TextInputType.none,
                  //                   showCursor: false,
                  //                   style: const TextStyle(
                  //                     color: Colors.white,
                  //                     fontSize: 18,
                  //                     fontFamily: ConstFont.poppinsRegular,
                  //                     overflow: TextOverflow.ellipsis,
                  //                   ),
                  //                   decoration: InputDecoration(
                  //                     enabledBorder: OutlineInputBorder(
                  //                       borderRadius: BorderRadius.circular(11),
                  //                       borderSide: const BorderSide(
                  //                           color: ConstColour.primaryColor),
                  //                     ),
                  //                     focusedBorder: OutlineInputBorder(
                  //                       borderRadius: BorderRadius.circular(11),
                  //                       borderSide: const BorderSide(
                  //                           color: ConstColour.primaryColor),
                  //                     ),
                  //                     labelText: 'Weight',
                  //                     labelStyle: const TextStyle(
                  //                         color: Colors.white,
                  //                         fontSize: 17,
                  //                         fontFamily: ConstFont.poppinsRegular),
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //         Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: TextFormField(
                  //             controller:
                  //                 productController.createDateController,
                  //             enableInteractiveSelection: false,
                  //             keyboardType: TextInputType.none,
                  //             showCursor: false,
                  //             style: const TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 18,
                  //               fontFamily: ConstFont.poppinsRegular,
                  //               overflow: TextOverflow.ellipsis,
                  //             ),
                  //             decoration: InputDecoration(
                  //               enabledBorder: OutlineInputBorder(
                  //                 borderRadius: BorderRadius.circular(11),
                  //                 borderSide: const BorderSide(
                  //                     color: ConstColour.primaryColor),
                  //               ),
                  //               focusedBorder: OutlineInputBorder(
                  //                 borderRadius: BorderRadius.circular(11),
                  //                 borderSide: const BorderSide(
                  //                     color: ConstColour.primaryColor),
                  //               ),
                  //               labelText: 'Create Date',
                  //               labelStyle: const TextStyle(
                  //                   color: Colors.white,
                  //                   fontSize: 17,
                  //                   fontFamily: ConstFont.poppinsRegular),
                  //             ),
                  //             // onTap: () async {
                  //             //   DateTime? pickedDate = await showDatePicker(
                  //             //       context: context,
                  //             //       initialDate: DateTime.now(),
                  //             //       firstDate: DateTime(1950),
                  //             //       lastDate: DateTime(2100),
                  //             //     builder: (BuildContext context, picker) {
                  //             //       return Theme(
                  //             //           data: ThemeData.dark().copyWith(
                  //             //             colorScheme: const ColorScheme.dark(
                  //             //               primary: Colors.white,
                  //             //               onPrimary: Colors.black,
                  //             //               surface: ConstColour.bgColor,
                  //             //               onSurface: Colors.white
                  //             //             ),
                  //             //             dialogBackgroundColor: ConstColour.primaryColor
                  //             //           ),
                  //             //           child: picker!
                  //             //       );
                  //             //     },
                  //             //   );
                  //             //   if (pickedDate != null && pickedDate != DateTime.now()) {
                  //             //     String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                  //             //     _createDateController.text = formattedDate;
                  //             //   }
                  //             // },
                  //           ),
                  //         ),
                  //         Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: TextFormField(
                  //             controller:
                  //                 productController.deliveryDateController,
                  //             enableInteractiveSelection: false,
                  //             keyboardType: TextInputType.none,
                  //             showCursor: false,
                  //             style: const TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 18,
                  //               fontFamily: ConstFont.poppinsRegular,
                  //               overflow: TextOverflow.ellipsis,
                  //             ),
                  //             decoration: InputDecoration(
                  //               enabledBorder: OutlineInputBorder(
                  //                 borderRadius: BorderRadius.circular(11),
                  //                 borderSide: const BorderSide(
                  //                     color: ConstColour.primaryColor),
                  //               ),
                  //               focusedBorder: OutlineInputBorder(
                  //                 borderRadius: BorderRadius.circular(11),
                  //                 borderSide: const BorderSide(
                  //                     color: ConstColour.primaryColor),
                  //               ),
                  //               labelText: 'Delivery Date',
                  //               labelStyle: const TextStyle(
                  //                   color: Colors.white,
                  //                   fontSize: 17,
                  //                   fontFamily: ConstFont.poppinsRegular),
                  //             ),
                  //             // onTap: () async {
                  //             //   DateTime? pickedDate = await showDatePicker(
                  //             //     context: context,
                  //             //     initialDate: DateTime.now(),
                  //             //     firstDate: DateTime(1950),
                  //             //     lastDate: DateTime(2100),
                  //             //     builder: (BuildContext context, picker) {
                  //             //       return Theme(
                  //             //           data: ThemeData.dark().copyWith(
                  //             //               colorScheme: const ColorScheme.dark(
                  //             //                   primary: Colors.white,
                  //             //                   onPrimary: Colors.black,
                  //             //                   surface: ConstColour.bgColor,
                  //             //                   onSurface: Colors.white
                  //             //               ),
                  //             //               dialogBackgroundColor: ConstColour.primaryColor
                  //             //           ),
                  //             //           child: picker!
                  //             //       );
                  //             //     },
                  //             //   );
                  //             //
                  //             //   if (pickedDate != null && pickedDate != DateTime.now()) {
                  //             //     String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                  //             //     _deliveryDateController.text = formattedDate;
                  //             //   }
                  //             // },
                  //           ),
                  //         ),
                  //         Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: TextFormField(
                  //             maxLines: 3,
                  //             controller: productController.descripT,
                  //             enableInteractiveSelection: false,
                  //             keyboardType: TextInputType.none,
                  //             showCursor: false,
                  //             style: const TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 18,
                  //               fontFamily: ConstFont.poppinsRegular,
                  //               overflow: TextOverflow.ellipsis,
                  //             ),
                  //             decoration: InputDecoration(
                  //               enabledBorder: OutlineInputBorder(
                  //                 borderRadius: BorderRadius.circular(11),
                  //                 borderSide: const BorderSide(
                  //                     color: ConstColour.primaryColor),
                  //               ),
                  //               focusedBorder: OutlineInputBorder(
                  //                 borderRadius: BorderRadius.circular(11),
                  //                 borderSide: const BorderSide(
                  //                     color: ConstColour.primaryColor),
                  //               ),
                  //               labelText: 'Description',
                  //               labelStyle: const TextStyle(
                  //                   color: Colors.white,
                  //                   fontSize: 17,
                  //                   fontFamily: ConstFont.poppinsRegular),
                  //             ),
                  //           ),
                  //         ),
                  //         Divider(
                  //           height: deviceHeight * 0.02,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
        ),
      ),
    );
  }
}
