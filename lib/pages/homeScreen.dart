import 'dart:math';

import 'package:boring_app/models/artistCover_model.dart';
import 'package:boring_app/models/category_model.dart';
import 'package:boring_app/models/mostListened_model.dart';
import 'package:boring_app/models/newRelease_model.dart';
import 'package:boring_app/models/playlistCover_model.dart';
import 'package:boring_app/pages/artistDetailScreen.dart';
import 'package:boring_app/pages/artistExploreScreen.dart';
import 'package:boring_app/pages/categoryExploreScreen.dart';
import 'package:boring_app/pages/mostListenedExploreScreen.dart';
import 'package:boring_app/pages/newReleaseExploreScreen.dart';
import 'package:boring_app/pages/playlistDetailsScreen.dart';
import 'package:boring_app/pages/playlistExploreScreen.dart';
import 'package:boring_app/pages/songScreen.dart';
import 'package:boring_app/utils/fontSize.dart';
import 'package:boring_app/pages/notificationScreen.dart';
import 'package:boring_app/models/service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:boring_app/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

// Show Greeting
String generateGreeting() {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Good morning,';
  } else if (hour < 17) {
    return 'Good afternoon,';
  } else {
    return 'Good evening,';
  }
}

class _homeScreenState extends State<homeScreen> {
  String greeting = generateGreeting();

  DatabaseReference dfRef = FirebaseDatabase.instance.ref();
  List<db_data_playlistCover> db_data_playlistCover_list = [];
  List<db_data_artistCover> db_data_artistCover_list = [];
  List<db_data_mostListened> db_data_mostListened_list = [];
  List<db_data_newRelease> db_data_newRelease_list = [];
  List<db_data_category> db_data_category_list = [];

  bool _isLoading = false;

