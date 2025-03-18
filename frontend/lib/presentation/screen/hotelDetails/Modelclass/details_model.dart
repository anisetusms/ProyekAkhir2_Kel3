class Details {
  String? type;
  String? url;

  Details({
    required this.type,
    required this.url,
  });

  Details.fromJson(Map<String,  dynamic> json) {
    type = json['type'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic> {};
    data['type'] = type;
    data['url'] = url;
    return data;
  }
}