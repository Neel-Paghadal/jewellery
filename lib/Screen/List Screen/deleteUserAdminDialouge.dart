



 import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/ConstFile/constColors.dart';
import 'package:jewellery_user/ConstFile/constFonts.dart';
import 'package:jewellery_user/Controller/User_Controller/adminList_controller.dart';
import 'package:jewellery_user/Controller/userlistScreen_controller.dart';
 UserListScreenController userListScreenController = Get.put(UserListScreenController());
  AdminListController adminListController = Get.put(AdminListController());
void  deleteUserDialoge(context,String userId){
   showDialog(
     context: context,
     builder: (BuildContext context) {

       return AlertDialog(
         shape:
         RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
         shadowColor: Colors.white,
         elevation: 8.0,
         // backgroundColor: Colors.white,
         backgroundColor: Colors.orange.shade100,
         title: const Text(
           'Delete Account',
           style: TextStyle(
             fontSize: 22,
             fontFamily: ConstFont.poppinsMedium,
             color: Colors.black,
           ),
           overflow: TextOverflow.ellipsis,
         ),
         content: const Text(
           'Are you sure, want to delete user account?',
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

             },
             splashColor: ConstColour.btnHowerColor,
             child: TextButton(
               onPressed: () {
                 userListScreenController.deleteUserCall(userId);
                 Get.back();
               },
               child: const Padding(
                 padding: EdgeInsets.all(2.0),
                 child: Text(
                   '  Yes  ',
                   style: TextStyle(
                     fontFamily: ConstFont.poppinsMedium,
                     fontSize: 14,
                     color: Colors.black,
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
void  deleteAdminDialoge(context,String userId){
   showDialog(
     context: context,
     builder: (BuildContext context) {

       return AlertDialog(
         shape:
         RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
         shadowColor: Colors.white,
         elevation: 8.0,
         // backgroundColor: Colors.white,
         backgroundColor: Colors.orange.shade100,
         title: const Text(
           'Delete Account',
           style: TextStyle(
             fontSize: 22,
             fontFamily: ConstFont.poppinsMedium,
             color: Colors.black,
           ),
           overflow: TextOverflow.ellipsis,
         ),
         content: const Text(
           'Are you sure, want to delete admin account?',
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

             },
             splashColor: ConstColour.btnHowerColor,
             child: TextButton(
               onPressed: () {
                 adminListController.deleteAdminCall(userId);
                 Get.back();
               },
               child: const Padding(
                 padding: EdgeInsets.all(2.0),
                 child: Text(
                   '  Yes  ',
                   style: TextStyle(
                     fontFamily: ConstFont.poppinsMedium,
                     fontSize: 14,
                     color: Colors.black,
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