  Future<void> getUserFirstname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    service.user_firstname = prefs.getString('firstname');
  }

  @override
  void initState() {
    super.initState();
    getUserFirstname();
    retrieve_db_data();
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  greeting.toString(),
                                  style: GoogleFonts.poppins(
                                    fontSize: FontSize.title_fs,
                                    fontWeight: FontWeight.bold,
                                    color: appColors.black,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(() => notificationScreen(),
                                      transition: Transition.rightToLeft);
                                },
                                child: Icon(
                                  FlutterRemix.notification_2_fill,
                                  size: 25,
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              service.user_firstname.toString(),
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
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Popular playlists",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: FontSize.subtitle_fs,
                                      fontWeight: FontWeight.w600,
                                      color: appColors.pantone_red,
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: InkWell(
                                  onTap: () {
                                    Get.to(
                                      () => playlistExploreScreen(),
                                      transition: Transition.rightToLeft,
                                    );
                                  },
                                  child: Text(
                                    "Explore",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: FontSize.sub_body_fs,
                                        color: appColors.pantone_red,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 150,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  min(db_data_playlistCover_list.length, 3),
                              itemBuilder: (context, index) {
                                return playlistCard(
                                    index, db_data_playlistCover_list[index]);
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
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Most listened",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: FontSize.subtitle_fs,
                                      fontWeight: FontWeight.w600,
                                      color: appColors.pantone_red,
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: InkWell(
                                  onTap: () {
                                    Get.to(
                                      () => mostListenedExploreScreen(),
                                      transition: Transition.rightToLeft,
                                    );
                                  },
                                  child: Text(
                                    "Explore",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: FontSize.sub_body_fs,
                                        color: appColors.pantone_red,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 210,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  min(db_data_mostListened_list.length, 3),
                              itemBuilder: (context, index) {
                                return mostListenedSongsCard(
                                    index, db_data_mostListened_list[index]);
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
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "New release",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: FontSize.subtitle_fs,
                                      fontWeight: FontWeight.w600,
                                      color: appColors.pantone_red,
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  Get.to(
                                    () => newReleaseExploreScreen(),
                                    transition: Transition.rightToLeft,
                                  );
                                },
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Explore",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: FontSize.sub_body_fs,
                                        color: appColors.pantone_red,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 210,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: min(db_data_newRelease_list.length, 3),
                              itemBuilder: (context, index) {
                                return newReleaseSongsCard(
                                    index, db_data_newRelease_list[index]);
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
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "What's your mood?",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: FontSize.subtitle_fs,
                                  fontWeight: FontWeight.w600,
                                  color: appColors.pantone_red,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 150,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: db_data_category_list.length,
                              itemBuilder: (context, index) {
                                return category(
                                    index, db_data_category_list[index]);
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
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Artists",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: FontSize.subtitle_fs,
                                      fontWeight: FontWeight.w600,
                                      color: appColors.pantone_red,
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: InkWell(
                                  onTap: () {
                                    Get.to(
                                      () => artistExploreScreen(),
                                      transition: Transition.rightToLeft,
                                    );
                                  },
                                  child: Text(
                                    "Explore",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: FontSize.sub_body_fs,
                                        color: appColors.pantone_red,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 150,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  min(db_data_artistCover_list.length, 3),
                              itemBuilder: (context, index) {
                                return artistCard(
                                    index, db_data_artistCover_list[index]);
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  width: 10,
                                );
                              },
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

  void retrieve_db_data() {
    setState(() {
      _isLoading = true;
    });

    // Playlist cover data
    dfRef.child('popular_playlist_cover').onChildAdded.listen(
      (data) {
        data_PlaylistCover data_playlistCover =
            data_PlaylistCover.fromJson(data.snapshot.value as Map);
        db_data_playlistCover_list.add(
          db_data_playlistCover(
            key: data.snapshot.key,
            data_playlistCover: data_playlistCover,
          ),
        );
        setState(
          () {
            _isLoading = false;
          },
        );
      },
    );

    // Artist cover data
    dfRef.child('artist_cover').onChildAdded.listen(
      (data) {
        data_ArtistCover data_artistCover =
            data_ArtistCover.fromJson(data.snapshot.value as Map);
        db_data_artistCover_list.add(
          db_data_artistCover(
            key: data.snapshot.key,
            data_artistCover: data_artistCover,
          ),
        );
        setState(
          () {
            _isLoading = false;
          },
        );
      },
    );

    // Most listened data
    dfRef.child('most_listened').onChildAdded.listen(
      (data) {
        data_MostListened data_mostListened =
            data_MostListened.fromJson(data.snapshot.value as Map);
        db_data_mostListened_list.add(
          db_data_mostListened(
            key: data.snapshot.key,
            data_mostListened: data_mostListened,
          ),
        );
        setState(
          () {
            _isLoading = false;
          },
        );
      },
    );

    // New release data
    dfRef.child('new_release').onChildAdded.listen(
      (data) {
        data_NewRelease data_newRelease =
            data_NewRelease.fromJson(data.snapshot.value as Map);
        db_data_newRelease_list.add(
          db_data_newRelease(
            key: data.snapshot.key,
            data_newRelease: data_newRelease,
          ),
        );
        setState(
          () {
            _isLoading = false;
          },
        );
      },
    );

    // Category data
    dfRef.child('category').onChildAdded.listen(
      (data) {
        data_Category data_category =
            data_Category.fromJson(data.snapshot.value as Map);
        db_data_category_list.add(
          db_data_category(
            key: data.snapshot.key,
            data_category: data_category,
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

  // Playlist card
  Widget playlistCard(int index, db_data_playlistCover db_data_playlistCover) {
    return InkWell(
      onTap: () {
        service.get_genre = db_data_playlistCover.data_playlistCover!.genre;
        print(service.get_genre);
        Get.to(
          () => playlistDetailsScreen(),
          transition: Transition.rightToLeft,
        );
        // get cover id
        service.get_playlist_cover_id =
            db_data_playlistCover.data_playlistCover!.id.toString();
      },
      child: Container(
        height: 150,
        width: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          color: appColors.silver.withOpacity(0.1),
        ),
        child: Stack(
          children: [
            SizedBox(
              height: 150,
              width: 280,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Image.network(
                  db_data_playlistCover.data_playlistCover!.imageUrl.toString(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          db_data_playlistCover.data_playlistCover!.title
                              .toString(),
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: FontSize.body_fs,
                              fontWeight: FontWeight.w600,
                              color: appColors.white,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          db_data_playlistCover.data_playlistCover!.description
                              .toString(),
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: FontSize.sub_body_fs,
                              color: appColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(
                    FlutterRemix.play_list_2_fill,
                    color: appColors.white,
                    size: 20,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Most listened songs card
  Widget mostListenedSongsCard(
      int index, db_data_mostListened db_data_mostListened) {
    return InkWell(
      onTap: () {
        service.get_song_name =
            db_data_mostListened.data_mostListened!.title.toString();
        Get.to(
          () => songScreen(),
          transition: Transition.rightToLeft,
        );
      },
      child: Container(
        height: 200,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          color: appColors.silver.withOpacity(0.1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Image.network(
                  db_data_mostListened.data_mostListened!.imageUrl.toString(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  Text(
                    db_data_mostListened.data_mostListened!.title.toString(),
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: FontSize.body_fs,
                        fontWeight: FontWeight.w600,
                        color: appColors.black,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Text(
                    db_data_mostListened.data_mostListened!.description
                        .toString(),
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: FontSize.sub_body_fs,
                        color: appColors.black,
                        overflow: TextOverflow.ellipsis,
                      ),
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

  // New release songs card
  Widget newReleaseSongsCard(int index, db_data_newRelease db_data_newRelease) {
    return InkWell(
      onTap: () {
        service.get_song_name =
            db_data_newRelease.data_newRelease!.title.toString();
        Get.to(
          () => songScreen(),
          transition: Transition.rightToLeft,
        );
      },
      child: Container(
        height: 200,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          color: appColors.silver.withOpacity(0.1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Image.network(
                  db_data_newRelease.data_newRelease!.imageUrl.toString(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  Text(
                    db_data_newRelease.data_newRelease!.title.toString(),
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: FontSize.body_fs,
                        fontWeight: FontWeight.w600,
                        color: appColors.black,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Text(
                    db_data_newRelease.data_newRelease!.description.toString(),
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: FontSize.sub_body_fs,
                        color: appColors.black,
                        overflow: TextOverflow.ellipsis,
                      ),
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

  // New release songs card
  Widget category(int index, db_data_category db_data_category) {
    return InkWell(
      onTap: () {
        service.get_genre = db_data_category.data_category!.title.toString();
        Get.to(
          () => categoryExploreScreen(),
          transition: Transition.rightToLeft,
        );
      },
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          color: appColors.silver.withOpacity(0.1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                color: appColors.white,
                border: Border.all(
                  color: appColors.silver.withOpacity(0.1),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Image.network(
                  db_data_category.data_category!.imageUrl.toString(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                db_data_category.data_category!.title.toString(),
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: FontSize.body_fs,
                    color: appColors.black,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Artist card
  Widget artistCard(int index, db_data_artistCover db_data_artistCover) {
    return Container(
      height: 150,
      width: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color: appColors.silver.withOpacity(0.1),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  db_data_artistCover.data_artistCover!.name.toString(),
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: FontSize.body_fs,
                      fontWeight: FontWeight.w600,
                      color: appColors.black,
                    ),
                  ),
                ),
                SizedBox(
                  width: 140,
                  child: Text(
                    db_data_artistCover.data_artistCover!.description
                        .toString(),
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: FontSize.sub_body_fs,
                        color: appColors.black,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    service.get_artist_name =
                        db_data_artistCover.data_artistCover!.name;
                    Get.to(
                      () => artistDetailScreen(),
                      transition: Transition.rightToLeft,
                    );
                  },
                  child: Text(
                    "Learn more",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: FontSize.sub_body_fs,
                        color: appColors.pantone_red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            height: 150,
            width: 115,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: Image.network(
                db_data_artistCover.data_artistCover!.imageUrl.toString(),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
