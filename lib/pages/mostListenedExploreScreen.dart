import 'package:boring_app/models/mostListened_model.dart';
import 'package:boring_app/models/service.dart';
import 'package:boring_app/pages/songScreen.dart';
import 'package:boring_app/utils/colors.dart';
import 'package:boring_app/utils/fontSize.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class mostListenedExploreScreen extends StatefulWidget {
  @override
  State<mostListenedExploreScreen> createState() =>
      _mostListenedExploreScreenState();
}

class _mostListenedExploreScreenState extends State<mostListenedExploreScreen> {
  DatabaseReference dfRef = FirebaseDatabase.instance.ref();
  List<db_data_mostListened> db_data_mostListened_list = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    retrieve_db_data();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.white,
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
                                'Most Listened',
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
                                db_data_mostListened_list.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: songCard(
                                      index, db_data_mostListened_list[index]),
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

  void retrieve_db_data() {
    setState(() {
      _isLoading = true;
    });

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
  }

  // song card
  Widget songCard(int index, db_data_mostListened db_data_mostListened) {
    return InkWell(
      onTap: () {
        service.get_song_name = db_data_mostListened.data_mostListened!.title;
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
                      db_data_mostListened.data_mostListened!.imageUrl
                          .toString(),
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
                        db_data_mostListened.data_mostListened!.title
                            .toString(),
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
                        db_data_mostListened.data_mostListened!.description
                            .toString(),
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
                                            db_data_mostListened
                                                .data_mostListened!.title
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
                                            db_data_mostListened
                                                .data_mostListened!.description
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
