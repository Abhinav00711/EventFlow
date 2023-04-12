class Venue {
  final String vid;
  final String name;
  final int cap;
  final String loc;

  Venue({
    required this.vid,
    required this.name,
    required this.cap,
    required this.loc,
  });

  factory Venue.fromJson(Map<String, Object?> json) {
    return Venue(
      vid: json['vid'] as String,
      name: json['name'] as String,
      cap: json['cap'] as int,
      loc: json['loc'] as String,
    );
  }
}
