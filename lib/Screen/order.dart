import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jewellery_user/Common/bottom_button_widget.dart';
import 'package:jewellery_user/Common/snackbar.dart';
import 'package:jewellery_user/ConstFile/constColors.dart';
import 'package:jewellery_user/Controller/home_Controller.dart';
import 'package:jewellery_user/Controller/order_controller.dart';
import 'package:photo_view/photo_view.dart';
import '../ConstFile/constFonts.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  OrderController orderController = Get.put(OrderController());
  HomeController homeController = Get.put(HomeController());

  final _formKey = GlobalKey<FormState>();
  File? imageNotes;
  String? userProfileImage;

  var startdate = DateTime.now()
      .add(Duration(
          hours: -TimeOfDay.now().hour, minutes: -TimeOfDay.now().minute))
      .millisecondsSinceEpoch
      .obs;
  DateTime _startDate = DateTime.now();
  DateTime startDate = DateTime.now();

  Future getImageCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;

    final imageTemporary = File(image.path);
    setState(() {
      imageNotes = imageTemporary;
      orderController.uploadFile(imageNotes!);
      debugPrint(imageNotes.toString());
    });
  }

  Future getImageGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final imageTemporary = File(image.path);
    setState(() {
      imageNotes = imageTemporary;
        orderController.uploadFile(imageNotes!);

      debugPrint(imageNotes.toString());
    });
  }

  Future<void> _pickImages() async {
    List<XFile>? pickedImages = await ImagePicker().pickMultiImage(
      imageQuality: 50,
      maxWidth: 800,
    );

    setState(() {
      _imageList.addAll(pickedImages.map((image) => File(image.path)));
      orderController.uploadFileMulti(_imageList);
    });
  }

  List<File> _imageList = [];

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios),
            color: ConstColour.primaryColor),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: NextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
            if(orderController.imgList.isEmpty && orderController.imgListMulti.isEmpty){
              Utils().snackBar("Image", "Please select the images");
            }else{
              homeController.loading.value = true;
              orderController.orderCall(
                orderController.designT.text,
                orderController.partyT.text,
                double.parse(orderController.caratT.text.toString()),
                double.parse(orderController.weightT.text.toString()),
                DateFormat('yyyy-MM-dd').format(_startDate),
                orderController.descripT.text,
              );
            }

              }
            },
            btnName: "Add Design"),
      ),
      body: SingleChildScrollView(
        controller: ScrollController(),
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: Column(
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
                    if (value!.isEmpty) {
                      return "Please Enter Design";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ConstColour.textFieldBorder),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ConstColour.textFieldBorder),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ConstColour.primaryColor),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: ConstColour.primaryColor),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ConstColour.textFieldBorder),
                    ),
                    border: InputBorder.none,
                    filled: true,
                    labelText: "Design name",
                    hintText: "Enter your design name",
                    floatingLabelStyle: const TextStyle(color: Colors.white),
                    hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontFamily: ConstFont.poppinsRegular,
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis),
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
                    if (value!.isEmpty) {
                      return "Please Enter Partyname";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ConstColour.textFieldBorder),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ConstColour.textFieldBorder),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ConstColour.primaryColor),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: ConstColour.primaryColor),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ConstColour.textFieldBorder),
                    ),
                    border: InputBorder.none,
                    filled: true,
                    labelText: "Party name",
                    hintText: "Enter your party name",
                    floatingLabelStyle: const TextStyle(color: Colors.white),
                    hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontFamily: ConstFont.poppinsRegular,
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis),
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.number,
                        autocorrect: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                              RegExp(r'\s')),
                        ],
                        controller: orderController.caratT,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter Carat";
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.number,
                        autocorrect: true,
                        controller: orderController.weightT,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                              RegExp(r'\s')),
                        ],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter Weight";
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
                    left: deviceWidth * 0.02,
                    right: deviceWidth * 0.02,
                    top: deviceHeight * 0.005),
                child: InkWell(
                  splashColor: ConstColour.btnHowerColor,
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: Get.context!,
                      initialDate: _startDate,
                      firstDate: DateTime(2000),
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
                    debugPrint(
                        DateFormat('yyyy-MM-dd').format(_startDate));
                    debugPrint("millisecond$startDate");
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.white)),
                    color: ConstColour.bgColor,
                    child: Row(
                      // mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("Select Delivery Date :",
                            style: TextStyle(
                                fontFamily: ConstFont.poppinsRegular,
                                fontSize: 16,
                                color: Colors.white)),
                        IconButton(
                            splashColor: ConstColour.btnHowerColor,
                           onPressed: () {

                           },
                            icon: const Icon(
                              Icons.calendar_month_rounded,
                              color: Colors.white,
                            )),
                        Text(
                            DateFormat('dd-MM-yyyy').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    startdate.value)),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: ConstFont.poppinsRegular,
                            ),
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
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
                  controller:  orderController.descripT,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Enter FirsName";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ConstColour.textFieldBorder),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ConstColour.textFieldBorder),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ConstColour.primaryColor),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: ConstColour.primaryColor),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ConstColour.textFieldBorder),
                    ),
                    border: InputBorder.none,
                    filled: true,
                    labelText: "Description",
                    hintText: "Enter your description",
                    floatingLabelStyle: const TextStyle(color: Colors.white),
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
                          color: ConstColour.primaryColor,
                          strokeAlign: BorderSide.strokeAlignInside,
                          style: BorderStyle.solid)),
                  child: Stack(
                    children: [
                      SizedBox(
                        width: deviceWidth * 1.0,
                        height: deviceHeight * 0.18,
                        child: Center(
                          child: Stack(
                            children: [
                              Container(
                                child: imageNotes != null
                                    ? Image.file(
                                        fit: BoxFit.cover,
                                        imageNotes!,
                                        // width: deviceWidth * 0.275,
                                        // height: deviceHeight * 0.13,
                                      )
                                    : InkWell(
                                        onTap: () {
                                          showDialog<void>(
                                            context: context,
                                            builder:
                                                (BuildContext dialogContext) {
                                              return AlertDialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    ListTile(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(11),
                                                          side: const BorderSide(
                                                              color: ConstColour
                                                                  .primaryColor)),
                                                      tileColor:
                                                          ConstColour.bgColor,
                                                      title: const Text(
                                                          "Camera",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily: ConstFont
                                                                .poppinsMedium,
                                                            fontSize: 14,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        getImageCamera();
                                                      },
                                                      leading: const Icon(
                                                        Icons.camera_alt,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: deviceHeight *
                                                            0.01),
                                                    ListTile(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(11),
                                                          side: const BorderSide(
                                                              color: ConstColour
                                                                  .primaryColor)),
                                                      tileColor:
                                                          ConstColour.bgColor,
                                                      title: const Text(
                                                          "Gallery",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily: ConstFont
                                                                .poppinsMedium,
                                                            fontSize: 14,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        getImageGallery();
                                                      },
                                                      leading: const Icon(
                                                        Icons
                                                            .photo_library_rounded,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: (userProfileImage == null ||
                                                userProfileImage!.isEmpty)
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Image.asset(
                                                      'asset/icons/image.png',
                                                      width: deviceWidth * 0.2),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text(
                                                      "Upload identity document",
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontFamily: ConstFont
                                                            .poppinsMedium,
                                                        fontSize: 14,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  )
                                                ],
                                              )
                                            : CircleAvatar(
                                                radius: 55,
                                                backgroundImage: NetworkImage(
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
                        child: imageNotes != null
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    imageNotes = null;
                                  });
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
              Padding(
                padding: EdgeInsets.only(
                    left: deviceWidth * 0.03, right: deviceWidth * 0.03),
                child: SizedBox(
                  height: deviceHeight * 0.09,
                  child: Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: ConstColour.primaryColor,
                                    strokeAlign: BorderSide.strokeAlignInside,
                                    style: BorderStyle.solid)),
                            child: InkWell(
                                onTap: () {
                                  showDialog<void>(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        backgroundColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(11),
                                          // side: BorderSide(color: ConstColour.primaryColor)
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            //  ListTile(
                                            //    tileColor: ConstColour.bgColor,
                                            //    shape: RoundedRectangleBorder(
                                            //        borderRadius: BorderRadius.circular(11),
                                            //        side: BorderSide(color: ConstColour.primaryColor)
                                            //    ),
                                            // title: const Text("Camera", style: TextStyle(color: Colors.white,fontFamily: ConstFont.poppinsMedium,fontSize: 14,)
                                            //   ,overflow: TextOverflow.ellipsis),
                                            //    onTap: () {
                                            //      Navigator.pop(context);
                                            //       getImageCamera();
                                            //    },
                                            //    leading: const Icon(
                                            //      Icons.camera_alt,
                                            //      color: Colors.white,
                                            //    ),
                                            //  ),
                                            SizedBox(
                                                height: deviceHeight * 0.01),
                                            ListTile(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(11),
                                                  side: const BorderSide(
                                                      color: ConstColour
                                                          .primaryColor)),
                                              tileColor: ConstColour.bgColor,
                                              title: const Text("Gallery",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily:
                                                        ConstFont.poppinsMedium,
                                                    fontSize: 14,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              onTap: () {
                                                Navigator.pop(context);
                                                _pickImages();
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
                                },
                                child: const Icon(
                                  Icons.add,
                                  size: 60,
                                  color: Colors.grey,
                                )),
                          )),
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          controller: ScrollController(),
                          shrinkWrap: true,
                          itemCount: _imageList.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              alignment: Alignment.topLeft,
                              children: [
                                InkWell(
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
                                                  FileImage(_imageList[index]),
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
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: deviceWidth * 0.15,
                                      height: deviceHeight * 0.09,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: ConstColour.primaryColor,
                                              strokeAlign:
                                                  BorderSide.strokeAlignInside,
                                              style: BorderStyle.solid)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          _imageList[index],
                                          fit: BoxFit.cover,
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                            // Custom error widget to display when image fails to load

                                            return const Icon(
                                              Icons.image,
                                              size: 30,
                                              color: Colors.grey,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: deviceWidth * 0.1,
                                  bottom: deviceHeight * 0.05,
                                  child: Container(
                                    child: _imageList[index] != null
                                        ? IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _imageList.removeAt(index);
                                                orderController.uploadFileMulti(_imageList);
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.cancel_outlined,
                                              color: Colors.white,
                                              size: 20,

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
    );
  }
}
