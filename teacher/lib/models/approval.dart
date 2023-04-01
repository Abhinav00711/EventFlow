class Approval {
  final String? aid;
  final String? eid;
  final String? eventname;
  final String? status; // PENDING, APPROVED, REJECTED
  final String? type; // DESIGN, DOCUMENT, VENUE
  final String? description;
  final String? attatchment;
  final String? comment;

  Approval({
    required this.aid,
    required this.eid,
    required this.eventname,
    required this.status,
    required this.type,
    required this.description,
    required this.attatchment,
    required this.comment,
  });

  factory Approval.fromJson(Map<String, Object?> json) {
    return Approval(
      aid: json['aid'] as String?,
      eid: json['eid'] as String?,
      status: json['status'] as String?,
      type: json['type'] as String?,
      description: json['description'] as String?,
      attatchment: json['attatchment'] as String?,
      comment: json['comment'] as String?,
      eventname: json['name'] as String?,
    );
  }
}
