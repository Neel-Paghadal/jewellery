import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/ConstFile/constColors.dart';
import 'package:jewellery_user/ConstFile/constFonts.dart';
import 'package:jewellery_user/Controller/register_controller.dart';
import 'package:jewellery_user/Screen/auth_screen/documentScreen.dart';

import '../../Common/bottom_button_widget.dart';
import '../../Common/snackbar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  RegisterController registerController = Get.put(RegisterController());

  final mobileRegex = RegExp(r'^[0-9]{10}$');
  final _formKey = GlobalKey<FormState>();
  // RegExp regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');

  @override
  Widget build(BuildContext context) {

    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ConstColour.bgColor,
      appBar: AppBar(
        backgroundColor: ConstColour.bgColor,
        centerTitle: true,
        title: const Text("Register",style: TextStyle(
            color: Colors.white,
            fontFamily: ConstFont.poppinsRegular,
            fontSize: 22,
            fontWeight: FontWeight.w500,
            overflow: TextOverflow.ellipsis)),
      ),
      body: SingleChildScrollView(
        controller: ScrollController(),
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Divider(height: deviceHeight * 0.01),


                Padding(
                  padding: EdgeInsets.only(
                      top: deviceHeight * 0.05,
                      left: deviceWidth * 0.03,
                      right: deviceWidth * 0.03),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.text,
                    autocorrect: true,
                    controller:  registerController.firstName,
                    validator: (value) {
                      if(value!.isEmpty) {
                        return "Please Enter FirsName";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: ConstColour.textFieldBorder),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color:ConstColour.textFieldBorder),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color:ConstColour.textFieldBorder),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: ConstColour.textFieldBorder),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: ConstColour.textFieldBorder),
                      ),
                      border: InputBorder.none,
                      filled: true,
                      hintText: "Enter Firstname",
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
                Divider(height: deviceHeight * 0.01),

                Padding(
                  padding: EdgeInsets.only(
                      left: deviceWidth * 0.03,
                      right: deviceWidth * 0.03),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.text,
                    autocorrect: true,
                    controller:  registerController.lastName,
                    validator: (value) {
                      if(value!.isEmpty) {
                        return "Please Enter LastName";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: ConstColour.textFieldBorder),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color:ConstColour.textFieldBorder),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color:ConstColour.textFieldBorder),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: ConstColour.textFieldBorder),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: ConstColour.textFieldBorder),
                      ),
                      border: InputBorder.none,
                      filled: true,
                      hintText: "Enter Lastname",
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
                Divider(height: deviceHeight * 0.01),

                Padding(
                  padding: EdgeInsets.only(
                      left: deviceWidth * 0.03,
                      right: deviceWidth * 0.03),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.multiline,
                    autocorrect: true,
                    controller:  registerController.password,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Password";
                        // } else if (!regex.hasMatch(value)) {
                        //   return 'Enter a valid password';
                        // }
                      }
                      else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: ConstColour.textFieldBorder),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color:ConstColour.textFieldBorder),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color:ConstColour.textFieldBorder),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: ConstColour.textFieldBorder),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: ConstColour.textFieldBorder),
                      ),
                      border: InputBorder.none,
                      filled: true,
                      hintText: "Enter Password",
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
                Divider(height: deviceHeight * 0.01),

                Padding(
                  padding: EdgeInsets.only(
                      left: deviceWidth * 0.03,
                      right: deviceWidth * 0.03),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 10,
                    autocorrect: true,
                    controller: registerController.mobile,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Your Mobile Number";
                      } else if (!mobileRegex.hasMatch(value)) {
                        return 'Enter a valid 10-digit mobile number';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: ConstColour.textFieldBorder),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: ConstColour.textFieldBorder),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: ConstColour.textFieldBorder),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: ConstColour.textFieldBorder),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: ConstColour.textFieldBorder),
                      ),
                      border: InputBorder.none,
                      filled: true,
                      hintText: "Enter Mobile No ",
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
                Divider(height: deviceHeight * 0.01),

                Padding(
                  padding: EdgeInsets.only(
                      left: deviceWidth * 0.03,
                      right: deviceWidth * 0.03),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.multiline,
                    autocorrect: true,
                    controller:  registerController.address,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Address";
                      } else if (value.length <= 10 ) {
                        return 'Enter Full Address';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: ConstColour.textFieldBorder),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: ConstColour.textFieldBorder),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: ConstColour.textFieldBorder),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: ConstColour.textFieldBorder),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: ConstColour.textFieldBorder),
                      ),
                      border: InputBorder.none,
                      filled: true,
                      hintText: "Enter Address",
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
                Divider(height: deviceHeight * 0.01),

                Padding(
                  padding: EdgeInsets.only(
                      left: deviceWidth * 0.03,
                      right: deviceWidth * 0.03),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.multiline,
                    autocorrect: true,
                    controller:  registerController.reference,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Reference Name";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: ConstColour.textFieldBorder),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: ConstColour.textFieldBorder),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: ConstColour.textFieldBorder),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: ConstColour.textFieldBorder),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: ConstColour.textFieldBorder),
                      ),
                      border: InputBorder.none,
                      filled: true,
                      hintText: "Enter Reference Name",
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
                  padding:  EdgeInsets.only(top: deviceHeight * 0.1,left: deviceWidth * 0.03,right: deviceWidth * 0.03 ),
                  child: ListTile(
                    splashColor: ConstColour.btnHowerColor,
                    onTap: () {

                      if (_formKey.currentState!.validate()) {
                        registerController.firstNames = registerController.firstName.text;
                        registerController.lastNames = registerController.lastName.text;
                        registerController.phone= registerController.mobile.text;
                        registerController.pass = registerController.password.text;
                        registerController.ref = registerController.reference.text;
                        registerController.addr = registerController.address.text;

                        if (registerController.mobile.text.isEmpty && registerController.password.text.isEmpty) {
                          setState(() {
                            Utils().toastMessage("Enter valid Username & password");
                          });
                        } else {
                          debugPrint(registerController.firstNames);
                          debugPrint(registerController.lastNames);
                          debugPrint(registerController.phone);
                          debugPrint(registerController.pass);
                          debugPrint(registerController.ref);
                          debugPrint(registerController.addr);

                          Get.to(() => const DocumentScreen());

                          // loginController.login(mobileNo!, password!);
                        }
                      }
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    tileColor: ConstColour.primaryColor,
                    titleAlignment: ListTileTitleAlignment.center,
                    title: Padding(
                      padding:  EdgeInsets.only(left: deviceWidth * 0.1),
                      child: Text("Next",style: TextStyle(fontFamily: ConstFont.poppinsRegular,fontWeight: FontWeight.w500, fontSize: 20,color: Colors.black),overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,),
                    ),
                    trailing: Icon(Icons.arrow_forward,size: 24,),
                  ),
                ),



                // Padding(
                //   padding: EdgeInsets.only(top: deviceHeight * 0.08),
                //   child: NextButton(
                //     onPressed: () {
                //       if (_formKey.currentState!.validate()) {
                //         registerController.firstNames = registerController.firstName.text;
                //         registerController.lastNames = registerController.lastName.text;
                //         registerController.phone= registerController.mobile.text;
                //         registerController.pass = registerController.password.text;
                //         registerController.ref = registerController.reference.text;
                //         registerController.addr = registerController.address.text;
                //
                //         if (registerController.mobile.text.isEmpty && registerController.password.text.isEmpty) {
                //           setState(() {
                //             Utils().toastMessage("Enter valid Username & password");
                //           });
                //         } else {
                //           debugPrint(registerController.firstNames);
                //           debugPrint(registerController.lastNames);
                //           debugPrint(registerController.phone);
                //           debugPrint(registerController.pass);
                //           debugPrint(registerController.ref);
                //           debugPrint(registerController.addr);
                //
                //           Get.to(() => const DocumentScreen());
                //
                //           // loginController.login(mobileNo!, password!);
                //         }
                //       }
                //     },
                //     btnName: "Register",
                //   ),
                // ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
