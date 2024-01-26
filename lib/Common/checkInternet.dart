import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


const kOfflineDebounceDuration = Duration(seconds: 3);

class InternetStatus extends StatefulWidget {
  final Widget? child;

  const InternetStatus({Key? key, this.child}) : super(key: key);
  @override
  _InternetStatusState createState() => _InternetStatusState();
}

class _InternetStatusState extends State<InternetStatus> {
  var connectionStatus = 'Unknown';
  Connectivity? connectivity;
  StreamSubscription<ConnectivityResult>? subscription;
  ConnectivityResult? connectivityResult;
  @override
  void initState() {
    super.initState();
    connectivity = Connectivity();
    initConnectivity();
    subscription =
        connectivity!.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    ConnectivityResult? result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await connectivity!.checkConnectivity();
      debugPrint(result.toString());
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result!);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        connectivityResult = result;
        if (mounted) setState(() {});
        break;
      case ConnectivityResult.mobile:
        connectivityResult = result;
        if (mounted) setState(() {});
        break;
      case ConnectivityResult.none:
        connectivityResult = result;
        if (mounted) setState(() {});
        break;
      default:
        if (mounted) {
          setState(() => connectionStatus = 'Failed to get connectivity.');
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return widget.child!;
    } else {
      return Scaffold(
        body: Container(
          height: Get.height, //Get.height = MediaQuery.of(context).size.height
          width: Get.width, //Get.width = MediaQuery.of(context).size.width
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Here I am using an svg icon
              Image.asset(
               "asset/images/no-connection.webp",
                width: 200,
                height: 200,
                color: Colors.red[200],
              ),
              const SizedBox(height: 30),
              const Text(
                'Internet connection lost!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const Text(
                'Check your connection and try again.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              )
            ],
          ),
        ),
      );
    }
  }
}