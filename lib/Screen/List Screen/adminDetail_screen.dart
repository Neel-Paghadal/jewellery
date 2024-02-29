import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/ConstFile/constFonts.dart';
import 'package:jewellery_user/Controller/adminProfile_controller.dart';

import '../../ConstFile/constColors.dart';

class AdminDetailScreen extends StatefulWidget {
  const AdminDetailScreen({super.key});

  @override
  State<AdminDetailScreen> createState() => _AdminDetailScreenState();
}

class _AdminDetailScreenState extends State<AdminDetailScreen> {
  AdminProfileController adminProfileController =
      Get.put(AdminProfileController());

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ConstColour.bgColor,
      appBar: AppBar(
        backgroundColor: ConstColour.bgColor,
        centerTitle: true,
        title: const Text("Admin Detail",
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
      body: FutureBuilder(
        future: adminProfileController.getAdminProfileCall(
            adminProfileController.adminId), // Fetch user data asynchronously
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              controller: ScrollController(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: adminProfileController.adminProfileList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                            boxShadow: [
                              // BoxShadow(
                              //   color: Colors.white.withOpacity(0.4),
                              //   // spreadRadius: 2,
                              //   // blurRadius: 2,
                              //   offset: const Offset(0, 2),
                              // ),
                              BoxShadow(
                                color: Colors.white,
                                blurRadius: 8.0,
                                offset: Offset(0.5, 1.0),
                              ),
                            ],
                          ),
                          child: (adminProfileController.adminProfileList[index].profileImage.isNotEmpty
                              // && adminProfileController.adminProfileList[index].profileImage == null
                          )
                              ? CircleAvatar(
                              radius: deviceWidth * 0.16,
                                  onBackgroundImageError: (exception, stackTrace) {
                                      Icon(Icons.image);
                                  },
                                  backgroundImage: NetworkImage(
                                      adminProfileController
                                          .adminProfileList[index].profileImage
                                          .toString()))
                              : CircleAvatar(
                                  radius: deviceWidth * 0.16,
                                  backgroundImage:
                                      AssetImage("asset/images/mans.png"),
                                ),
                        ),
                      ),
                      Text(
                          "${adminProfileController.adminProfileList[index].firstName} ${adminProfileController.adminProfileList[index].lastName}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: ConstFont.poppinsMedium)),
                      Text(
                          adminProfileController
                              .adminProfileList[index].mobileNumber,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: ConstFont.poppinsMedium)),
                      ListTile(
                          dense: true,
                          splashColor: ConstColour.btnHowerColor,
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: ConstColour.primaryColor),
                              borderRadius: BorderRadius.circular(21)),
                          title: const Text("Address : ",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: ConstFont.poppinsMedium,
                                  color: Colors.white)),
                          subtitle: Text(
                              adminProfileController
                                  .adminProfileList[index].address,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: ConstFont.poppinsRegular))),
                      SizedBox(height: deviceHeight * 0.01),
                      adminProfileController
                                  .adminProfileList[index].referenceName ==
                              ""
                          ? SizedBox()
                          : ListTile(
                              dense: true,
                              splashColor: ConstColour.btnHowerColor,
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: ConstColour.primaryColor),
                                  borderRadius: BorderRadius.circular(21)),
                              title: const Text("Reference Name : ",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: ConstFont.poppinsMedium,
                                      color: Colors.white)),
                              subtitle: Text(
                                  adminProfileController
                                      .adminProfileList[index].referenceName,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: ConstFont.poppinsRegular))),
                      // ExpandablePanel(
                      //   builder: (context, collapsed, expanded) {
                      //     return Container(
                      //       height: 100,
                      //       width: 200,
                      //       color: Colors.white,
                      //     );
                      //   },
                      //   header: Text("Bank : ${userProfileController.userDetailList[index].userBankDetail.name}",style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: ConstFont.poppinsMedium)),
                      //   collapsed: Text("article""body", softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
                      //   expanded: Text("article""body", softWrap: true, ),
                      //   // tapHeaderToExpand: true,
                      //   // hasIcon: true,
                      // ),
                      adminProfileController
                                  .adminProfileList[index].userBankDetail ==
                              null
                          ? SizedBox()
                          : Padding(
                              padding:
                                  EdgeInsets.only(top: deviceHeight * 0.01),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(21),
                                  color: ConstColour.primaryColor,
                                ),
                                child: ExpandablePanel(
                                  theme: ExpandableThemeData(
                                    // alignment: Alignment.center,
                                    hasIcon: true,
                                    iconSize: 24,
                                    fadeCurve: Curves.slowMiddle,
                                    iconPadding: EdgeInsets.only(
                                        top: deviceHeight * 0.02,
                                        right: deviceWidth * 0.02),
                                  ),
                                  header: Padding(
                                    padding: EdgeInsets.only(
                                        top: deviceHeight * 0.025,
                                        left: deviceWidth * 0.04),
                                    child: const Text(
                                      "More Information",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: ConstFont.poppinsMedium,
                                          fontSize: 16),
                                      softWrap: true,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  collapsed: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      " Bank  Detail",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: ConstFont.poppinsRegular,
                                          color: Colors.black),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  expanded: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              "Bank : ",
                                              softWrap: true,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontFamily:
                                                      ConstFont.poppinsMedium),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              adminProfileController
                                                  .adminProfileList[index]
                                                  .userBankDetail
                                                  .name,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontFamily:
                                                      ConstFont.poppinsRegular),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "Account No : ",
                                              softWrap: true,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontFamily:
                                                      ConstFont.poppinsMedium),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              adminProfileController
                                                  .adminProfileList[index]
                                                  .userBankDetail
                                                  .accountNumber,
                                              softWrap: true,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontFamily:
                                                      ConstFont.poppinsRegular),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "IFSC : ",
                                              softWrap: true,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontFamily:
                                                      ConstFont.poppinsMedium),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              adminProfileController
                                                  .adminProfileList[index]
                                                  .userBankDetail
                                                  .ifsc,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontFamily:
                                                      ConstFont.poppinsRegular),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "Branch name : ",
                                              softWrap: true,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontFamily:
                                                      ConstFont.poppinsMedium),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              adminProfileController
                                                  .adminProfileList[index]
                                                  .userBankDetail
                                                  .brachName,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontFamily:
                                                      ConstFont.poppinsRegular),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "Account Holder Name : ",
                                              softWrap: true,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontFamily:
                                                      ConstFont.poppinsMedium),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              adminProfileController
                                                  .adminProfileList[index]
                                                  .userBankDetail
                                                  .accountHolderName,
                                              softWrap: true,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontFamily:
                                                      ConstFont.poppinsRegular),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        // Image.network(userProfileController.userDetailList[index].userDocuments[0].document)
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CachedNetworkImage(
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            imageUrl: adminProfileController
                                                .adminProfileList[index]
                                                .userDocuments[0]
                                                .document
                                                .toString(),
                                            fadeInCurve: Curves.easeInOutQuad,
                                            placeholder: (context, url) =>
                                                const Icon(Icons.image,
                                                    size: 65,
                                                    color: ConstColour
                                                        .loadImageColor),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.error, size: 45),
                                                Text(
                                                  "Image",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: ConstFont
                                                          .poppinsMedium,
                                                      color: Colors.black),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
