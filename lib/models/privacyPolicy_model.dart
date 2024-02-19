class db_data_privacyPolicy{
  String? key;
  data_PrivacyPolicy? data_privacyPolicy;

  db_data_privacyPolicy({this.key, this.data_privacyPolicy});
}

class data_PrivacyPolicy{
  String? section;
  String? value;
  String? description;

  data_PrivacyPolicy({this.section, this.value, this.description});

  data_PrivacyPolicy.fromJson(Map<dynamic, dynamic> json) {
    section = json['section'];
    value = json['value'];
    description = json['description'];
  }
}