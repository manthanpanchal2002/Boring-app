class db_data_subscriptionPlan {
  String? key;
  data_SubscriptionPlan? data_subscriptionPlan;

  db_data_subscriptionPlan({this.key, this.data_subscriptionPlan});
}

class data_SubscriptionPlan {
  String? name;
  String? price;
  late List<String> features;

  data_SubscriptionPlan({
    this.name,
    this.price,
    required this.features,
  });

  data_SubscriptionPlan.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'];
    price = json['price'];
    features = json['features'].cast<String>();
  }
}
