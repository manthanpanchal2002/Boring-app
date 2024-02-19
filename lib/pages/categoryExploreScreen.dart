import 'package:boring_app/models/allSongs_model.dart';
import 'package:boring_app/pages/songScreen.dart';
import 'package:boring_app/utils/fontSize.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:boring_app/utils/colors.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:boring_app/models/service.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class categoryExploreScreen extends StatefulWidget {
  @override
  State<categoryExploreScreen> createState() => _categoryExploreScreenState();
}

class _categoryExploreScreenState extends State<categoryExploreScreen> {
  DatabaseReference dfRef = FirebaseDatabase.instance.ref();
  List<db_data_allSongs> db_data_allSongs_list = [];
  String? set_genre;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    set_genre = service.get_genre;
    retrieveSongCardData(set_genre!);
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
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Icon(FlutterRemix.arrow_left_s_line),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                set_genre.toString(),
                                style: GoogleFonts.poppins(
                                  fontSize: FontSize.subtitle_fs,
                                  fontWeight: FontWeight.w600,
                                  color: appColors.pantone_red,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Column(
                              children: List.generate(
                                db_data_allSongs_list.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: songCard(
                                      index, db_data_allSongs_list[index]),
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

  // Fetch songCard data
  void retrieveSongCardData(String set_genre) {
    setState(() {
      _isLoading = true;
    });

    dfRef
        .child('all_songs')
        .orderByChild('genre')
        .equalTo(set_genre)
        .onValue
        .listen((event) {
      var snapshot = event.snapshot;
      var value = snapshot.value;

      if (value is Map<dynamic, dynamic>) {
        // cover_id = value.keys.first;

        value.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            var data_allSongs = data_AllSongs.fromJson(value);
            db_data_allSongs_list
                .add(db_data_allSongs(key: key, data_allSongs: data_allSongs));

            setState(() {});
          }
        });
      } else {
        print("Data not found");
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  // song card
  Widget songCard(int index, db_data_allSongs db_data_allSongs) {
    return InkWell(
      onTap: () {
        service.get_song_name =
            db_data_allSongs.data_allSongs!.title.toString();
        Get.to(
          () => songScreen(),
          transition: Transition.rightToLeft,
        );
      },
      child: Container(
        height: 60,
        width: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          color: appColors.silver.withOpacity(0.1),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 0.0, right: 10.0),
          child: Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    color: appColors.black,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: Image.network(
                      db_data_allSongs.data_allSongs!.imageUrl.toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              SizedBox(
                width: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        db_data_allSongs.data_allSongs!.title.toString(),
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: FontSize.body_fs,
                            fontWeight: FontWeight.w600,
                            color: appColors.black,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        db_data_allSongs.data_allSongs!.description.toString(),
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: FontSize.sub_body_fs,
                            fontWeight: FontWeight.w400,
                            color: appColors.black,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 400,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            db_data_allSongs
                                                .data_allSongs!.title
                                                .toString(),
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                fontSize: FontSize.body_fs,
                                                fontWeight: FontWeight.w600,
                                                color: appColors.black,
                                              ),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            db_data_allSongs
                                                .data_allSongs!.description
                                                .toString(),
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                fontSize: FontSize.sub_body_fs,
                                                fontWeight: FontWeight.w400,
                                                color: appColors.black,
                                              ),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      FlutterRemix.close_circle_fill,
                                      color: appColors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                thickness: 0.5,
                                color: appColors.silver,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    FlutterRemix.share_line,
                                    color: appColors.silver,
                                    size: 22,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Share",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: FontSize.subtitle_fs,
                                          color: appColors.silver,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    FlutterRemix.download_2_line,
                                    color: appColors.silver,
                                    size: 22,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Download",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: FontSize.subtitle_fs,
                                          color: appColors.silver,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    FlutterRemix.file_list_2_line,
                                    color: appColors.silver,
                                    size: 22,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Information",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: FontSize.subtitle_fs,
                                          color: appColors.silver,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    FlutterRemix.heart_fill,
                                    color: appColors.silver,
                                    size: 22,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Add to Favorites",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: FontSize.subtitle_fs,
                                          color: appColors.silver,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Icon(
                  FlutterRemix.more_2_line,
                  color: appColors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
