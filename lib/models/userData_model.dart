class db_data_userData {
  String? key;
  data_UserData? data_userData;

  db_data_userData({this.key, this.data_userData});
}

class data_UserData {
  String? firstname;
  String? lastname;
  String? email;

  data_UserData({this.firstname, this.lastname, this.email});

  data_UserData.fromJson(Map<dynamic, dynamic> json) {
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
  }
}
