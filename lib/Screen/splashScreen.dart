import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/ConstFile/constColors.dart';
import 'package:jewellery_user/ConstFile/constFonts.dart';
import 'package:jewellery_user/Screen/Admin%20Screen/home.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unique_identifier/unique_identifier.dart';
import '../ConstFile/constPreferences.dart';
import '../Controller/User_Controller/user_home_con.dart';
import '../Controller/login_controller.dart';
import 'User_screen/user_home.dart';
import 'auth_screen/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  LoginController loginController = Get.put(LoginController());
  UserHomeCon userHomeCon = Get.put(UserHomeCon());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
      () {
        initUniqueIdentifierState();
        // getDeviceData();
        checkPref();
        checkLanguages();
      },
    );
  }

  var role;
  void checkLanguages() async {
    String? newValue = await ConstPreferences().getLanguages();
    if (newValue == "English") {
      userHomeCon.selectedItem = "English";
      Get.updateLocale(const Locale('en', 'US'));
    } else if (newValue == "ગુજરાતી") {
      setState(() {
        userHomeCon.selectedItem = "ગુજરાતી";
        Get.updateLocale(const Locale('gu', 'IN'));
      });
    } else if (newValue == "हिंदी") {
      setState(() {
        userHomeCon.selectedItem = "हिंदी";
        Get.updateLocale(const Locale('hi', 'IN'));
      });
    }
  }

  Future<void> mainToken() async {
    // Replace 'your_token_here' with the actual JWT token you want to decode
    String? jwtToken = await ConstPreferences().getToken();
    // String jwtToken = 'your_token_here';
    debugPrint(jwtToken);
    Map<String, dynamic>? decodedToken = Jwt.parseJwt(jwtToken!);

    if (decodedToken != null) {
      print('Decoded Token: $decodedToken');
      // Access token claims
      List newList = decodedToken.values.toList();
      debugPrint(newList.toString());
      role = newList[1];
      debugPrint('Role value: ${newList[1]}');
      ConstPreferences().setRole(role);

      if (role == 'Admin') {
        Get.to(() => const HomeScreen());
      } else if (role == 'SuperAdmin') {
        Get.to(() => const HomeScreen());
      } else {
        Get.to(() => const UserHome());
      }
    } else {
      print('Failed to decode token.');
    }
  }

  checkPref() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("login") == true) {
      mainToken();
      // Get.to(() => const HomeScreen());
    } else {
      Get.to(() => const LoginScreen());
    }
  }

  String _identifier = 'Unknown';

  Future<void> initUniqueIdentifierState() async {
    String identifier;
    try {
      identifier = (await UniqueIdentifier.serial)!;
    } on PlatformException {
      identifier = 'Failed to get Unique Identifier';
    }

    if (!mounted) return;

    setState(() {
      _identifier = identifier;
      loginController.deviceId = identifier;
    });
    debugPrint("IDENTIFIER : " + _identifier);
  }

  // void getDeviceData() async {
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //
  //   String imei = androidInfo.id; // IMEI-Nummer
  //   String serialNumber = androidInfo.serialNumber.toString(); // Seriennummer
  //
  //   print('IMEI: $imei');
  //   print('Serial Number: $serialNumber');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColour.bgColor,
      body: Center(
        child: Text('splash'.tr,
            style: const TextStyle(
                fontFamily: ConstFont.poppinsBold,
                color: ConstColour.primaryColor,
                fontSize: 40),
            overflow: TextOverflow.ellipsis),
      ),
    );
  }
}

// Text('name'.tr,
//     style: TextStyle(
//         fontFamily: ConstFont.poppinsBold,
//         color: ConstColour.primaryColor,
//         fontSize: 16),
//     overflow: TextOverflow.ellipsis),
// SizedBox(
//   height: 40,
// ),
// Text('message'.tr,
//     style: TextStyle(
//         fontFamily: ConstFont.poppinsBold,
//         color: ConstColour.primaryColor,
//         fontSize: 16),
//     overflow: TextOverflow.ellipsis),
// Text('name'.tr,
//     style: TextStyle(
//         fontFamily: ConstFont.poppinsBold,
//         color: ConstColour.primaryColor,
//         fontSize: 16),
//     overflow: TextOverflow.ellipsis),
// ElevatedButton(
//     onPressed: () {
//       setState(() {
//         Get.updateLocale(Locale('en', 'US'));
//       });
//     },
//     child: Text("English")),
// SizedBox(
//   height: 40,
// ),
// ElevatedButton(
//     onPressed: () {
//       setState(() {
//         Get.updateLocale(Locale('gu', 'IN'));
//       });
//     },
//     child: Text("ગુજરાતી")),
