class db_data_category {
  String? key;
  data_Category? data_category;

  db_data_category({this.key, this.data_category});
}

class data_Category {
  String? id;
  String? title;
  String? imageUrl;

  data_Category({this.id, this.title, this.imageUrl});

  data_Category.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    title = json['title'];
    imageUrl = json['imageUrl'];
  }
}
