class db_data_playlistCover {
  String? key;
  data_PlaylistCover? data_playlistCover;

  db_data_playlistCover({this.key, this.data_playlistCover});
}

class data_PlaylistCover {
  String? id;
  String? title;
  String? description;
  String? imageUrl;
  String? genre;

  data_PlaylistCover(
      {this.id, this.title, this.description, this.imageUrl, this.genre});

  data_PlaylistCover.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    imageUrl = json['imageUrl'];
    genre = json['genre'];
  }
}
