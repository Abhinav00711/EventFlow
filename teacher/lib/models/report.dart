import 'dart:ffi';

import 'package:intl/intl.dart';

class Report {
  final String teacherName;
  final String teacherEmail;
  final String? teacherDept;
  final String e_name;
  final String e_interest;
  final String e_start;
  final String e_end;
  final String e_description;
  final String e_status;
  final String e_graduate;
  final String e_image;
  final int participant_count;
  final String sid;
  final String? tid;
  final String s_name;
  final String s_email;
  final String s_department;
  final String s_course;
  final int vcount;


  Report({
    required this.teacherName,
    required this.teacherEmail,
  this.teacherDept,
  required this.e_name,
  required this.e_interest,
  required this.e_start,
  required this.e_end,
  required this.e_description,
  required this.e_status,
  required this.e_graduate, required this.e_image,
  required this.participant_count,
  required this.sid,
  required this.tid,
  required this.s_name,
  required this.s_email,
  required this.s_department,
  required this.s_course,
  required this.vcount

  });

  factory Report.fromJson(Map<String, Object?> json) {
    return Report(
      sid: json['sid'] as String,
      participant_count: json['participant_count'] as int,
      s_name: json['student_name'] as String,
      s_email: json['student_email'] as String,
      s_department: json['student_dept'] as String,
      s_course: json['student_course'] as String,
      e_name: json['event_name'] as String,
      e_interest: json['event_interest'] as String,
      e_start: DateFormat('yyyy-MM-dd').format(json['event_start'] as DateTime),
      e_end: DateFormat('yyyy-MM-dd').format(json['event_end'] as DateTime),
      e_description: json['event_description'] as String,
      e_status: json['event_status'] as String,
      e_graduate: json['event_graduate'] as String,
      e_image: json['event_image'] as String,
      tid: json['tid'] as String?,
      vcount: json['venue_count'] as int,
        teacherEmail: json['teacherEmail'] as String,
      teacherName: json['teacherName'] as String
    );
  }
}
