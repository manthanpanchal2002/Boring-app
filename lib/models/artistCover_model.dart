class db_data_artistCover {
  String? key;
  data_ArtistCover? data_artistCover;

  db_data_artistCover({this.key, this.data_artistCover});
}

class data_ArtistCover {
  String? name;
  String? description;
  String? imageUrl;
  String? info;

  data_ArtistCover({this.name, this.description, this.imageUrl, this.info});

  data_ArtistCover.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'];
    description = json['description'];
    imageUrl = json['imageUrl'];
    info = json['info'];
  }
}
