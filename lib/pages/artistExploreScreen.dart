import 'package:boring_app/models/artistCover_model.dart';
import 'package:boring_app/pages/artistDetailScreen.dart';
import 'package:boring_app/utils/colors.dart';
import 'package:boring_app/utils/fontSize.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:boring_app/models/service.dart';

class artistExploreScreen extends StatefulWidget {
  const artistExploreScreen({Key? key}) : super(key: key);

  @override
  State<artistExploreScreen> createState() => _artistExploreScreenState();
}

class _artistExploreScreenState extends State<artistExploreScreen> {
  DatabaseReference dfRef = FirebaseDatabase.instance.ref();
  List<db_data_artistCover> db_data_artistCover_list = [];

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
                                'Artists',
                                style: GoogleFonts.poppins(
                                  fontSize: FontSize.subtitle_fs,
                                  fontWeight: FontWeight.bold,
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
                                db_data_artistCover_list
                                    .length, // Adjust the number of song cards as needed
                                (index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: artistCard(
                                      index, db_data_artistCover_list[index]),
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

  // Retrieve data from firebase
  void retrieve_db_data() {
    setState(() {
      _isLoading = true;
    });

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
  }

  // Artist card
  Widget artistCard(int index, db_data_artistCover db_data_artistCover) {
    return Container(
      height: 180,
      width: double.maxFinite,
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
            height: 180,
            width: 145,
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
