import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/Common/bottom_button_widget.dart';
import 'package:jewellery_user/ConstFile/constColors.dart';
import 'package:jewellery_user/ConstFile/constFonts.dart';
import 'package:jewellery_user/Controller/login_controller.dart';
import 'package:jewellery_user/Screen/auth_screen/register.dart';
import '../../Common/snackbar.dart';
import '../../Controller/home_Controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginController loginController = Get.put(LoginController());
  HomeController homeController = Get.put(HomeController());

  String? mobileNo;
  String? password;
  final mobileRegex = RegExp(r'^[0-9]{10}$');
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   loginController.clearController();
  }




  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: ConstColour.bgColor,
        // appBar: AppBar(
        //   centerTitle: true,
        //   title: Text("Login"),
        // ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            controller: ScrollController(),
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: deviceHeight * 0.2, bottom: deviceHeight * 0.03),
                  child: const Center(
                      child: Text(
                    "Login here",
                    style: TextStyle(
                        fontFamily: ConstFont.poppinsBold,
                        fontSize: 28,
                        color: ConstColour.primaryColor),
                    overflow: TextOverflow.ellipsis,
                  )),
                ),
                const Center(
                    child: Text(
                  "Welcome back you’ve \n been missed! ",
                  style: TextStyle(
                      fontFamily: ConstFont.poppinsBold,
                      fontSize: 20,
                      color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                )),
                Padding(
                  padding: EdgeInsets.only(
                      top: deviceHeight * 0.05,
                      left: deviceWidth * 0.03,
                      right: deviceWidth * 0.03),
                  child: TextFormField(
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.number,
                    autocorrect: true,

                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10)
                    ],
                    controller: loginController.phoneController,
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
                      errorStyle: const TextStyle(color: ConstColour.errorHint),
                      border: InputBorder.none,
                      filled: true,
                      hintText: "Mobile No",
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
                      top: deviceHeight * 0.03,
                      left: deviceWidth * 0.03,
                      right: deviceWidth * 0.03,
                      bottom: deviceHeight * 0.02),
                  child: TextFormField(
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.multiline,
                    autocorrect: true,
                    controller: loginController.passController,
                    obscureText: loginController.isHidden.value,

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
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
                            color: ConstColour.textFieldBorder),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: ConstColour.textFieldBorder),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ConstColour.textFieldBorder),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      errorStyle: const TextStyle(color: ConstColour.errorHint),
                      suffixIcon: IconButton(
                        icon: Icon(
                          loginController.isHidden.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        color: ConstColour.primaryColor,
                        onPressed: () {
                          setState(() {
                            loginController.isHidden.value =! loginController.isHidden.value;
                          });
                        },
                      ),
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
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: ConstFont.poppinsRegular),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     TextButton(
                //         onPressed: () {},
                //         child: const Text(
                //           "Forgot your password? ",
                //           style: TextStyle(
                //               fontFamily: ConstFont.poppinsRegular,
                //               fontWeight: FontWeight.w800,
                //               fontSize: 14,
                //               color: ConstColour.primaryColor),
                //           overflow: TextOverflow.ellipsis,
                //         )),
                //   ],
                // ),
                Padding(
                  padding: EdgeInsets.only(top: deviceHeight * 0.08),
                  child: NextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        mobileNo = loginController.phoneController.text;
                        password = loginController.passController.text;
                        // Get.to(() => GodownPage());
                        if (loginController.phoneController.text.isEmpty &&
                            loginController.passController.text.isEmpty) {
                          setState(() {
                            Utils().toastMessage(
                                "Enter valid Username & password");
                          });
                        } else {
                          debugPrint(mobileNo);
                          debugPrint(password);
                          homeController.loading.value = true;
                          loginController.login(mobileNo!, password!);
                        }
                      }
                    },
                    btnName: "Login",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: deviceHeight * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?",
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: ConstFont.poppinsRegular,
                              color: Colors.white)),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ));
                          },
                          child: const Text("Sign up",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: ConstFont.poppinsRegular,
                                  color: ConstColour.primaryColor)))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
