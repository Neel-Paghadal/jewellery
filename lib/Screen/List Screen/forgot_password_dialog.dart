


 import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/Common/bottom_button_widget.dart';
import 'package:jewellery_user/ConstFile/constFonts.dart';
import 'package:jewellery_user/Controller/forgotPassword_controller.dart';

import '../../ConstFile/constColors.dart';

 ForgotPassController forgotPassController = Get.put(ForgotPassController());
 final _formKey = GlobalKey<FormState>();

 forgotPasswordDialouge(context,String userId){
     var deviceHeight = MediaQuery.of(context).size.height;
     var deviceWidth = MediaQuery.of(context).size.width;

  return showDialog(
      context: context,
      useSafeArea: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
              insetAnimationDuration: const Duration(seconds: 1),
              insetAnimationCurve: Curves.linear,
              shadowColor: ConstColour.primaryColor,
              backgroundColor: Colors.black45,
            child: Container(
              decoration: BoxDecoration(
                // color: ConstColour.bgColor,
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: ConstColour.primaryColor,),
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
                  mainAxisAlignment:  MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.lock,size: 80,color: ConstColour.primaryColor,),
                    ),
                    Text("Reset Password?",style: TextStyle(
                      fontSize: 18,fontFamily: ConstFont.poppinsMedium,
                    ),overflow: TextOverflow.ellipsis,),

                    Padding(
                      padding: EdgeInsets.only(
                          left: deviceWidth * 0.03, right: deviceWidth * 0.03),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.multiline,
                        autocorrect: true,
                        controller: forgotPassController.password,
                        obscureText: forgotPassController.isHidden.value,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Password";
                            // } else if (!regex.hasMatch(value)) {
                            //   return 'Enter a valid password';
                            // }
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              forgotPassController.isHidden.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            color: ConstColour.primaryColor,
                            onPressed: () {
                              setState(() {
                                forgotPassController.isHidden.value =! forgotPassController.isHidden.value;
                              });
                            },
                          ),
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
                                color: ConstColour.textFieldBorder),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                            BorderSide(color: ConstColour.textFieldBorder),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: ConstColour.textFieldBorder),
                          ),
                          errorStyle: TextStyle(color: ConstColour.errorHint),

                          border: InputBorder.none,
                          filled: true,
                          hintText: "Password",
                          hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontFamily: ConstFont.poppinsRegular,
                              fontSize: 16,
                              overflow: TextOverflow.ellipsis),
                        ),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: ConstFont.poppinsRegular),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(
                          left: deviceWidth * 0.03, right: deviceWidth * 0.03,top: deviceHeight * 0.01),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.multiline,
                        autocorrect: true,
                        obscureText: forgotPassController.isHiddenSec.value,

                        controller: forgotPassController.cPassword,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Your Confirm Password";
                          }  else if (value != forgotPassController.password.text) {
                            return 'Password doesn\'t Match';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              forgotPassController.isHiddenSec.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            color: ConstColour.primaryColor,
                            onPressed: () {
                              setState(() {

                                forgotPassController.isHiddenSec.value =! forgotPassController.isHiddenSec.value;

                              });
                            },
                          ),
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
                                color: ConstColour.textFieldBorder),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                            BorderSide(color: ConstColour.textFieldBorder),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                                color: ConstColour.textFieldBorder),
                          ),
                          errorStyle: TextStyle(color: ConstColour.errorHint),

                          border: InputBorder.none,
                          filled: true,
                          hintText: "Confirm Password",
                          hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontFamily: ConstFont.poppinsRegular,
                              fontSize: 16,
                              overflow: TextOverflow.ellipsis),
                        ),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: ConstFont.poppinsRegular),
                      ),
                    ),
                    Divider(height: deviceHeight * 0.01),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: NextButton(
                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                            forgotPassController.forgotPasswordCall(userId,forgotPassController.cPassword.text,);
                          }
                        },
                        btnName: "Reset Password",
                      ),
                    )
                  ],
                ),
              ),
            ));
        },);
      },);
 }