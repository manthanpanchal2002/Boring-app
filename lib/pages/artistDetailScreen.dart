import 'package:boring_app/models/artistCover_model.dart';
import 'package:boring_app/utils/fontSize.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:boring_app/utils/colors.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:boring_app/models/service.dart';

class artistDetailScreen extends StatefulWidget {
  @override
  State<artistDetailScreen> createState() => _artistDetailScreenState();
}

class _artistDetailScreenState extends State<artistDetailScreen> {
  DatabaseReference dfRef = FirebaseDatabase.instance.ref();
  List<db_data_artistCover> db_data_artistCover_list = [];

  String? set_artist_name;
  String? id;
  String? name;
  String? description;
  String? imageUrl;
  String? info;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    id = '';
    name = '';
    description = '';
    imageUrl = '';
    info = '';

    set_artist_name = service.get_artist_name;
    retrieveData(set_artist_name!);
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(FlutterRemix.arrow_left_s_line),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Container(
                              height: 150,
                              width: 115,
                              child: imageUrl != null && imageUrl!.isNotEmpty
                                  ? Image.network(
                                      imageUrl!,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0),
                                boxShadow: [
                                  BoxShadow(
                                    color: appColors.black.withOpacity(0.1),
                                    spreadRadius: 7,
                                    blurRadius: 10,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Text(
                              name ?? '',
                              style: GoogleFonts.poppins(
                                fontSize: FontSize.subtitle_fs,
                                fontWeight: FontWeight.w600,
                                color: appColors.black,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              description ?? '',
                              style: GoogleFonts.poppins(
                                fontSize: FontSize.body_fs,
                                fontWeight: FontWeight.w400,
                                color: appColors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Follow',
                                      style: GoogleFonts.poppins(
                                        fontSize: FontSize.subtitle_fs,
                                        fontWeight: FontWeight.w600,
                                        color: appColors.white,
                                      ),
                                    ),
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          OutlinedBorder>(
                                        BeveledRectangleBorder(),
                                      ),
                                      minimumSize:
                                          MaterialStateProperty.all<Size>(
                                        Size.fromHeight(40),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        appColors.pantone_red,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Listen',
                                      style: GoogleFonts.poppins(
                                        fontSize: FontSize.subtitle_fs,
                                        fontWeight: FontWeight.w600,
                                        color: appColors.black,
                                      ),
                                    ),
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          OutlinedBorder>(
                                        BeveledRectangleBorder(),
                                      ),
                                      minimumSize:
                                          MaterialStateProperty.all<Size>(
                                        Size.fromHeight(40),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        appColors.white,
                                      ),
                                      side:
                                          MaterialStateProperty.all<BorderSide>(
                                        BorderSide(
                                          color:
                                              appColors.silver.withOpacity(0.5),
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'About',
                            style: GoogleFonts.poppins(
                              fontSize: FontSize.subtitle_fs,
                              fontWeight: FontWeight.w600,
                              color: appColors.black,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            info ?? '',
                            style: GoogleFonts.poppins(
                              fontSize: FontSize.body_fs,
                              fontWeight: FontWeight.w400,
                              color: appColors.black,
                            ),
                            textAlign: TextAlign.justify,
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

  // Fetch data from the database
  void retrieveData(String set_artist_name) {
    setState(() {
      _isLoading = true;
    });

    dfRef
        .child('artist_cover')
        .orderByChild('name')
        .equalTo(set_artist_name)
        .onValue
        .listen((event) {
      var snapshot = event.snapshot;
      var value = snapshot.value;

      if (value is Map<dynamic, dynamic>) {
        id = value.keys.first;

        value.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            var data_artistCover = data_ArtistCover.fromJson(value);
            db_data_artistCover_list.add(db_data_artistCover(
                key: key, data_artistCover: data_artistCover));

            // set data
            name = data_artistCover.name;
            description = data_artistCover.description;
            imageUrl = data_artistCover.imageUrl;
            info = data_artistCover.info;

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
}
