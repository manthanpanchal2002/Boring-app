class db_data_allSongs {
  String? key;
  data_AllSongs? data_allSongs;

  db_data_allSongs({this.key, this.data_allSongs});
}

class data_AllSongs {
  String? title;
  String? description;
  String? imageUrl;
  String? audioUrl;
  String? genre;

  data_AllSongs(
      {this.title, this.description, this.imageUrl, this.audioUrl, this.genre});

  data_AllSongs.fromJson(Map<dynamic, dynamic> json) {
    title = json['title'];
    description = json['description'];
    imageUrl = json['imageUrl'];
    audioUrl = json['audioUrl'];
    genre = json['genre'];
  }
}
