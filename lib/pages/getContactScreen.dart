import 'package:boring_app/models/userData_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:boring_app/utils/colors.dart';
import 'package:boring_app/utils/fontSize.dart';

class getContactScreen extends StatefulWidget {
  @override
  State<getContactScreen> createState() => _getContactScreenState();
}

class _getContactScreenState extends State<getContactScreen> {
  DatabaseReference dfRef = FirebaseDatabase.instance.ref();
  List<db_data_userData> db_data_userData_list = [];

  final _formKey = GlobalKey<FormState>();

  // Regex
  RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  // Controllers
  TextEditingController emailController = TextEditingController();

  bool _isLoading = false;

  // Reset Password function
  Future resetPassword() async {
    setState(
      () {
        _isLoading = true;
      },
    );
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: emailController.text.trim(),
    );

    // Get user data from database
    retrieveUserData(emailController.text.trim());
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
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(
                              FlutterRemix.arrow_left_s_line,
                              size: 28,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Lost password!",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: FontSize.title_fs,
                                  fontWeight: FontWeight.bold,
                                  color: appColors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Let us know email which is associated with your account",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: FontSize.subtitle_fs,
                              color: appColors.silver,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(14),
                          labelText: "Email",
                          labelStyle: GoogleFonts.poppins(
                              textStyle: TextStyle(
                            fontSize: FontSize.body_fs,
                            color: appColors.silver,
                          )),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: appColors.silver,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: appColors.silver,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: appColors.silver,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          } else if (!emailRegex.hasMatch(value)) {
                            return 'Invalid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    // Send email
                                    try {
                                      await resetPassword();
                                    } on FirebaseAuthException {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Something went wrong.')),
                                      );
                                    } catch (e) {
                                      print(e);
                                    } finally {
                                      setState(
                                        () {
                                          _isLoading =
                                              false; // Set isLoading to false when signing in completes
                                        },
                                      );
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: appColors.pantone_red,
                            padding: EdgeInsets.symmetric(
                                horizontal: 135, vertical: 17),
                            textStyle: TextStyle(
                              fontSize: FontSize.body_fs,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                          child: Text(
                            "Submit",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void retrieveUserData(String email) {
    dfRef.child('userInfo').orderByChild('email').equalTo(email).onValue.listen(
      (event) async {
        if (event.snapshot.value != null) {
          Map<dynamic, dynamic> userData =
              event.snapshot.value as Map<dynamic, dynamic>;

          var userKey = userData.keys.first;
          var user = userData[userKey];

          if (user.containsKey('firstname')) {
            // Show dialog box for new password link
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  icon: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  surfaceTintColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  title: Text(
                    "Verified successfully!",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: FontSize.subtitle_fs,
                        color: appColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  content: Text(
                    "Please check your email for reset password link.",
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
                        Get.back();
                      },
                      child: Text(
                        "OK",
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
            emailController.clear();
          }
        } else {
          // Show dialog box for new password link
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                icon: const Icon(
                  Icons.error,
                  color: Colors.red,
                ),
                surfaceTintColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                title: Text(
                  "Error!",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: FontSize.subtitle_fs,
                      color: appColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                content: Text(
                  "No user found with this email.",
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
                    },
                    child: Text(
                      "OK",
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
        }
      },
      onError: (error) {
        print('Error retrieving user data: $error');
      },
    );
  }
}
