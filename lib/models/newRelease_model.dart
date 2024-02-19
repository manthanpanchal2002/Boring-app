class db_data_newRelease{
  String? key;
  data_NewRelease? data_newRelease;

  db_data_newRelease({this.key, this.data_newRelease});
}

class data_NewRelease{
  String? id;
  String? title;
  String? description;
  String? imageUrl;

  data_NewRelease({this.id, this.title, this.description, this.imageUrl});

  data_NewRelease.fromJson(Map<dynamic, dynamic> json){
    id = json['id'];
    title = json['title'];
    description = json['description'];
    imageUrl = json['imageUrl'];
  }
}