import 'package:boring_app/models/playlistCover_model.dart';
import 'package:boring_app/models/service.dart';
import 'package:boring_app/pages/playlistDetailsScreen.dart';
import 'package:boring_app/utils/colors.dart';
import 'package:boring_app/utils/fontSize.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class playlistExploreScreen extends StatefulWidget {
  const playlistExploreScreen({Key? key}) : super(key: key);

  @override
  State<playlistExploreScreen> createState() => _playlistExploreScreenState();
}

class _playlistExploreScreenState extends State<playlistExploreScreen> {
  DatabaseReference dfRef = FirebaseDatabase.instance.ref();
  List<db_data_playlistCover> db_data_playlistCover_list = [];

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
      body: SafeArea(
        child: SingleChildScrollView(
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
                                'Popular playlists',
                                style: GoogleFonts.poppins(
                                  fontSize: FontSize.subtitle_fs,
                                  fontWeight: FontWeight.w600,
                                  color: appColors.pantone_red,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          SingleChildScrollView(
                            child: Column(
                              children: List.generate(
                                db_data_playlistCover_list
                                    .length, // Adjust the number of song cards as needed
                                (index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: playlistCard(
                                      index, db_data_playlistCover_list[index]),
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

  // Retrieve data from database
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
  }

  // card
  Widget playlistCard(int index, db_data_playlistCover db_data_playlistCover) {
    return InkWell(
      onTap: () {
        service.get_genre =
            db_data_playlistCover.data_playlistCover!.genre.toString();
        Get.to(
          () => playlistDetailsScreen(),
          transition: Transition.rightToLeft,
        );
        // get cover id
        service.get_playlist_cover_id =
            db_data_playlistCover.data_playlistCover!.id.toString();
      },
      child: Container(
        height: 180,
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          color: appColors.silver.withOpacity(0.5),
        ),
        child: Stack(
          children: [
            SizedBox(
              height: double.maxFinite,
              width: double.maxFinite,
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
                              fontSize: FontSize.subtitle_fs,
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
                              fontSize: FontSize.body_fs,
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
}
