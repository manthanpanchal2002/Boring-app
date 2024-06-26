import 'package:boring_app/pages/bottomNavBar.dart';
import 'package:boring_app/pages/noInternetScreen.dart';
import 'package:boring_app/pages/welcomeScreen.dart';
import 'package:boring_app/utils/colors.dart';
import 'package:boring_app/utils/fontSize.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class splashScreen extends StatefulWidget {
  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  var isLogin = false;
  String? user_key;

  Future<void> getUserKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_key = prefs.getString('user_key');
  }

  checkIsLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_key = prefs.getString('user_key');

    if (user_key != null) {
      setState(() {
        isLogin = true;
      });
    } else {
      setState(() {
        isLogin = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    startAnimation();
    checkIsLogin();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Image.asset(
                        "assets/images/Boring_icon.jpg",
                        height: 150,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            bottomNavigationBar: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "#WeAre",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: appColors.black,
                      fontSize: FontSize.body_fs,
                    ),
                  ),
                  Text(
                    "Boring",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: appColors.pantone_red,
                      fontWeight: FontWeight.w600,
                      fontSize: FontSize.body_fs,
                    ),
                  ),
                ],
              ),
            )),
      );
  }

  Future<void> startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 3000));

    // Check internet connection
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // Navigate to no internet screen
      Get.off(() => noInternetScreen(),
          transition: Transition.rightToLeft,
          duration: Duration(milliseconds: 500));
    } else {
      isLogin
          ?
          // Navigate to Home screen
          Get.off(
              () => bottomNavBar(),
              transition: Transition.rightToLeft,
              duration: Duration(milliseconds: 500),
            )
          :
          // Navigate to welcome screen
          Get.off(
              () => welcomeScreen(),
              transition: Transition.rightToLeft,
              duration: Duration(milliseconds: 500),
            );
    }
  }
}
