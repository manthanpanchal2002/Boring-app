import 'package:boring_app/pages/bottomNavBar.dart';
import 'package:boring_app/pages/welcomeScreen.dart';
import 'package:boring_app/utils/colors.dart';
import 'package:boring_app/utils/fontSize.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class noInternetScreen extends StatefulWidget {
  const noInternetScreen({Key? key}) : super(key: key);

  @override
  State<noInternetScreen> createState() => _noInternetScreenState();
}

class _noInternetScreenState extends State<noInternetScreen> {
  bool isLoading = false;
  String? user_key;
  Future<void> _checkInternetAndNavigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_key = prefs.getString('user_key');
    final result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      if (user_key != null) {
        Get.off(() => bottomNavBar(),
            transition: Transition.rightToLeft,
            duration: Duration(milliseconds: 500));
      } else {
        Get.off(() => welcomeScreen(),
            transition: Transition.rightToLeft,
            duration: Duration(milliseconds: 500));
      }
    }
  }

  Future<void> refreshPage() async {
    setState(() {
      isLoading = true;
    });

    await _checkInternetAndNavigate();

    await Future.delayed(Duration(seconds: 5));

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                  width: double.infinity,
                  child: isLoading
                      ? LinearProgressIndicator(
                          minHeight: 3,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              appColors.pantone_red),
                        )
                      : null),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset("assets/images/Notify.png",
                        height: 250, width: 250),
                    Text(
                      "Connection lost, but not your journey. Reconnect and keep exploring.",
                      style: GoogleFonts.poppins(
                        fontSize: FontSize.body_fs,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    TextButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          BeveledRectangleBorder(),
                        ),
                        minimumSize: MaterialStateProperty.all<Size>(
                          Size.fromHeight(50), // Adjust the height as needed
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          appColors.pantone_red,
                        ),
                      ),
                      onPressed: () {
                        refreshPage();
                      },
                      child: Text(
                        "Retry",
                        style: GoogleFonts.poppins(
                          fontSize: FontSize.body_fs,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
