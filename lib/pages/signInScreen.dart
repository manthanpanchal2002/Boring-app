import 'dart:async';

import 'package:boring_app/utils/colors.dart';
import 'package:boring_app/utils/fontSize.dart';
import 'package:boring_app/models/userData_model.dart';
import 'package:boring_app/pages/bottomNavBar.dart';
import 'package:boring_app/pages/signUpScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'getContactScreen.dart';

class signInScreen extends StatefulWidget {
  @override
  State<signInScreen> createState() => _signInScreenState();
}

class _signInScreenState extends State<signInScreen> {
  DatabaseReference dfRef = FirebaseDatabase.instance.ref();
  List<db_data_userData> db_data_userData_list = [];

  final _formKey = GlobalKey<FormState>();
  // Regex
  RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  RegExp passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');

  // Controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  String? uid;

  // Sign-in function
  Future signIn() async {
    setState(
      () {
        _isLoading = true;
      },
    );

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim());
      // Retrieve user UID
      uid = userCredential.user!.uid;

      // Get user data from database
      retrieveUserData(userCredential.user!.email!);

      // Navigate to bottomNavBar
      Get.off(
        () => bottomNavBar(),
        transition: Transition.rightToLeft,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No user is found for that email."),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid Password"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User not found with this credientials."),
          ),
        );
      }
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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Happy to see you again ",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: FontSize.title_fs,
                              fontWeight: FontWeight.bold,
                              color: appColors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Verify your credentials",
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
                            return 'Please enter your email';
                          } else if (!emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email';
                          }

                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(14),
                          labelText: "Password",
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
                          if (value!.isEmpty) {
                            return "Password is required.";
                          } else if (value.length < 8) {
                            return "Password is too short.";
                          } else if (!passwordRegex.hasMatch(value)) {
                            return "Password must have minimun one lowercase,\nUPPERCASE, Special character and numeric value.";
                          }

                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () {
                            Get.to(() => getContactScreen(),
                                transition: Transition.downToUp);
                          },
                          child: Text(
                            "Forgot password?",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: FontSize.body_fs,
                                color: appColors.silver,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              BeveledRectangleBorder(),
                            ),
                            minimumSize: MaterialStateProperty.all<Size>(
                              Size.fromHeight(
                                  50), // Adjust the height as needed
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              appColors.pantone_red,
                            ),
                          ),
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    // Sign-in user
                                    await signIn();
                                  }
                                },
                          child: Text(
                            "SignIn",
                            style: GoogleFonts.poppins(
                              fontSize: FontSize.body_fs,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Want to create an account?",
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
                                () => signUpScreen(),
                                transition: Transition.downToUp,
                              );
                            },
                            child: Text(
                              "SignUp",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: FontSize.body_fs,
                                  color: appColors.pantone_red,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
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
            // Store to shared prefernce
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('email', user['email']);
            prefs.setString('firstname', user['firstname']);
            prefs.setString('lastname', user['lastname']);
            prefs.setString('user_key', uid!);
          }
        } else {
          print('User data not found');
        }
      },
      onError: (error) {
        print('Error retrieving user data: $error');
      },
    );
  }
}
