// import 'package:boring_app/dependency/networkDep.dart';
import 'package:boring_app/pages/artistDetailScreen.dart';
import 'package:boring_app/pages/artistExploreScreen.dart';
import 'package:boring_app/pages/bottomNavBar.dart';
import 'package:boring_app/pages/categoryExploreScreen.dart';
import 'package:boring_app/pages/editUserInfoScreen.dart';
import 'package:boring_app/pages/mostListenedExploreScreen.dart';
import 'package:boring_app/pages/newReleaseExploreScreen.dart';
import 'package:boring_app/pages/noInternetScreen.dart';
import 'package:boring_app/pages/playlistExploreScreen.dart';
import 'package:boring_app/pages/favSongScreen.dart';
import 'package:boring_app/pages/getContactScreen.dart';
import 'package:boring_app/pages/helpScreen.dart';
import 'package:boring_app/pages/homeScreen.dart';
import 'package:boring_app/pages/notificationScreen.dart';
import 'package:boring_app/pages/playlistDetailsScreen.dart';
import 'package:boring_app/pages/privacyPolicyScreen.dart';
import 'package:boring_app/pages/searchScreen.dart';
import 'package:boring_app/pages/signInScreen.dart';
import 'package:boring_app/pages/signUpScreen.dart';
import 'package:boring_app/pages/songScreen.dart';
import 'package:boring_app/pages/splashScreen.dart';
import 'package:boring_app/pages/termsOfUseScreen.dart';
import 'package:boring_app/pages/welcomeScreen.dart';
import 'package:boring_app/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  // DependencyInjection.init();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // initialRoute: myRoutes.noInternetScreen,
      initialRoute: myRoutes.splashScreen,
      // initialRoute: myRoutes.signInScreen,
      // initialRoute: myRoutes.signUpScreen,
      // initialRoute: myRoutes.getContactScreen,
      // initialRoute: myRoutes.otpVerificationScreen,
      // initialRoute: myRoutes.resetPasswordScreen,
      // initialRoute: myRoutes.termsOfUseScreen,
      // initialRoute: myRoutes.bottomNavBar,
      // initialRoute: myRoutes.homeScreen,
      // initialRoute: myRoutes.notificationScreen,
      // initialRoute: myRoutes.favSongScreen,
      // initialRoute: myRoutes.searchScreen,
      // initialRoute: myRoutes.editUserInfoScreen,
      // initialRoute: myRoutes.privacyPolicyScreen,
      // initialRoute: myRoutes.helpScreen,
      // initialRoute: myRoutes.welcomeScreen,
      // initialRoute: myRoutes.playlistDetailsScreen,
      // initialRoute: myRoutes.songScreen,
      // initialRoute: myRoutes.playlistExploreScreen,
      // initialRoute: myRoutes.mostListenedExploreScreen,
      // initialRoute: myRoutes.newReleaseExploreScreen,
      // initialRoute: myRoutes.artistExploreScreen,
      // initialRoute: myRoutes.artistDetailScreen,
      // initialRoute: myRoutes.categoryExploreScreen,
      routes: {
        '/noInternetScreen': (context) => noInternetScreen(),
        '/splashScreen': (context) => splashScreen(),
        '/welcomeScreen': (context) => welcomeScreen(),
        '/signInScreen': (context) => signInScreen(),
        '/signUpScreen': (context) => signUpScreen(),
        '/getContactScreen': (context) => getContactScreen(),
        '/termsOfUseScreen': (context) => termsOfUseScreen(),
        '/bottomNavBar': (context) => bottomNavBar(),
        '/homeScreen': (context) => homeScreen(),
        '/notificationScreen': (context) => notificationScreen(),
        '/favSongScreen': (context) => favSongScreen(),
        '/searchScreen': (context) => searchScreen(),
        '/editUserInfoScreen': (context) => editUserInfoScreen(),
        '/privacyPolicyScreen': (context) => privacyPolicyScreen(),
        '/helpScreen': (context) => helpScreen(),
        '/playlistDetailsScreen': (context) => playlistDetailsScreen(),
        '/songScreen': (context) => songScreen(),
        '/playlistExploreScreen': (context) => playlistExploreScreen(),
        '/mostListenedExploreScreen': (context) => mostListenedExploreScreen(),
        '/newReleaseExploreScreen': (context) => newReleaseExploreScreen(),
        '/artistExploreScreen': (context) => artistExploreScreen(),
        '/artistDetailScreen': (context) => artistDetailScreen(),
        '/categoryExploreScreen': (context) => categoryExploreScreen(),
      },
    );
  }
}
