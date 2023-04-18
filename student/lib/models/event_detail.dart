class EventDetail {
  final String eid;
  final String name;
  final String interest;
  final String start;
  final String end;
  final String description;
  final String status;
  final String graduate;
  final String? image;
  final String studName;
  final String studPhone;
  final String teacherName;
  final String teacherPhone;
  final bool isParticipating;
  bool isAttended;

  EventDetail({
    required this.eid,
    required this.name,
    required this.interest,
    required this.start,
    required this.end,
    required this.description,
    required this.status,
    required this.graduate,
    required this.image,
    required this.studName,
    required this.studPhone,
    required this.teacherName,
    required this.teacherPhone,
    required this.isParticipating,
    required this.isAttended,
  });
}
