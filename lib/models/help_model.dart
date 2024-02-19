class db_data_help {
  String? key;
  data_Help? data_help;

  db_data_help({this.key, this.data_help});
}

class data_Help {
  late Map<String, dynamic> accountRelated;
  late Map<String, dynamic> playlists;
  late Map<String, dynamic> listeningExperience;
  late Map<String, dynamic> technicalSupport;
  late Map<String, dynamic> paymentsAndSubscriptions;
  late Map<String, dynamic> contactInformation;

  data_Help({
    required this.accountRelated,
    required this.playlists,
    required this.listeningExperience,
    required this.technicalSupport,
    required this.paymentsAndSubscriptions,
    required this.contactInformation,
  });

  factory data_Help.fromJson(Map<String, dynamic> json) {
    return data_Help(
      accountRelated: json['1']['accountRelated'],
      playlists: json['2']['playlists'],
      listeningExperience: json['3']['listeningExperience'],
      technicalSupport: json['4']['technicalSupport'],
      paymentsAndSubscriptions: json['5']['paymentsAndSubscriptions'],
      contactInformation: json['6']['contactInformation'],
    );
  }

  @override
  String toString() {
    return 'Data Help: { accountRelated: $accountRelated, '
        'playlists: $playlists, listeningExperience: $listeningExperience, '
        'technicalSupport: $technicalSupport, paymentsAndSubscriptions: $paymentsAndSubscriptions, '
        'contactInformation: $contactInformation }';
  }
}

