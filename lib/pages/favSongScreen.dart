import 'package:boring_app/utils/fontSize.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class favSongScreen extends StatefulWidget {
  const favSongScreen({Key? key}) : super(key: key);

  @override
  State<favSongScreen> createState() => _favSongScreenState();
}

class _favSongScreenState extends State<favSongScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset("assets/images/Collecting.png",
                      height: 250, width: 250),
                  Text(
                    "Explore songs to collect your music taste",
                    style: GoogleFonts.poppins(
                      fontSize: FontSize.body_fs,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
