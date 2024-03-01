import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jewellery_user/Common/bottom_button_widget.dart';
import 'package:jewellery_user/Common/snackbar.dart';
import 'package:jewellery_user/ConstFile/constApi.dart';
import 'package:jewellery_user/ConstFile/constColors.dart';
import 'package:jewellery_user/Controller/home_Controller.dart';
import 'package:jewellery_user/Controller/order_controller.dart';
import 'package:jewellery_user/Screen/Admin%20Screen/orderScreen_widget.dart';
import 'package:jewellery_user/Screen/videoplayer_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import '../../ConstFile/constFonts.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _startDate;
  // List<CameraDescription> cameras;

  OrderController orderController = Get.put(OrderController());
  HomeController homeController = Get.put(HomeController());

  final _formKey = GlobalKey<FormState>();
  // File? imageNotes;
  String? userProfileImage;

  var startdate = DateTime.now()
      .add(Duration(
          hours: -TimeOfDay.now().hour, minutes: -TimeOfDay.now().minute))
      .millisecondsSinceEpoch
      .obs;
  // DateTime startDate = DateTime.now();
  //

  Future<bool> _checkCameraPermission() async {
    PermissionStatus status = await Permission.camera.status;
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      return await Permission.camera.request().isGranted;
    } else {
      return false;
    }
  }

  Future<void> _checkPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future getImageCamera() async {
    try {
      _checkPermission();
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        orderController.imageNotes = imageTemporary;
        orderController.isLoading.value = true;
        orderController.uploadFile(orderController.imageNotes!);
        debugPrint(orderController.imageNotes.toString());
      });
    } catch (error) {
      print("error: $error");
    }
  }

  Future getImageGallery() async {
    _checkPermission();

    final image = await ImagePicker().pickMedia(imageQuality: 100);
    if (image == null) return;

    final imageTemporary = File(image.path);
    setState(() {
      orderController.imageNotes = imageTemporary;
      orderController.isLoading.value = true;
      orderController.uploadFile(orderController.imageNotes!);

      debugPrint(orderController.imageNotes.toString());
    });
  }

  Future<void> _pickImages() async {
    List<XFile>? pickedImages = await ImagePicker().pickMultipleMedia(
        imageQuality: 100,
        maxWidth: 800,
        requestFullMetadata: GetPlatform.isAndroid);

    setState(() {
      _imageList.addAll(pickedImages.map((image) => File(image.path)));
      orderController.isLoadingSec.value = true;
      orderController.uploadFileMulti(_imageList);
    });
  }

  List<File> _imageList = [];

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return false;
      },
      child: Scaffold(
        backgroundColor: ConstColour.bgColor,
        appBar: AppBar(
          backgroundColor: ConstColour.bgColor,
          centerTitle: true,
          title: const Text("Form",
              style: TextStyle(
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
        bottomNavigationBar: Obx(
          () => Padding(
            padding: const EdgeInsets.all(8.0),
            child: (orderController.isLoading.value == true ||
                    orderController.isLoadingSec.value == true)
                ? const SizedBox()
                : NextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (orderController.imgList.isEmpty &&
                            orderController.imgListMulti.isEmpty) {
                          Utils().snackBar("Image", "Please select the images");
                        } else {
                          String date =
                              DateFormat('yyyy-MM-dd').format(_startDate!);

                          debugPrint(date);

                          homeController.loading.value = true;
                          orderController.orderCall(
                            orderController.designT.text,
                            orderController.partyT.text,
                            double.parse(
                                orderController.caratT.text.toString()),
                            double.parse(
                                orderController.weightT.text.toString()),
                            date,
                            orderController.descripT.text,
                          );
                        }
                      }
                    },
                    btnName: "Submit"),
          ),
        ),
        body: SingleChildScrollView(
          controller: ScrollController(),
          scrollDirection: Axis.vertical,
          child: Form(
            key: _formKey,
            child: Obx(
              () => Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: deviceHeight * 0.01,
                        left: deviceWidth * 0.03,
                        right: deviceWidth * 0.03),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.text,
                      autocorrect: true,
                      controller: orderController.designT,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return "Please Enter Design Name";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        labelStyle: const TextStyle(color: Colors.grey),
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
                        border: InputBorder.none,
                        filled: true,
                        labelText: "Design Name",
                        hintText: "Enter your design name",
                        floatingLabelStyle:
                            const TextStyle(color: Colors.white),
                        hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontFamily: ConstFont.poppinsRegular,
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis),
                        errorStyle:
                            const TextStyle(color: ConstColour.errorHint),
                      ),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: ConstFont.poppinsRegular),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: deviceHeight * 0.01,
                        left: deviceWidth * 0.03,
                        right: deviceWidth * 0.03),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.text,
                      autocorrect: true,
                      controller: orderController.partyT,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return "Please Enter Party name";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        labelStyle: const TextStyle(color: Colors.grey),
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
                        border: InputBorder.none,
                        filled: true,
                        labelText: "Party Name",
                        hintText: "Enter your party name",
                        floatingLabelStyle:
                            const TextStyle(color: Colors.white),
                        hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontFamily: ConstFont.poppinsRegular,
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis),
                        errorStyle:
                            const TextStyle(color: ConstColour.errorHint),
                      ),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: ConstFont.poppinsRegular),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: deviceHeight * 0.01,
                        left: deviceWidth * 0.03,
                        right: deviceWidth * 0.03),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            textAlign: TextAlign.start,
                            autocorrect: true,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d*')),
                            ],
                            controller: orderController.caratT,
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "Please Enter Carat";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              labelStyle: const TextStyle(color: Colors.grey),
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
                                borderSide:
                                    BorderSide(color: ConstColour.primaryColor),
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
                              labelText: "Carat",
                              hintText: "Enter Carat",
                              floatingLabelStyle:
                                  const TextStyle(color: Colors.white),
                              hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontFamily: ConstFont.poppinsRegular,
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis),
                              errorStyle:
                                  const TextStyle(color: ConstColour.errorHint),
                            ),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: ConstFont.poppinsRegular),
                          ),
                        ),
                        SizedBox(width: deviceWidth * 0.02),
                        Expanded(
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            textAlign: TextAlign.start,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            autocorrect: true,
                            controller: orderController.weightT,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d*')),
                            ],
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "Please Enter Weight";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              labelStyle: const TextStyle(color: Colors.grey),
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
                                borderSide:
                                    BorderSide(color: ConstColour.primaryColor),
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
                              labelText: "Weight",
                              hintText: "Enter Weight",
                              floatingLabelStyle:
                                  const TextStyle(color: Colors.white),
                              hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontFamily: ConstFont.poppinsRegular,
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis),
                              errorStyle:
                                  const TextStyle(color: ConstColour.errorHint),
                            ),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: ConstFont.poppinsRegular),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: deviceHeight * 0.01,
                        left: deviceWidth * 0.03,
                        right: deviceWidth * 0.03),
                    child: TextFormField(
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: Get.context!,
                          initialEntryMode:
                              DatePickerEntryMode.calendarOnly, // <- this
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
                          setState(() {
                            _startDate = pickedDate;
                          });
                        }

                        debugPrint(
                            DateFormat('dd-MM-yyyy').format(_startDate!));
                        orderController.dateCon.text = DateFormat('dd-MM-yyyy')
                            .format(_startDate!)
                            .toString();
                      },
                      textAlign: TextAlign.start,
                      enableInteractiveSelection: false,
                      keyboardType: TextInputType.none,
                      controller: orderController.dateCon,
                      autocorrect: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      showCursor: false,
                      decoration: InputDecoration(
                          isDense: true,
                          labelStyle: const TextStyle(color: Colors.grey),
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
                            borderSide:
                                BorderSide(color: ConstColour.primaryColor),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: ConstColour.textFieldBorder),
                          ),
                          errorStyle:
                              const TextStyle(color: ConstColour.errorHint),
                          border: InputBorder.none,
                          filled: true,
                          enabled: true,
                          labelText: "Delivery Date",
                          hintText: _startDate == null
                              ? "Select Date"
                              : DateFormat('dd-MM-yyyy')
                                  .format(_startDate)
                                  .toString(),
                          hintStyle: const TextStyle(color: Colors.white),
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
                    padding: EdgeInsets.only(
                        top: deviceHeight * 0.01,
                        left: deviceWidth * 0.03,
                        right: deviceWidth * 0.03),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.text,
                      autocorrect: true,
                      controller: orderController.descripT,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return "Please Enter Description";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        labelStyle: const TextStyle(color: Colors.grey),
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
                        errorStyle:
                            const TextStyle(color: ConstColour.errorHint),
                        border: InputBorder.none,
                        filled: true,
                        labelText: "Description",
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        alignLabelWithHint: true,
                        hintText: "Enter your description",
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
                    padding: EdgeInsets.only(
                        left: deviceWidth * 0.03,
                        right: deviceWidth * 0.03,
                        top: deviceHeight * 0.01),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: orderController.imgList.isNotEmpty
                                  ? ConstColour.primaryColor
                                  : Colors.white,
                              strokeAlign: BorderSide.strokeAlignInside,
                              style: BorderStyle.solid)),
                      child: Stack(
                        children: [
                          SizedBox(
                            width: deviceWidth * 1.0,
                            height: deviceHeight * 0.18,
                            child: Center(
                              child: orderController.isLoading == true
                                  ? const CircularProgressIndicator(
                                      color: ConstColour.primaryColor,
                                    )
                                  : Stack(
                                      children: [
                                        Container(
                                          child: orderController
                                                  .imgList.isNotEmpty
                                              ? InkWell(
                                                  onTap: () {
                                                    if (orderController
                                                        .imgList[0].path
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
                                                                  milliseconds:
                                                                      500),
                                                          child: VideoPlayerDialog(
                                                              url: ConstApi
                                                                      .baseFilePath +
                                                                  orderController
                                                                      .imgList[
                                                                          0]
                                                                      .path),
                                                        ),
                                                      );
                                                    } else {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Container(
                                                            color: Colors.black,
                                                            child: PhotoView(
                                                              tightMode: true,
                                                              filterQuality:
                                                                  FilterQuality
                                                                      .high,
                                                              backgroundDecoration:
                                                                  const BoxDecoration(
                                                                color: Colors
                                                                    .black,
                                                              ),
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
                                                                      value: loadingProgress.expectedTotalBytes !=
                                                                              null
                                                                          ? loadingProgress.cumulativeBytesLoaded /
                                                                              (loadingProgress.expectedTotalBytes ?? 1)
                                                                          : null,
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                              imageProvider: NetworkImage(ConstApi
                                                                      .baseFilePath +
                                                                  orderController
                                                                      .imgList[
                                                                          0]
                                                                      .path
                                                                      .toString()),
                                                              heroAttributes:
                                                                  const PhotoViewHeroAttributes(
                                                                      tag:
                                                                          "someTag"),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }
                                                  },
                                                  child: orderController
                                                          .imgList[0].path
                                                          .endsWith('.mp4')
                                                      ? VideoItem(
                                                          url: ConstApi
                                                                  .baseFilePath +
                                                              orderController
                                                                  .imgList[0]
                                                                  .path)
                                                      : ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(16),
                                                          child:
                                                              CachedNetworkImage(
                                                            width:
                                                                double.infinity,
                                                            fit: BoxFit.contain,
                                                            progressIndicatorBuilder:
                                                                (context, url,
                                                                        downloadProgress) =>
                                                                    Center(
                                                              child: CircularProgressIndicator(
                                                                  value: downloadProgress
                                                                      .progress,
                                                                  color: ConstColour
                                                                      .primaryColor),
                                                            ),
                                                            imageUrl: ConstApi.baseFilePath + orderController.imgList[0].path.toString(),
                                                            fadeInCurve: Curves
                                                                .easeInOutQuad,
                                                            // placeholder: (context,
                                                            //         url) =>
                                                            //     const Icon(
                                                            //         Icons.image,
                                                            //         size: 45,
                                                            //         color: ConstColour
                                                            //             .loadImageColor),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                const Icon(
                                                                    Icons.error,
                                                                    size: 45),
                                                          ),
                                                        ),
                                                )
                                              : InkWell(
                                                  onTap: () {
                                                    showDialog<void>(
                                                      context: context,
                                                      builder: (BuildContext
                                                          dialogContext) {
                                                        return AlertDialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          11)),
                                                          title: const Center(
                                                              child: Text(
                                                                  "Choose Image Source",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          18,
                                                                      fontFamily:
                                                                          ConstFont
                                                                              .poppinsBold),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis)),
                                                          backgroundColor:
                                                              ConstColour
                                                                  .primaryColor,
                                                          titlePadding:
                                                              EdgeInsets.only(
                                                                  top:
                                                                      deviceHeight *
                                                                          0.02),
                                                          actionsPadding:
                                                              EdgeInsets.zero,
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              const Divider(
                                                                  color: Colors
                                                                      .black),
                                                              ListTile(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            11),
                                                                    side: const BorderSide(
                                                                        color: ConstColour
                                                                            .primaryColor)),
                                                                tileColor:
                                                                    ConstColour
                                                                        .bgColor,
                                                                title: const Text(
                                                                    "Camera",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontFamily:
                                                                          ConstFont
                                                                              .poppinsMedium,
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis),
                                                                onTap: () {
                                                                  Get.back();
                                                                  getImageCamera();
                                                                },
                                                                leading:
                                                                    const Icon(
                                                                  Icons
                                                                      .camera_alt,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height:
                                                                      deviceHeight *
                                                                          0.01),
                                                              ListTile(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            11),
                                                                    side: const BorderSide(
                                                                        color: ConstColour
                                                                            .primaryColor)),
                                                                tileColor:
                                                                    ConstColour
                                                                        .bgColor,
                                                                title: const Text(
                                                                    "Gallery",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontFamily:
                                                                          ConstFont
                                                                              .poppinsMedium,
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis),
                                                                onTap: () {
                                                                  Get.back();
                                                                  getImageGallery();
                                                                },
                                                                leading:
                                                                    const Icon(
                                                                  Icons
                                                                      .photo_library_rounded,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: (userProfileImage ==
                                                              null ||
                                                          userProfileImage!
                                                              .isEmpty)
                                                      ? Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Image.asset(
                                                                'asset/icons/image.png',
                                                                width:
                                                                    deviceWidth *
                                                                        0.2),
                                                            const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                "Upload Main Image",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontFamily:
                                                                      ConstFont
                                                                          .poppinsMedium,
                                                                  fontSize: 14,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      : CircleAvatar(
                                                          radius: 55,
                                                          backgroundImage:
                                                              NetworkImage(
                                                                  userProfileImage!),
                                                        ),
                                                ),
                                        ),
                                        // Positioned(
                                        //     left: deviceWidth * 0.16,
                                        //     // bottom: deviceHeight * 0.08,
                                        //     top: deviceHeight * 0.08,
                                        //     child: imageNotes != null
                                        //         ? IconButton(
                                        //         onPressed: () {
                                        //           setState(() {
                                        //             imageNotes = null;
                                        //           });
                                        //         },
                                        //         icon: const Icon(
                                        //           CupertinoIcons.minus_circle_fill,
                                        //           color: Colors.red,
                                        //           size: 24,
                                        //         ))
                                        //         : const SizedBox())
                                      ],
                                    ),
                            ),
                          ),
                          Container(
                            child: orderController.imgList.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      mainImageCancelDialog(context);
                                    },
                                    icon: const Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.red,
                                      size: 24,
                                    ))
                                : const SizedBox(),
                          )
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: deviceWidth * 0.04, top: deviceHeight * 0.01),
                        child: const Text(
                          "Upload Sub Images :",
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: ConstFont.poppinsMedium,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: deviceWidth * 0.03, right: deviceWidth * 0.03),
                    child: SizedBox(
                      height: deviceHeight * 0.1,
                      child: Row(
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: ConstColour.primaryColor,
                                        strokeAlign:
                                            BorderSide.strokeAlignInside,
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
                          orderController.isLoadingSec.value == true
                              ? Padding(
                                  padding:
                                      EdgeInsets.only(left: deviceWidth * 0.3),
                                  child: const CircularProgressIndicator(
                                    color: ConstColour.primaryColor,
                                  ),
                                )
                              : Expanded(
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    controller: ScrollController(),
                                    shrinkWrap: true,
                                    itemCount:
                                        orderController.imgListMulti.length,
                                    itemBuilder: (context, index) {
                                      final item = ConstApi.baseFilePath +
                                          orderController
                                              .imgListMulti[index].path;
                                      return Stack(
                                        alignment: Alignment.topLeft,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (item.endsWith('.mp4')) {
                                                showDialog(
                                                  context: context,
                                                  builder: (_) => Dialog(
                                                    backgroundColor:
                                                        Colors.white,
                                                    insetPadding:
                                                        EdgeInsets.zero,
                                                    insetAnimationDuration:
                                                        Duration(
                                                            milliseconds: 500),
                                                    child: VideoPlayerDialog(
                                                        url: item),
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
                                                            BoxDecoration(
                                                          color: Colors.black,
                                                        ),
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
                                                        imageProvider:
                                                            NetworkImage(
                                                          item,
                                                        ),
                                                        heroAttributes:
                                                            const PhotoViewHeroAttributes(
                                                                tag: "someTag"),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: deviceHeight * 0.014,
                                                  left: deviceWidth * 0.02,
                                                  right: deviceWidth * 0.02),
                                              child: Container(
                                                width: deviceWidth * 0.15,
                                                height: deviceHeight * 0.075,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    border: Border.all(
                                                        color: ConstColour
                                                            .offWhiteColor,
                                                        strokeAlign: BorderSide
                                                            .strokeAlignInside,
                                                        style:
                                                            BorderStyle.solid)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: item.endsWith('.mp4')
                                                      ? VideoItem(url: item)
                                                      : ImageItem(url: item),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: deviceWidth * 0.1,
                                            bottom: deviceHeight * 0.055,
                                            child: Container(
                                              child:
                                                  orderController.imgListMulti
                                                          .isNotEmpty
                                                      ? IconButton(
                                                          onPressed: () {
                                                            showCupertinoModalPopup(
                                                              filter: const ColorFilter
                                                                  .mode(
                                                                  ConstColour
                                                                      .primaryColor,
                                                                  BlendMode
                                                                      .clear),
                                                              semanticsDismissible:
                                                                  false,
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),

                                                                  shadowColor:
                                                                      Colors
                                                                          .white,
                                                                  elevation:
                                                                      8.0,
                                                                  // backgroundColor: Colors.white,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .orange
                                                                          .shade100,
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
                                                                  content:
                                                                      const Text(
                                                                    'Are you sure, want to delete?',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          ConstFont
                                                                              .poppinsRegular,
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    maxLines: 2,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                  actions: [
                                                                    InkWell(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      onTap:
                                                                          () {
                                                                        Get.back();
                                                                      },
                                                                      splashColor:
                                                                          ConstColour
                                                                              .btnHowerColor,
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            // gradient: const LinearGradient(colors: [Colors.white,Colors.black26]),
                                                                            borderRadius: BorderRadius.circular(5),
                                                                            color: Colors.red),
                                                                        child:
                                                                            const Padding(
                                                                          padding:
                                                                              EdgeInsets.all(6.0),
                                                                          child:
                                                                              Text(
                                                                            'Cancel',
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: ConstFont.poppinsRegular,
                                                                              fontSize: 12,
                                                                              color: Colors.white,
                                                                            ),
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          _imageList
                                                                              .removeAt(index);
                                                                          orderController
                                                                              .imgListMulti
                                                                              .removeAt(index);
                                                                          // orderController.uploadFileMulti(_imageList);
                                                                        });
                                                                        Get.back();
                                                                      },
                                                                      splashColor:
                                                                          ConstColour
                                                                              .btnHowerColor,
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            // gradient: const LinearGradient(colors: [Colors.white,Colors.black26]),
                                                                            borderRadius: BorderRadius.circular(5),
                                                                            color: Colors.black),
                                                                        child:
                                                                            const Padding(
                                                                          padding:
                                                                              EdgeInsets.all(6.0),
                                                                          child:
                                                                              Text(
                                                                            '    Ok    ',
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: ConstFont.poppinsRegular,
                                                                              fontSize: 12,
                                                                              color: Colors.white,
                                                                            ),
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          },
                                                          icon: Container(
                                                            decoration:
                                                                const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .black),
                                                            child: const Icon(
                                                              Icons
                                                                  .cancel_outlined,
                                                              color: Colors.red,
                                                              size: 20,
                                                            ),
                                                          ))
                                                      : const SizedBox(),
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// Future<void> initializeCamera() async {
//   cameras = await availableCameras();
//   final camera = cameras.first;
//   controller = CameraController(
//     camera,
//     ResolutionPreset.medium,
//   );
//   await controller.initialize();
// }
}
