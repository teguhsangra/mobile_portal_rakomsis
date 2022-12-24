class Location {
  late int id;
  late String code, name;

  Location({
    required this.id,
    required this.code,
    required this.name,
  });

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
  }
}