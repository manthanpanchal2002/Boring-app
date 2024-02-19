import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:boring_app/models/allSongs_model.dart';
import 'package:boring_app/models/service.dart';
import 'package:boring_app/utils/colors.dart';
import 'package:boring_app/utils/fontSize.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class songScreen extends StatefulWidget {
  const songScreen({Key? key}) : super(key: key);

  @override
  State<songScreen> createState() => _songScreenState();
}

class _songScreenState extends State<songScreen> {
  final player = AudioPlayer();
  bool isPlaying = false;
  Duration currentPosition = Duration();
  Duration totalDuration = Duration();
  String? set_song_name;

  DatabaseReference dfRef = FirebaseDatabase.instance.ref();
  static List<db_data_allSongs> db_data_allSongs_list = [];

  String? id;
  String? title;
  String? description;
  String? imageUrl;
  String? audioUrl;

  bool _isLoading = false;

  // Play song
  Future<void> playPauseSong() async {
    if (isPlaying) {
      await player.pause();
    } else {
      await player.play(UrlSource(audioUrl!));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  void initState() {
    super.initState();

    id = '';
    title = '';
    description = '';
    imageUrl = '';
    audioUrl = '';

    set_song_name = service.get_song_name;

    retrieveData(set_song_name!);

    player.onPositionChanged.listen((event) {
      setState(() {
        currentPosition = event;
      });
    });

    player.onDurationChanged.listen((Duration duration) {
      setState(() {
        totalDuration = duration;
      });
    });
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
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              player.stop();
                              Get.back();
                            },
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Icon(
                                FlutterRemix.arrow_left_s_line,
                                color: appColors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 300,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0),
                              color: appColors.silver.withOpacity(0.1),
                              boxShadow: [
                                BoxShadow(
                                  color: appColors.black.withOpacity(0.1),
                                  spreadRadius: 7,
                                  blurRadius: 10,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: imageUrl != null && imageUrl!.isNotEmpty
                                ? Image.network(
                                    imageUrl!,
                                    fit: BoxFit.cover,
                                  )
                                : Container(),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: [
                              Text(
                                title!,
                                style: GoogleFonts.poppins(
                                  fontSize: FontSize.subtitle_fs,
                                  fontWeight: FontWeight.w600,
                                  color: appColors.black,
                                ),
                              ),
                              Text(
                                description!,
                                style: GoogleFonts.poppins(
                                  fontSize: FontSize.body_fs,
                                  color: appColors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ProgressBar(
                            barCapShape: BarCapShape.square,
                            barHeight: 2,
                            thumbRadius: 5,
                            thumbGlowRadius: 10,
                            progress: currentPosition,
                            total: totalDuration,
                            timeLabelTextStyle: GoogleFonts.poppins(
                              fontSize: FontSize.body_fs,
                              color: appColors.black,
                            ),
                            baseBarColor: appColors.silver.withOpacity(0.1),
                            progressBarColor: appColors.black,
                            thumbColor: appColors.black,
                            onSeek: (duration) {
                              player.seek(duration);
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                FlutterRemix.heart_line,
                                color: appColors.black,
                              ),
                              InkWell(
                                onTap: () {},
                                child: Icon(
                                  FlutterRemix.skip_back_line,
                                  color: appColors.black,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  playPauseSong();
                                },
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: appColors.silver.withOpacity(0.1),
                                  ),
                                  child: Icon(
                                    isPlaying
                                        ? FlutterRemix.pause_line
                                        : FlutterRemix.play_line,
                                    color: appColors.black,
                                  ),
                                ),
                              ),
                              Icon(
                                FlutterRemix.skip_forward_line,
                                color: appColors.black,
                              ),
                              Icon(
                                FlutterRemix.share_forward_line,
                                color: appColors.black,
                              ),
                            ],
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
  void retrieveData(String set_song_name) {
    setState(() {
      _isLoading = true;
    });

    dfRef
        .child('all_songs')
        .orderByChild('title')
        .equalTo(set_song_name)
        .onValue
        .listen((event) {
      var snapshot = event.snapshot;
      var value = snapshot.value;

      if (value is Map<dynamic, dynamic>) {
        id = value.keys.first;

        value.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            var data_allSongs = data_AllSongs.fromJson(value);
            db_data_allSongs_list
                .add(db_data_allSongs(key: key, data_allSongs: data_allSongs));

            // set data
            title = data_allSongs.title;
            description = data_allSongs.description;
            imageUrl = data_allSongs.imageUrl;
            audioUrl = data_allSongs.audioUrl;
            player.setSource(UrlSource(audioUrl!));

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
