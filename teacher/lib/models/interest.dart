class Interest {
  final String intId;
  final bool cs;
  final bool law;
  final bool statistics;
  final bool commerce;
  final bool humanities;
  final bool science;

  Interest({
    required this.intId,
    required this.cs,
    required this.law,
    required this.statistics,
    required this.commerce,
    required this.humanities,
    required this.science,
  });

  factory Interest.fromJson(Map<String, Object?> json) {
    return Interest(
      intId: json['intid'] as String,
      cs: json['cs'] as bool,
      law: json['law'] as bool,
      statistics: json['statistics'] as bool,
      commerce: json['commerce'] as bool,
      humanities: json['humanities'] as bool,
      science: json['science'] as bool,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'intid': intId,
      'cs': cs,
      'law': law,
      'statistics': statistics,
      'commerce': commerce,
      'humanities': humanities,
      'science': science,
    };
  }
}
