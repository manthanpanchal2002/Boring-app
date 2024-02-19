import 'package:boring_app/pages/favSongScreen.dart';
import 'package:boring_app/pages/homeScreen.dart';
import 'package:boring_app/pages/searchScreen.dart';
import 'package:boring_app/pages/settingsScreen.dart';
import 'package:boring_app/utils/fontSize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:boring_app/utils/colors.dart';

class bottomNavBar extends StatefulWidget {
  const bottomNavBar({Key? key}) : super(key: key);

  @override
  State<bottomNavBar> createState() => _bottomNavBarState();
}

class _bottomNavBarState extends State<bottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    homeScreen(),
    searchScreen(),
    favSongScreen(),
    settingsScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Scaffold(
        backgroundColor: Colors.white,
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 25,
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          elevation: 1,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: appColors.silver,
          selectedFontSize: FontSize.sub_body_fs,
          unselectedFontSize: FontSize.sub_body_fs,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: _selectedIndex == 0
                  ? Icon(
                      FlutterRemix.home_fill,
                      color: appColors.black,
                    )
                  : Icon(
                      FlutterRemix.home_line,
                      color: appColors.silver,
                    ),
              label: 'Home',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: _selectedIndex == 1
                  ? Icon(
                      FlutterRemix.search_2_fill,
                      color: appColors.black,
                    )
                  : Icon(
                      FlutterRemix.search_2_line,
                      color: appColors.silver,
                    ),
              label: 'Search',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: _selectedIndex == 2
                  ? Icon(
                      FlutterRemix.heart_fill,
                      color: appColors.black,
                    )
                  : Icon(
                      FlutterRemix.heart_line,
                      color: appColors.silver,
                    ),
              label: 'Favourites',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: _selectedIndex == 3
                  ? Icon(
                      FlutterRemix.settings_5_fill,
                      color: appColors.black,
                    )
                  : Icon(
                      FlutterRemix.settings_5_line,
                      color: appColors.silver,
                    ),
              label: 'Settings',
              backgroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
