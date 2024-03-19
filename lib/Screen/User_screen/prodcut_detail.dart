import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/Controller/User_Controller/productdetail_controller.dart';
import 'package:jewellery_user/Controller/User_Controller/user_home_con.dart';
import 'package:jewellery_user/Controller/home_Controller.dart';
import 'package:jewellery_user/Screen/videoplayer_screen.dart';
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

    return WillPopScope(
      onWillPop: () async {
        // userProductController.clearData();
        Get.back();
        return false;
      },
      child: Scaffold(

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
                // userProductController.clearData();
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios),
              color: ConstColour.primaryColor),
          actions: [
            IconButton(onPressed: () {
              userProductController.productDetail.clear();
              userProductController.getProductDetailCall(userHomeCon.userHome[0].orderUserId);
            }, icon: const Icon(Icons.replay_circle_filled,color: ConstColour.primaryColor,))
          ],

        ),

        bottomNavigationBar: Obx(
          () => userProductController.productDetail.isEmpty ? const
          SizedBox() :
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: NextButton(
                //     onPressed: () {
                //
                //       showCupertinoModalPopup(
                //         filter: const ColorFilter.mode(
                //             ConstColour
                //                 .primaryColor,
                //             BlendMode.clear),
                //         semanticsDismissible: false,
                //         context: context,
                //         builder: (BuildContext context) {
                //           return AlertDialog(
                //             shape: RoundedRectangleBorder(
                //                 borderRadius:
                //                 BorderRadius
                //                     .circular(
                //                     10)),
                //
                //             shadowColor:
                //             Colors.white,
                //             elevation: 8.0,
                //             // backgroundColor: Colors.white,
                //             backgroundColor: Colors
                //                 .orange.shade100,
                //             title:  Text(
                //               'order'.tr,
                //               style: const TextStyle(
                //                 fontSize: 22,
                //                 fontFamily: ConstFont.poppinsMedium,
                //                 color: Colors.black,
                //               ),
                //               overflow: TextOverflow
                //                   .ellipsis,
                //             ),
                //             content: Text(
                //               'orderdes'.tr,
                //               style: const TextStyle(
                //                 fontFamily: ConstFont.poppinsRegular,
                //                 fontSize: 16,
                //                 color: Colors.black,
                //               ),
                //               maxLines: 2,
                //               overflow: TextOverflow
                //                   .ellipsis,
                //             ),
                //             actions: [
                //               InkWell(
                //                 borderRadius:
                //                 BorderRadius
                //                     .circular(
                //                     5),
                //                 onTap: () {
                //                   Get.back();
                //                 },
                //                 splashColor:
                //                 ConstColour
                //                     .btnHowerColor,
                //                 child: Container(
                //                   decoration:
                //                   BoxDecoration(
                //                     // gradient: const LinearGradient(colors: [Colors.white,Colors.black26]),
                //                       borderRadius:
                //                       BorderRadius.circular(
                //                           5),
                //                       color: Colors
                //                           .red),
                //                   child:
                //                   Padding(
                //                     padding:
                //                     const EdgeInsets.all(6.0),
                //                     child: Text('cancel'.tr,
                //                       style:
                //                       const TextStyle(
                //                         fontFamily:
                //                         ConstFont
                //                             .poppinsRegular,
                //                         fontSize:
                //                         12,
                //                         color: Colors
                //                             .white,
                //                       ),
                //                       overflow:
                //                       TextOverflow
                //                           .ellipsis,
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //               InkWell(
                //                 borderRadius:
                //                 BorderRadius.circular(5),
                //                 onTap: () {
                //                   userProductController.assignComplete(
                //                       userProductController.orderUserId,
                //                       userProductController.reasonController.text
                //                   );
                //                   Get.back();
                //                 },
                //                 splashColor:
                //                 ConstColour
                //                     .btnHowerColor,
                //                 child: Container(
                //                   decoration:
                //                   BoxDecoration(
                //                     // gradient: const LinearGradient(colors: [Colors.white,Colors.black26]),
                //                       borderRadius:
                //                       BorderRadius.circular(
                //                           5),
                //                       color: Colors
                //                           .black),
                //                   child:
                //                    Padding(
                //                     padding:
                //                     const EdgeInsets
                //                         .all(
                //                         6.0),
                //                     child: Text(
                //                       'ok'.tr,
                //                       style:
                //                       const TextStyle(
                //                         fontFamily:
                //                         ConstFont
                //                             .poppinsRegular,
                //                         fontSize:
                //                         12,
                //                         color: Colors
                //                             .white,
                //                       ),
                //                       overflow:
                //                       TextOverflow
                //                           .ellipsis,
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             ],
                //           );
                //         },
                //       );
                //
                //
                //       // homeController.loading.value = true;
                //       // userProductController.assignComplete(
                //       //     userProductController.orderUserId,
                //       //     userProductController.reasonController.text
                //       // );
                //
                //     },
                //     btnName: "complete".tr,
                //   ),
                // ),


                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        minimumSize: Size(deviceWidth * 0.4, deviceHeight * 0.06),
                        maximumSize: Size(deviceWidth * 1.0, deviceHeight * 0.07),
                        backgroundColor: ConstColour.primaryColor
                    ),
                    onPressed: homeController.loading.value.obs == true ? null :  () {

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
                            title:  Text(
                              'order'.tr,
                              style: const TextStyle(
                                fontSize: 22,
                                fontFamily: ConstFont.poppinsMedium,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow
                                  .ellipsis,
                            ),
                            content: Text(
                              'orderdes'.tr,
                              style: const TextStyle(
                                fontFamily: ConstFont.poppinsRegular,
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
                                  Padding(
                                    padding:
                                    const EdgeInsets.all(6.0),
                                    child: Text('cancel'.tr,
                                      style:
                                      const TextStyle(
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
                                BorderRadius.circular(5),
                                onTap: () {
                                  userProductController.assignComplete(
                                      userProductController.orderUserId,
                                      userProductController.reasonController.text
                                  );
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
                                  Padding(
                                    padding:
                                    const EdgeInsets
                                        .all(
                                        6.0),
                                    child: Text(
                                      'ok'.tr,
                                      style:
                                      const TextStyle(
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


                      // homeController.loading.value = true;
                      // userProductController.assignComplete(
                      //     userProductController.orderUserId,
                      //     userProductController.reasonController.text
                      // );

                    },

                    child:  homeController.loading.value.obs == true
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    ) : Text("complete".tr,style:
                    const TextStyle(fontFamily: ConstFont.poppinsRegular,fontWeight: FontWeight.w600,
                        fontSize: 20,color: Colors.black),overflow: TextOverflow.ellipsis,textAlign
                        : TextAlign.center,)),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        minimumSize: Size(deviceWidth * 0.4, deviceHeight * 0.06),
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
                                             }, icon: const Icon(Icons.cancel_outlined,color: ConstColour.primaryColor,size: 24,))
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
                                              labelText: 'reason'.tr,
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
                                          child: NextButtonSec(
                                            btnName: "orderCancel".tr,
                                            onPressed: () {
                                              if(_formKey.currentState!.validate()){

                                                  homeController.loadingSec.value = true;
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
                      child:InkWell(
                        onTap: () {
                          if (userProductController.productDetail[0].image
                              .endsWith('.mp4')) {
                            showDialog(
                              context: context,
                              builder: (_) => Dialog(
                                backgroundColor:
                                Colors.white,
                                insetPadding:
                                EdgeInsets.zero,
                                insetAnimationDuration:
                                const Duration(
                                    milliseconds: 500),
                                child: VideoPlayerDialog(
                                    url: userProductController.productDetail[0].image),
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder:
                                  (BuildContext context) {
                                return Container(
                                  color: Colors.black,
                                  child: PhotoView(
                                    tightMode: true,
                                    filterQuality:
                                    FilterQuality.high,
                                    backgroundDecoration:
                                    const BoxDecoration(
                                      color: Colors.black,
                                    ),
                                    errorBuilder: (context, error, stackTrace) => Image.asset("asset/icons/no_image_available.png",
                                        width:
                                        double.infinity),
                                    loadingBuilder: (context,
                                        ImageChunkEvent?
                                        loadingProgress) {
                                      if (loadingProgress ==
                                          null) {
                                        return Container();
                                      } else {
                                        return Center(
                                          child:
                                          CircularProgressIndicator(
                                            color: ConstColour
                                                .primaryColor,
                                            value: loadingProgress
                                                .expectedTotalBytes !=
                                                null
                                                ? loadingProgress
                                                .cumulativeBytesLoaded /
                                                (loadingProgress.expectedTotalBytes ??
                                                    1)
                                                : null,
                                          ),
                                        );
                                      }
                                    },
                                    imageProvider: NetworkImage(
                                        userProductController.productDetail[0].image
                                            .toString()),
                                    heroAttributes:
                                    const PhotoViewHeroAttributes(
                                        tag: "someTag"),
                                  ),
                                );
                              },
                            );
                          }
                        },
                        child: userProductController.productDetail[0].image
                            .endsWith('.mp4')
                            ? ClipRRect(
                          borderRadius:
                          BorderRadius.circular(
                              16),
                          child: VideoItem(
                              url: userProductController.productDetail[0].image),
                        )
                            : ClipRRect(
                          borderRadius:
                          BorderRadius.circular(
                              16),
                          child: CachedNetworkImage(
                            width: double.infinity,
                            fit: BoxFit.contain,
                            progressIndicatorBuilder:
                                (context, url,
                                downloadProgress) =>
                                Center(
                                  child: CircularProgressIndicator(
                                      value:
                                      downloadProgress
                                          .progress,
                                      color: ConstColour
                                          .primaryColor),
                                ),
                            imageUrl:
                            userProductController.productDetail[0].image.toString(),
                            fadeInCurve:
                            Curves.easeInOutQuad,
                            // placeholder: (context, url) => const Icon(Icons.image,size: 65, color: ConstColour.loadImageColor),
                            errorWidget: (context, url, error) =>
                                Image.asset("asset/icons/no_image_available.png",
                                    width:
                                    double.infinity),
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child:
                      //   CachedNetworkImage(
                      //     width: double.infinity,
                      //     imageUrl: userProductController.productDetail[0].image.toString(),
                      //     fadeInCurve: Curves.easeInOutQuad,
                      //     placeholder: (context, url) => const Icon(Icons.image,size: 100,color : ConstColour.loadImageColor),
                      //     errorWidget: (context, url, error) => const Icon(Icons.error,size: 100),
                      //   )
                      // ),
                    ),
                  ),
                ),
                userProductController.productDetail[0].orderImages.isEmpty  ? const SizedBox() :  SizedBox(
                  height: deviceHeight * 0.09,
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

                                if(userProductController.productDetail[0].orderImages[index].path.endsWith('.mp4')){
                                  showDialog(
                                    context: context,
                                    builder: (_) =>
                                        Dialog(
                                          backgroundColor:
                                          Colors
                                              .white,
                                          insetPadding:
                                          EdgeInsets
                                              .zero,
                                          insetAnimationDuration:
                                          const Duration(
                                              milliseconds: 500),
                                          child: VideoPlayerDialog(
                                              url:
                                              userProductController.productDetail[0].orderImages[index].path),
                                        ),
                                  );
                                }else{
                                  showDialog(
                                    context:
                                    context,
                                    builder:
                                        (BuildContext
                                    context) {
                                      return Container(
                                        color: Colors
                                            .black,
                                        child:
                                        PhotoView(
                                          tightMode:
                                          true,
                                          filterQuality:
                                          FilterQuality.high,
                                          backgroundDecoration:
                                          const BoxDecoration(
                                            color:
                                            Colors.black,
                                          ),
                                          loadingBuilder:
                                              (context, ImageChunkEvent? loadingProgress) {
                                            if (loadingProgress ==
                                                null) {
                                              return Container();
                                            } else {
                                              return Center(
                                                child: CircularProgressIndicator(
                                                  color: ConstColour.primaryColor,
                                                  value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1) : null,
                                                ),
                                              );
                                            }
                                          },
                                          errorBuilder: (context, error, stackTrace) => Image.asset("asset/icons/no_image_available.png",
                                              width:
                                              double.infinity),
                                          imageProvider:
                                          NetworkImage(
                                            userProductController.productDetail[0].orderImages[index].path,
                                          ),
                                          heroAttributes:
                                          const PhotoViewHeroAttributes(tag: "someTag"),
                                        ),
                                      );
                                    },
                                  );
                                }

                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  height: deviceHeight * 0.09,
                                  width: deviceWidth * 0.16,
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8),),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child:userProductController.productDetail[0].orderImages[index].path
                                        .endsWith(
                                        '.mp4')
                                        ? VideoItem(
                                        url: userProductController.productDetail[0].orderImages[index].path)
                                        : ImageItem(
                                        url:
                                        userProductController.productDetail[0].orderImages[index].path)

                                    // CachedNetworkImage(
                                    //   width: deviceWidth * 0.16,
                                    //   imageUrl: userProductController.productDetail[0].orderImages[index].path,
                                    //   fadeInCurve: Curves.easeInOutQuad,
                                    //   placeholder: (context, url) => const Icon(Icons.image,size: 65,color : ConstColour.loadImageColor),
                                    //   errorWidget: (context, url, error) => const Icon(Icons.error,size: 45),
                                    // ),
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
                          style: const TextStyle(
                            color: ConstColour.textColor,
                            fontSize: 16,
                            fontFamily: ConstFont.poppinsRegular,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 3,

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
                          style: const TextStyle(
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
                          style: const TextStyle(
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
                          style: const TextStyle(
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
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Expanded(
                //         child: Text(
                //           'deliveryDate'.tr,
                //           style: const TextStyle(
                //             color: ConstColour.btnHowerColor,
                //             fontSize: 15,
                //             fontFamily: ConstFont.poppinsRegular,
                //             overflow: TextOverflow.ellipsis,
                //           ),
                //         ),
                //       ),
                //       Expanded(
                //         child: Text(
                //           ': ${userProductController.deliveryDate}',
                //           style: const TextStyle(
                //             color: ConstColour.textColor,
                //             fontSize: 16,
                //             fontFamily: ConstFont.poppinsRegular,
                //             overflow: TextOverflow.ellipsis,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                (userProductController.notes == "" || userProductController.notes == null) ? const SizedBox() : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {

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

                            title: Text(
                              'notes'.tr,
                              style: const TextStyle(
                                fontSize: 22,
                                fontFamily: ConstFont.poppinsMedium,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow
                                  .ellipsis,
                            ),
                            content: Text(
                              userProductController.notes,
                              style: const TextStyle(
                                fontFamily: ConstFont.poppinsRegular,
                                fontSize: 16,
                                color: Colors.black,
                              ),
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
                                  child: Padding(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: deviceWidth * 0.04,vertical: deviceHeight * 0.005),
                                    child:  Text('close'.tr,
                                      style:
                                      const TextStyle(
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'notes'.tr,
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
                            ': ${userProductController.notes}',
                            style: const TextStyle(
                              color: ConstColour.textColor,
                              fontSize: 16,
                              fontFamily: ConstFont.poppinsRegular,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // showDialog(context: context, builder: (context) {
                    //   return Dialog(
                    //     child: ListTile(
                    //       title: Text(
                    //         'description'.tr,
                    //         style: const TextStyle(
                    //           color: ConstColour.btnHowerColor,
                    //           fontSize: 15,
                    //           fontFamily: ConstFont.poppinsRegular,
                    //           overflow: TextOverflow.ellipsis,
                    //         ),
                    //       ),
                    //       subtitle: Text(
                    //         ": ${userProductController.description}",
                    //         maxLines: 7,
                    //         style:  const TextStyle(
                    //           color: ConstColour.textColor,
                    //           fontSize: 16,
                    //           fontFamily: ConstFont.poppinsRegular,
                    //           overflow: TextOverflow.ellipsis,
                    //         ),
                    //         softWrap: true,
                    //       ),
                    //     ),
                    //   );
                    // },);


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

                          title: Text(
                            'description'.tr,
                            style: const TextStyle(
                              fontSize: 22,
                              fontFamily: ConstFont.poppinsMedium,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow
                                .ellipsis,
                          ),
                          content: Text(
                            userProductController.description,
                            style: const TextStyle(
                              fontFamily: ConstFont.poppinsRegular,
                              fontSize: 16,
                              color: Colors.black,
                            ),

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
                                 Padding(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: deviceWidth * 0.04,vertical: deviceHeight * 0.005),
                                  child: Text('close'.tr,
                                    style:
                                    const TextStyle(
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
                  child: Padding(
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
                            maxLines: 2,
                            style:  const TextStyle(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
