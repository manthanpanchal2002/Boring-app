class db_data_termsOfUse {
  String? key;
  data_TermsOfUse? data_termsOfUse;

  db_data_termsOfUse({this.key, this.data_termsOfUse});
}

class data_TermsOfUse {
  String? title;
  String? content;

  data_TermsOfUse({this.title, this.content});

  data_TermsOfUse.fromJson(Map<dynamic, dynamic> json) {
    title = json['title'];
    content = json['content'];
  }
}
