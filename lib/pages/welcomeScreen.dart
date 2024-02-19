import 'package:boring_app/models/userData_model.dart';
import 'package:boring_app/pages/bottomNavBar.dart';
import 'package:boring_app/pages/signInScreen.dart';
import 'package:boring_app/utils/colors.dart';
import 'package:boring_app/utils/fontSize.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class welcomeScreen extends StatefulWidget {
  const welcomeScreen({Key? key}) : super(key: key);

  @override
  State<welcomeScreen> createState() => _welcomeScreenState();
}

class _welcomeScreenState extends State<welcomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  List<db_data_userData> db_data_userData_list = [];
  String? userFirstName;
  String? userLastName;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {});
    });
  }

  // Google signIn method
  signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      // Wait for display name to be available
      await user!.reload();
      userEmail = user.email;

      String? displayName;
      for (UserInfo userInfo in user.providerData) {
        if (userInfo.displayName != null) {
          displayName = userInfo.displayName;
          break;
        }
      }
      if (displayName != null) {
        // Split the displayName into first name and last name
        List<String> nameParts = displayName.split(' '); // Split by space
        userFirstName = nameParts[0]; // First name
        userLastName =
            nameParts.length > 1 ? nameParts[1] : ''; // Last name, if available

        // Retrieve user data from database
        retrieveUserData(user.email!);

        // Save user data to shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user_key', user.uid);
        prefs.setString('firstname', userFirstName!);
        prefs.setString('lastname', userLastName!);
        prefs.setString('email', user.email ?? '');
        prefs.setString('photoUrl', user.photoURL ?? '');

        // Navigate to the next screen
        Get.off(
          () => bottomNavBar(),
          transition: Transition.rightToLeft,
          duration: Duration(milliseconds: 500),
        );
      } else {
        print('No displayName found');
      }

      // Update UI or navigate to the next screen
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/peace.png',
                  fit: BoxFit.cover,
                  height: 360,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome to',
                      style: GoogleFonts.poppins(
                        fontSize: FontSize.title_fs,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Text(
                      'Boring',
                      style: GoogleFonts.poppins(
                        fontSize: FontSize.title_fs,
                        color: appColors.pantone_red,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Immerse yourself in melodies that speak to your soul, with every beat a new journey awaits.\n#WeAreBoring',
                  style: GoogleFonts.poppins(
                    fontSize: FontSize.body_fs,
                    fontWeight: FontWeight.w500,
                    color: appColors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 40.0, left: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: TextButton(
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
                  Get.off(
                    () => signInScreen(),
                    transition: Transition.rightToLeft,
                    duration: Duration(milliseconds: 500),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FlutterRemix.mail_fill,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "continue with Email/Password",
                      style: GoogleFonts.poppins(
                        fontSize: FontSize.body_fs,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
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
                      color: appColors.silver.withOpacity(0.5),
                      width: 0.5,
                    ),
                  ),
                ),
                onPressed: () {
                  signInWithGoogle();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FlutterRemix.google_fill,
                      color: appColors.black,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "continue with Google",
                      style: GoogleFonts.poppins(
                        fontSize: FontSize.body_fs,
                        fontWeight: FontWeight.w600,
                        color: appColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void retrieveUserData(String email) {
    dbRef.child('userInfo').orderByChild('email').equalTo(email).onValue.listen(
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
          }
        } else {
          // Add user info to realtime database
          dbRef.child('userInfo').push().set({
            'email': userEmail,
            'firstname': userFirstName,
            'lastname': userLastName,
          });
        }
      },
      onError: (error) {
        print('Error retrieving user data: $error');
      },
    );
  }
}
