import 'package:boring_app/utils/fontSize.dart';
import 'package:boring_app/utils/colors.dart';
import 'package:boring_app/models/privacyPolicy_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class privacyPolicyScreen extends StatefulWidget {
  @override
  State<privacyPolicyScreen> createState() => _privacyPolicyScreenState();
}

class _privacyPolicyScreenState extends State<privacyPolicyScreen> {
  DatabaseReference dfRef = FirebaseDatabase.instance.ref();
  List<db_data_privacyPolicy> db_data_privacyPolicy_list = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    retrieve_privacy_policy_data();
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
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Privacy policy",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: FontSize.title_fs,
                                      fontWeight: FontWeight.bold,
                                      color: appColors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Icon(
                                  FlutterRemix.close_circle_fill,
                                  color: appColors.black,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Last updated: 29th December 2023",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: FontSize.subtitle_fs,
                                  fontWeight: FontWeight.w500,
                                  color: appColors.silver,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          for (int i = 1;
                              i < db_data_privacyPolicy_list.length;
                              i++)
                            privacy_policy_data_widget(
                                db_data_privacyPolicy_list[i]),
                        ],
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  void retrieve_privacy_policy_data() {
    setState(() {
      _isLoading = true;
    });
    dfRef.child('privacy_policy').onChildAdded.listen(
      (data) {
        data_PrivacyPolicy data_privacyPolicy =
            data_PrivacyPolicy.fromJson(data.snapshot.value as Map);
        db_data_privacyPolicy_list.add(
          db_data_privacyPolicy(
            key: data.snapshot.key,
            data_privacyPolicy: data_privacyPolicy,
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

  Widget privacy_policy_data_widget(
      db_data_privacyPolicy db_data_privacyPolicy_list) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            db_data_privacyPolicy_list.data_privacyPolicy!.section.toString(),
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: FontSize.subtitle_fs,
                fontWeight: FontWeight.w500,
                color: appColors.black,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 3,
        ),
        Text(
          db_data_privacyPolicy_list.data_privacyPolicy!.description.toString(),
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: FontSize.body_fs,
              fontWeight: FontWeight.w400,
              color: appColors.silver,
            ),
          ),
          textAlign: TextAlign.justify,
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
