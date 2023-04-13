class Participant {
  final String eid;
  final String sid;
  final bool attendance;

  Participant({
    required this.eid,
    required this.sid,
    required this.attendance,
  });

  factory Participant.fromJson(Map<String, Object?> json) {
    return Participant(
      eid: json['eid'] as String,
      sid: json['sid'] as String,
      attendance: json['attendance'] == 1,
    );
  }
}
