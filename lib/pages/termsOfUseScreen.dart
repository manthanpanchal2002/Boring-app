import 'package:boring_app/models/termsOfUse_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:boring_app/utils/colors.dart';
import 'package:boring_app/utils/fontSize.dart';

class termsOfUseScreen extends StatefulWidget {
  const termsOfUseScreen({Key? key}) : super(key: key);

  @override
  State<termsOfUseScreen> createState() => _termsOfUseScreenState();
}

class _termsOfUseScreenState extends State<termsOfUseScreen> {
  DatabaseReference dfRef = FirebaseDatabase.instance.ref();
  List<db_data_termsOfUse> db_data_termsOfUse_list = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    retrieve_terms_of_use_data();
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
                                  "Terms of use",
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
                          Text(
                            "By using the Boring Music App, you agree to comply with and be legally bound by these Terms of Use.",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: FontSize.subtitle_fs,
                                fontWeight: FontWeight.w500,
                                color: appColors.silver,
                              ),
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          for (int i = 1;
                              i < db_data_termsOfUse_list.length;
                              i++)
                            terms_of_use_data_widget(
                                db_data_termsOfUse_list[i]),
                        ],
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  void retrieve_terms_of_use_data() {
    setState(() {
      _isLoading = true;
    });

    dfRef.child('terms_of_use').onChildAdded.listen(
      (data) {
        data_TermsOfUse data_termsOfUse =
            data_TermsOfUse.fromJson(data.snapshot.value as Map);
        db_data_termsOfUse_list.add(
          db_data_termsOfUse(
            key: data.snapshot.key,
            data_termsOfUse: data_termsOfUse,
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

  Widget terms_of_use_data_widget(db_data_termsOfUse db_data_termsOfUse_list) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            db_data_termsOfUse_list.data_termsOfUse!.title.toString(),
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
          db_data_termsOfUse_list.data_termsOfUse!.content.toString(),
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
