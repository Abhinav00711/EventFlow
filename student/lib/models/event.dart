import 'package:intl/intl.dart';

class Event {
  final String eid;
  final String sid;
  final String? tid;
  final String name;
  final String interest;
  final String start;
  final String end;
  final String description;
  final String status;
  final String graduate;
  final String? image;

  Event({
    required this.eid,
    required this.sid,
    required this.tid,
    required this.name,
    required this.interest,
    required this.start,
    required this.end,
    required this.description,
    required this.status,
    required this.graduate,
    required this.image,
  });

  factory Event.fromJson(Map<String, Object?> json) {
    return Event(
      eid: json['eid'] as String,
      sid: json['sid'] as String,
      tid: json['tid'] as String?,
      name: json['name'] as String,
      interest: json['interest'] as String,
      start: DateFormat('yyyy-MM-dd').format(json['start'] as DateTime),
      end: DateFormat('yyyy-MM-dd').format(json['end'] as DateTime),
      description: json['description'] as String,
      status: json['status'] as String,
      graduate: json['graduate'] as String,
      image: json['image'] as String?,
    );
  }
}
