import 'package:boring_app/utils/fontSize.dart';
import 'package:boring_app/utils/colors.dart';
import 'package:boring_app/models/subcriptionPlan_model.dart';
import 'package:boring_app/models/service.dart';
import 'package:boring_app/pages/editUserInfoScreen.dart';
import 'package:boring_app/pages/privacyPolicyScreen.dart';
import 'package:boring_app/pages/signInScreen.dart';
import 'package:boring_app/pages/termsOfUseScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class settingsScreen extends StatefulWidget {
  const settingsScreen({Key? key}) : super(key: key);

  @override
  State<settingsScreen> createState() => _settingsScreenState();
}

class _settingsScreenState extends State<settingsScreen> {
  DatabaseReference dfRef = FirebaseDatabase.instance.ref();
  List<db_data_subscriptionPlan> db_data_subscriptionPlan_list = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  Future<void> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    service.user_firstname = prefs.getString('firstname');
    service.user_lastname = prefs.getString('lastname');
    service.user_email = prefs.getString('email');
    service.user_photoUrl = prefs.getString('photoUrl');
  }

  Future<String?> clearUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_key = prefs.getString('user_key');
    prefs.remove('firstname');
    prefs.remove('lastname');
    prefs.remove('email');
    prefs.remove('user_key');
    prefs.remove('photoUrl');
    return user_key;
  }

  // Delete user from realtime database
  Future<void> deleteUser() async {
    String? user_key = await clearUserInfo();
    if (user_key != null) {
      dfRef.child('userInfo').child(user_key).remove();
    }

    // Also delete information from Authentication if we have user
    User? user = _auth.currentUser;
    if (user != null) {
      user.delete();
    }
  }

  @override
  void initState() {
    super.initState();
    retrieve_subscriptionPlan_data();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                  width: double.infinity,
                  child: _isLoading
                      ? LinearProgressIndicator(
                          minHeight: 3,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              appColors.pantone_red),
                        )
                      : null),
              _isLoading
                  ? Text(
                      "Wait a moment..",
                      style: GoogleFonts.poppins(
                        fontSize: FontSize.sub_body_fs,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: appColors.white,
                                  ),
                                  child: service.user_photoUrl == null
                                      ? const Icon(
                                          FlutterRemix.user_line,
                                          color: appColors.black,
                                          size: 30,
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.network(
                                            service.user_photoUrl.toString(),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${service.user_firstname.toString()} ${service.user_lastname.toString()}",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: FontSize.subtitle_fs,
                                        fontWeight: FontWeight.w600,
                                        color: appColors.black,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    service.user_email.toString(),
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: FontSize.sub_body_fs,
                                        color: appColors.silver,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  Get.to(
                                    () => editUserInfoScreen(),
                                    transition: Transition.rightToLeft,
                                  );
                                },
                                child: Icon(
                                  FlutterRemix.edit_line,
                                  color: appColors.silver,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            color: appColors.silver.withOpacity(0.5),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Text(
                                  "Subscription plan",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: FontSize.subtitle_fs,
                                      fontWeight: FontWeight.w600,
                                      color: appColors.silver,
                                    ),
                                  ),
                                ),
                                Text(
                                  " (per month)",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: FontSize.sub_body_fs,
                                      color: appColors.silver,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 180,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: db_data_subscriptionPlan_list.length,
                              itemBuilder: (context, index) {
                                return priceCard(index,
                                    db_data_subscriptionPlan_list[index]);
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  width: 10,
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.to(
                                    () => termsOfUseScreen(),
                                    transition: Transition.downToUp,
                                  );
                                },
                                child: Text(
                                  "Terms of use",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: FontSize.body_fs,
                                      color: appColors.silver,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "|",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: FontSize.body_fs,
                                    color: appColors.silver,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(
                                    () => privacyPolicyScreen(),
                                    transition: Transition.downToUp,
                                  );
                                },
                                child: Text(
                                  "Privacy policy",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: FontSize.body_fs,
                                      color: appColors.silver,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 100,
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _isLoading
          ? SizedBox()
          : Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 40,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    child: TextButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          BeveledRectangleBorder(),
                        ),
                        minimumSize: MaterialStateProperty.all<Size>(
                          Size.fromHeight(50), // Adjust the height as needed
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          appColors.black,
                        ),
                      ),
                      onPressed: () {
                        Get.off(
                          () => signInScreen(),
                          transition: Transition.rightToLeft,
                          duration: Duration(milliseconds: 500),
                        );
                        clearUserInfo();
                      },
                      child: Text(
                        "Sign out",
                        style: GoogleFonts.poppins(
                          fontSize: FontSize.body_fs,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    child: TextButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          BeveledRectangleBorder(),
                        ),
                        minimumSize: MaterialStateProperty.all<Size>(
                          Size.fromHeight(50), // Adjust the height as needed
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          appColors.white,
                        ),
                        side: MaterialStateProperty.all<BorderSide>(
                          BorderSide(
                            color: appColors.black,
                            width: 0.5,
                          ),
                        ),
                      ),
                      onPressed: () {
                        // deleteUser();
                        // show dialog for choice Yes or No
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              surfaceTintColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              title: Text(
                                "Delete account",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: FontSize.subtitle_fs,
                                    color: appColors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              content: Text(
                                "Are you sure you want to delete your account?",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: FontSize.body_fs,
                                    color: appColors.silver,
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    deleteUser();
                                    Get.off(
                                      () => signInScreen(),
                                      transition: Transition.rightToLeft,
                                      duration: Duration(milliseconds: 500),
                                    );
                                    clearUserInfo();
                                  },
                                  child: Text(
                                    "Yes",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: FontSize.body_fs,
                                        color: appColors.silver,
                                      ),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "No",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: FontSize.body_fs,
                                        color: appColors.silver,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );

                        // Get.off(
                        //   () => signInScreen(),
                        //   transition: Transition.rightToLeft,
                        //   duration: Duration(milliseconds: 500),
                        // );
                        // clearUserInfo();
                      },
                      child: Text(
                        "Delete account",
                        style: GoogleFonts.poppins(
                          fontSize: FontSize.body_fs,
                          fontWeight: FontWeight.w600,
                          color: appColors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void retrieve_subscriptionPlan_data() {
    setState(() {
      _isLoading = true;
    });

    dfRef.child('subscription_plan').onChildAdded.listen(
      (data) {
        data_SubscriptionPlan data_subscriptionPlan =
            data_SubscriptionPlan.fromJson(data.snapshot.value as Map);
        db_data_subscriptionPlan_list.add(
          db_data_subscriptionPlan(
            key: data.snapshot.key,
            data_subscriptionPlan: data_subscriptionPlan,
          ),
        );
        setState(
          () {
            _isLoading = false;
          },
        );
      },
    );
  }

  // Price card
  Widget priceCard(
      int index, db_data_subscriptionPlan db_data_subscriptionPlan_list) {
    return Container(
      height: 180,
      width: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color: appColors.silver.withOpacity(0.1),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
            ),
            child: Row(
              children: [
                Text(
                  "${db_data_subscriptionPlan_list.data_subscriptionPlan!.name} | ${db_data_subscriptionPlan_list.data_subscriptionPlan!.price}",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: FontSize.body_fs,
                      color: appColors.black,
                    ),
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    print(index);
                  },
                  child: Text(
                    "Buy",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: FontSize.body_fs,
                        fontWeight: FontWeight.w600,
                        color: appColors.pantone_red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: appColors.silver.withOpacity(0.5),
            thickness: 0.5,
          ),
          Padding(
            padding: EdgeInsets.only(top: 5, left: 10, right: 10),
            child: Column(
              children: [
                for (var feature in db_data_subscriptionPlan_list
                    .data_subscriptionPlan!.features)
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            FlutterRemix.checkbox_circle_fill,
                            color: appColors.black,
                            size: 15,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            feature,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: FontSize.sub_body_fs,
                                color: appColors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
