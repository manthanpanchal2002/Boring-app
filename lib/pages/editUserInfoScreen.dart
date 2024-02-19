import 'package:boring_app/utils/fontSize.dart';
import 'package:boring_app/utils/colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:boring_app/models/service.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class editUserInfoScreen extends StatefulWidget {
  const editUserInfoScreen({Key? key}) : super(key: key);

  @override
  State<editUserInfoScreen> createState() => _editUserInfoScreenState();
}

class _editUserInfoScreenState extends State<editUserInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  // Regex
  RegExp nameRegex = RegExp(r'^[a-zA-Z ]+$');
  RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  // Controllers
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool _isLoading = false;

  // Realtime Database reference
  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child("userInfo");
  }

  // Update user details
  Future<void> updateDetails() async {
    // Get user_key from Shared preference
    SharedPreferences prefs = await SharedPreferences.getInstance();
    service.user_key = prefs.getString('user_key');

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      dbRef.child(service.user_key.toString()).update({
        if (emailController.text.isNotEmpty &&
            emailRegex.hasMatch(emailController.text))
          "email": emailController.text
        else
          "email": service.user_email.toString(),
        if (firstnameController.text.isNotEmpty &&
            nameRegex.hasMatch(firstnameController.text))
          "firstname": firstnameController.text
        else
          "firstname": service.user_firstname.toString(),
        if (lastnameController.text.isNotEmpty &&
            nameRegex.hasMatch(lastnameController.text))
          "lastname": lastnameController.text
        else
          "lastname": service.user_lastname.toString(),
      }).then(
        (_) {
          setState(() {
            _isLoading = false;
          });

          // Get back
          Get.back();

          Get.snackbar(
            "Success",
            "Details updated successfully",
            backgroundColor: appColors.black,
            colorText: appColors.white,
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: 0,
          );
        },
      );
    } else if ((firstnameController.text.isNotEmpty &&
            nameRegex.hasMatch(firstnameController.text)) ||
        (lastnameController.text.isNotEmpty &&
            nameRegex.hasMatch(lastnameController.text)) ||
        (emailController.text.isNotEmpty &&
            emailRegex.hasMatch(emailController.text))) {
      setState(() {
        _isLoading = true;
      });

      dbRef.child(service.user_key.toString()).update(
        {
          if (emailController.text.isNotEmpty &&
              emailRegex.hasMatch(emailController.text))
            "email": emailController.text
          else
            "email": service.user_email.toString(),
          if (firstnameController.text.isNotEmpty &&
              nameRegex.hasMatch(firstnameController.text))
            "firstname": firstnameController.text
          else
            "firstname": service.user_firstname.toString(),
          if (lastnameController.text.isNotEmpty &&
              nameRegex.hasMatch(lastnameController.text))
            "lastname": lastnameController.text
          else
            "lastname": service.user_lastname.toString(),
        },
      ).then(
        (_) {
          setState(() {
            _isLoading = false;
          });

          // Get back
          Get.back();

          Get.snackbar(
            "Success",
            "Details updated successfully",
            backgroundColor: appColors.black,
            colorText: appColors.white,
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: 0,
          );
        },
      );
    } else if (!nameRegex.hasMatch(firstnameController.text) ||
        !nameRegex.hasMatch(lastnameController.text) ||
        !emailRegex.hasMatch(emailController.text)) {
      Get.snackbar(
        "Error",
        "Invalid details",
        backgroundColor: appColors.pantone_red,
        colorText: appColors.white,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 0,
      );
    } else {
      Get.snackbar(
        "Error",
        "Please fill atleast one field",
        backgroundColor: appColors.pantone_red,
        colorText: appColors.white,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 0,
      );
    }
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
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(FlutterRemix.arrow_left_s_line),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Personal info",
                            style: GoogleFonts.poppins(
                              fontSize: FontSize.subtitle_fs,
                              fontWeight: FontWeight.w600,
                              color: appColors.pantone_red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "First name",
                              style: GoogleFonts.poppins(
                                fontSize: FontSize.body_fs,
                                // fontWeight: FontWeight.w600,
                                color: appColors.silver,
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: firstnameController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              hintText: service.user_firstname.toString(),
                              hintStyle: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: FontSize.body_fs,
                                  color: appColors.silver,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                                borderSide: BorderSide(
                                  color: appColors.silver,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                                borderSide: BorderSide(
                                  color: appColors.silver,
                                ),
                              ),
                              border: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                                borderSide: BorderSide(
                                  color: appColors.silver,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (!nameRegex.hasMatch(value!)) {
                                return 'Invalid firstname';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Last name",
                                  style: GoogleFonts.poppins(
                                    fontSize: FontSize.body_fs,
                                    // fontWeight: FontWeight.bold,
                                    color: appColors.silver,
                                  ),
                                ),
                              ),
                              TextFormField(
                                controller: lastnameController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(0),
                                  hintText: service.user_lastname.toString(),
                                  hintStyle: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                    fontSize: FontSize.body_fs,
                                    color: appColors.silver,
                                  )),
                                  enabledBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    borderSide: BorderSide(
                                      color: appColors.silver,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    borderSide: BorderSide(
                                      color: appColors.silver,
                                    ),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    borderSide: BorderSide(
                                      color: appColors.silver,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (!nameRegex.hasMatch(value!)) {
                                    return 'Invalid lastname';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Email",
                                  style: GoogleFonts.poppins(
                                    fontSize: FontSize.body_fs,
                                    // fontWeight: FontWeight.bold,
                                    color: appColors.silver,
                                  ),
                                ),
                              ),
                              TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(0),
                                  hintText: service.user_email.toString(),
                                  hintStyle: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                    fontSize: FontSize.body_fs,
                                    color: appColors.silver,
                                  )),
                                  enabledBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    borderSide: BorderSide(
                                      color: appColors.silver,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    borderSide: BorderSide(
                                      color: appColors.silver,
                                    ),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                    borderSide: BorderSide(
                                      color: appColors.silver,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (!emailRegex.hasMatch(value!)) {
                                    return 'Invalid email';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                updateDetails();
                              },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: appColors.black,
                          padding: EdgeInsets.symmetric(
                              horizontal: 135, vertical: 17),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        child: Text(
                          "Save",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: FontSize.body_fs,
                              color: appColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
