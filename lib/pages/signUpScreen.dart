import 'package:boring_app/utils/colors.dart';
import 'package:boring_app/utils/fontSize.dart';
import 'package:boring_app/pages/bottomNavBar.dart';
import 'package:boring_app/pages/termsOfUseScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class signUpScreen extends StatefulWidget {
  @override
  State<signUpScreen> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen> {
  // Checkbox state
  bool _isChecked = false;

  final _formKey = GlobalKey<FormState>();
  // Regex
  RegExp nameRegex = RegExp(r'^[a-zA-Z ]+$');
  RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  RegExp passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');

  // Controllers
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  String? uid;

  // Sign-up function
  Future signUp() async {
    setState(
      () {
        _isLoading = true;
      },
    );
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim());
    // Retrieve user UID
    uid = userCredential.user!.uid;
  }

  // Realtime Database reference
  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child("userInfo");
  }

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hey there! we won't let you bore",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                          fontSize: FontSize.title_fs,
                          fontWeight: FontWeight.bold,
                          color: appColors.black,
                        )),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Let us know about yourself",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                            fontSize: FontSize.subtitle_fs,
                            color: appColors.silver,
                          )),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: firstnameController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(14),
                          labelText: "First name",
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
                            return 'Firstname is required';
                          } else if (!nameRegex.hasMatch(value)) {
                            return 'Invalid firstname';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: lastnameController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(14),
                          labelText: "Last name",
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
                            return 'Last name is required';
                          } else if (!nameRegex.hasMatch(value)) {
                            return 'Invalid lastname';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15,
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
                      Row(
                        children: [
                          Checkbox(
                            checkColor: Colors.white,
                            fillColor: MaterialStateProperty.all<Color>(
                                appColors.pantone_red),
                            side: BorderSide(color: appColors.pantone_red),
                            value: _isChecked,
                            onChanged: (value) {
                              setState(
                                () {
                                  _isChecked = value!;
                                },
                              );
                            },
                            visualDensity: VisualDensity(
                              horizontal: -4,
                            ),
                          ),
                          Text(
                            "I agree to the ",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              fontSize: FontSize.body_fs,
                              color: appColors.silver,
                            )),
                          ),
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
                                color: appColors.pantone_red,
                              )),
                            ),
                          ),
                        ],
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
                                    if (!_isChecked) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please agree to the terms')),
                                      );
                                      return; // Prevents signup if checkbox isn't checked
                                    }

                                    // Sign-up user
                                    try {
                                      await signUp();

                                      if (this.mounted) {
                                        setState(
                                          () {
                                            _isLoading = false;
                                          },
                                        );
                                        // Add user info to realtime database
                                        Map<String, dynamic> dbUserInfo = {
                                          "firstname": firstnameController.text,
                                          "lastname": lastnameController.text,
                                          "email": emailController.text,
                                        };
                                        await dbRef.child(uid!).set(dbUserInfo);

                                        // Store to shared prefernce
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        prefs.setString(
                                            'email', emailController.text);
                                        prefs.setString('firstname',
                                            firstnameController.text);
                                        prefs.setString('lastname',
                                            lastnameController.text);
                                        prefs.setString('user_key',
                                            uid!); // Store user key to shared preference

                                        // Navigate to bottomNavBar
                                        Get.off(
                                          () => bottomNavBar(),
                                          transition: Transition.rightToLeft,
                                        );

                                        // clear text fields
                                        firstnameController.clear();
                                        lastnameController.clear();
                                        emailController.clear();
                                        passwordController.clear();
                                      }
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'email-already-in-use') {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'The account already exists for that email.')),
                                        );
                                      }
                                    } catch (e) {
                                      print(e);
                                    } finally {
                                      if (this.mounted) {
                                        setState(
                                          () {
                                            _isLoading =
                                                false; // Set isLoading to false when signing in completes
                                          },
                                        );
                                      }
                                    }
                                  }
                                },
                          child: Text(
                            "SignUp",
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
                            "Already have an account?",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              fontSize: FontSize.body_fs,
                              color: appColors.silver,
                            )),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Text(
                              "SignIn",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                fontSize: FontSize.body_fs,
                                color: appColors.pantone_red,
                              )),
                            ),
                          ),
                        ],
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
}
