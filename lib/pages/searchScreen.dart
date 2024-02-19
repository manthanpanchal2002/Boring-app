import 'package:boring_app/models/allSongs_model.dart';
import 'package:boring_app/models/service.dart';
import 'package:boring_app/pages/songScreen.dart';
import 'package:boring_app/utils/fontSize.dart';
import 'package:boring_app/utils/colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class searchScreen extends StatefulWidget {
  @override
  State<searchScreen> createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
  DatabaseReference dfRef = FirebaseDatabase.instance.ref();
  static List<db_data_allSongs> db_data_allSongs_list = [];

  TextEditingController searchController = TextEditingController();

  bool _isLoading = false;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    if (db_data_allSongs_list.length == 0) {
      retrieve_db_data();
    }
  }

  // search function
  List<db_data_allSongs> display_results = List.from(db_data_allSongs_list);

  void search(String query) {
    query = query.toLowerCase();
    List<db_data_allSongs> filteredResults = db_data_allSongs_list
        .where((element) =>
            element.data_allSongs!.title!.toLowerCase().contains(query))
        .toList();

    setState(() {
      display_results = filteredResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      FlutterRemix.search_2_line,
                      size: 20,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        search(value);
                        if (value.length != 0) {
                          setState(() {
                            _isSearching = true;
                          });
                        } else {
                          setState(() {
                            _isSearching = false;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: FontSize.subtitle_fs,
                          color: appColors.silver,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _isLoading
                ? LinearProgressIndicator(
                    minHeight: 1,
                    backgroundColor: Colors.transparent,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(appColors.pantone_red),
                  )
                : Divider(color: appColors.silver, thickness: 1),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _isSearching
                        ? Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: display_results.length == 0
                                ? Column(
                                    children: [
                                      Image.asset(
                                        'assets/images/Lost.png',
                                        height: 250,
                                        width: 250,
                                      ),
                                      Text(
                                        'The thing you are looking for is not found',
                                        style: GoogleFonts.poppins(
                                          fontSize: FontSize.body_fs,
                                          color: appColors.black,
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: List.generate(
                                      display_results.length,
                                      (index) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: songCard(
                                            index, display_results[index]),
                                      ),
                                    ),
                                  ),
                          )
                        : Column(
                            children: [
                              Image.asset(
                                'assets/images/no_search_history_found.png',
                                height: 250,
                                width: 250,
                              ),
                              Text(
                                'The only truth is music. Search it.',
                                style: GoogleFonts.poppins(
                                  fontSize: FontSize.body_fs,
                                  color: appColors.black,
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
    );
  }

  // Retrieve data from database
  void retrieve_db_data() {
    setState(() {
      _isLoading = true;
    });

    dfRef.child('all_songs').onChildAdded.listen(
      (data) {
        data_AllSongs data_allSongs =
            data_AllSongs.fromJson(data.snapshot.value as Map);
        db_data_allSongs_list.add(
          db_data_allSongs(
            key: data.snapshot.key,
            data_allSongs: data_allSongs,
          ),
        );
        // Filter the initial display_results based on the entire data
        display_results = List.from(db_data_allSongs_list);
        setState(
          () {
            _isLoading = false;
          },
        );
      },
    );
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
                                height: 20,
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
                                height: 20,
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
                                height: 20,
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
                                height: 20,
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
