import 'package:intl/intl.dart';

class Booking {
  final String bid;
  final String vid;
  final String eid;
  final String date;
  final String start;
  final String end;

  Booking({
    required this.bid,
    required this.vid,
    required this.eid,
    required this.date,
    required this.start,
    required this.end,
  });

  factory Booking.fromJson(Map<String, Object?> json) {
    final startDur = json['start'] as Duration;
    final endDur = json['end'] as Duration;
    return Booking(
      bid: json['bid'] as String,
      vid: json['vid'] as String,
      eid: json['eid'] as String,
      date: DateFormat('yyyy-MM-dd').format(json['date'] as DateTime),
      start:
          '${(startDur.inHours).toString().padLeft(2, '0')}:${(startDur.inMinutes % 60).toString().padLeft(2, '0')}',
      end:
          '${(endDur.inHours).toString().padLeft(2, '0')}:${(endDur.inMinutes % 60).toString().padLeft(2, '0')}',
    );
  }
}
