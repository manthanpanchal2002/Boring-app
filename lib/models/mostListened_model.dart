class db_data_mostListened{
  String? key;
  data_MostListened? data_mostListened;

  db_data_mostListened({this.key, this.data_mostListened});
}

class data_MostListened{
  String? id;
  String? title;
  String? description;
  String? imageUrl;

  data_MostListened({this.id, this.title, this.description, this.imageUrl});

  data_MostListened.fromJson(Map<dynamic, dynamic> json){
    id = json['id'];
    title = json['title'];
    description = json['description'];
    imageUrl = json['imageUrl'];
  }
}