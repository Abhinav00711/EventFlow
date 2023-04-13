import 'dart:async';

import 'package:mysql1/mysql1.dart';

import '../models/student.dart';
import '../models/interest.dart';
import '../models/event.dart';
import '../models/event_detail.dart';
import '../models/teacher.dart';
import '../models/approval.dart';
import '../models/booking.dart';
import '../models/venue.dart';
import '../models/participant.dart';

class MySqlService {
  Future<MySqlConnection> getConnection() async {
    var settings = ConnectionSettings(
      host: 'db4free.net',
      port: 3306,
      user: 'eventflowstudent',
      password: 'eventflow',
      db: 'eventflow',
    );
    return await MySqlConnection.connect(settings);
  }

  Future<int> addStudent(Student studentData, Interest interestData) async {
    var con = await getConnection();
    var result = await con.query(
        'insert into interest (intid,cs,law,statistics,commerce,humanities,science) values (?, ?, ?, ?, ?, ?, ?)',
        [
          interestData.intId,
          interestData.cs,
          interestData.law,
          interestData.statistics,
          interestData.commerce,
          interestData.humanities,
          interestData.science
        ]);
    if (result.affectedRows == 1) {
      result = await con.query(
          'insert into student (sid,intid,name,email,phone,dept,course) values (?,?,?,?,?,?,?)',
          [
            studentData.sid,
            studentData.intId,
            studentData.name,
            studentData.email,
            studentData.phone,
            studentData.department,
            studentData.course
          ]);
    }
    con.close();
    return result.affectedRows!;
  }

  Future<int> updateInterest(Interest interestData) async {
    var con = await getConnection();
    var result = await con.query(
        'update interest set cs=?,law=?,statistics=?,commerce=?,humanities=?,science=? where intid = ?',
        [
          interestData.cs,
          interestData.law,
          interestData.statistics,
          interestData.commerce,
          interestData.humanities,
          interestData.science,
          interestData.intId,
        ]);
    con.close();
    return result.affectedRows!;
  }

  Future<Student> getStudent(String email) async {
    var con = await getConnection();
    Results result =
        await con.query('select * from student where email = ?', [email]);
    con.close();
    return Student.fromJson(result.elementAt(0).fields);
  }

  Future<Student> getStudentById(String sid) async {
    var con = await getConnection();
    Results result =
        await con.query('select * from student where sid = ?', [sid]);
    con.close();
    return Student.fromJson(result.elementAt(0).fields);
  }

  Future<Teacher> getTeacher(String tid) async {
    var con = await getConnection();
    Results result =
        await con.query('select * from teacher where tid = ?', [tid]);
    con.close();
    return Teacher.fromJson(result.elementAt(0).fields);
  }

  Future<Interest> getInterest(String intid) async {
    var con = await getConnection();
    Results result =
        await con.query('select * from interest where intid = ?', [intid]);
    con.close();
    return Interest.fromJson(result.elementAt(0).fields);
  }

  Future<Event> getEvent(String eid) async {
    var con = await getConnection();
    Results result =
        await con.query('select * from event where eid = ?', [eid]);
    con.close();
    return Event.fromJson(result.elementAt(0).fields);
  }

  Future<List<Event>> getAllEvents() async {
    List<Event> events = [];
    var con = await getConnection();
    Results result = await con.query('select * from event');
    con.close();
    for (var r in result) {
      events.add(Event.fromJson(r.fields));
    }
    return events;
  }

  Future<List<Event>> getOngoingEvents() async {
    List<Event> events = [];
    var con = await getConnection();
    Results result =
        await con.query('select * from event where status = "ONGOING"');
    con.close();
    for (var r in result) {
      events.add(Event.fromJson(r.fields));
    }
    return events;
  }

  Future<List<Event>> getPendingEvents() async {
    List<Event> events = [];
    var con = await getConnection();
    Results result =
        await con.query('select * from event where status = "PENDING"');
    con.close();
    for (var r in result) {
      events.add(Event.fromJson(r.fields));
    }
    return events;
  }

  Future<List<Event>> getCompletedEvents() async {
    List<Event> events = [];
    var con = await getConnection();
    Results result =
        await con.query('select * from event where status = "COMPLETED"');
    con.close();
    for (var r in result) {
      events.add(Event.fromJson(r.fields));
    }
    return events;
  }

  Future<Event?> isHosting(String sid) async {
    var con = await getConnection();
    Event? e;
    Results result = await con.query(
        'select * from event where sid = ? AND status <> "COMPLETED"', [sid]);
    con.close();
    if (result.isNotEmpty) {
      e = Event.fromJson(result.elementAt(0).fields);
    }
    return e;
  }

  Future<int> requestEvent(Event event) async {
    var con = await getConnection();
    var result = await con.query(
        'insert into event (eid,sid,tid,name,interest,start,end,description,status,graduate,image) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          event.eid,
          event.sid,
          event.tid,
          event.name,
          event.interest,
          event.start,
          event.end,
          event.description,
          event.status,
          event.graduate,
          event.image,
        ]);
    con.close();
    return result.affectedRows!;
  }

  Future<bool> getAttendance(String eid, String sid) async {
    var con = await getConnection();
    Results result = await con.query(
        'select * from participant where sid = ? AND eid = ?', [sid, eid]);
    con.close();
    if (result.isNotEmpty) {
      return Participant.fromJson(result.elementAt(0).fields).attendance;
    }
    return false;
  }

  Future<EventDetail> getEventDetail(Event event, String sid) async {
    Student student = await getStudentById(event.sid);
    Teacher teacher = await getTeacher(event.tid!);
    bool isPart = await isParticipating(event.eid, sid);
    bool isAttended = isPart ? await getAttendance(event.eid, sid) : false;
    EventDetail eventDetail = EventDetail(
      eid: event.eid,
      name: event.name,
      interest: event.interest,
      start: event.start,
      end: event.end,
      description: event.description,
      status: event.status,
      graduate: event.graduate,
      image: event.image,
      studName: student.name,
      studPhone: student.phone,
      teacherName: teacher.name,
      teacherPhone: teacher.phone,
      isParticipating: isPart,
      isAttended: isAttended,
    );
    return eventDetail;
  }

  Future<int> participate(String eid, String sid) async {
    var b = await isParticipating(eid, sid);
    if (b) {
      return -1;
    }
    var con = await getConnection();
    var result = await con.query(
        'insert into participant (eid,sid,attendance) values (?, ?, ?)', [
      eid,
      sid,
      false,
    ]);
    con.close();
    return result.affectedRows!;
  }

  Future<bool> isParticipating(String eid, String sid) async {
    var con = await getConnection();
    Results result = await con.query(
        'select * from participant where sid = ? AND eid = ?', [sid, eid]);
    con.close();
    if (result.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<int> markAttendance(String eid, String sid) async {
    var con = await getConnection();
    var result = await con.query(
        'update participant set attendance = ? where eid = ? AND sid = ?',
        [true, eid, sid]);
    con.close();
    return result.affectedRows!;
  }

  Future<List<Event>> getMyEvents(String sid) async {
    List<Event> events = [];
    var con = await getConnection();
    Results result =
        await con.query('select eid from participant where sid = ?', [sid]);
    con.close();
    for (var r in result) {
      var e = await getEvent(r.fields['eid']);
      events.add(e);
    }
    return events;
  }

  Future<int> updateEvent(Event eventData) async {
    var con = await getConnection();
    var result = await con.query(
        'update event set name=?,interest=?,start=?,end=?,description=?,status=?,graduate=?,image=? where eid = ?',
        [
          eventData.name,
          eventData.interest,
          eventData.start,
          eventData.end,
          eventData.description,
          eventData.status,
          eventData.graduate,
          eventData.image,
          eventData.eid,
        ]);
    con.close();
    return result.affectedRows!;
  }

  Future<List<Approval>> getEventApprovals(String eid) async {
    List<Approval> approvals = [];
    var con = await getConnection();
    Results result =
        await con.query('select * from approval where eid = ?', [eid]);
    con.close();
    for (var r in result) {
      approvals.add(Approval.fromJson(r.fields));
    }
    return approvals;
  }

  Future<int> requestApproval(Approval approval) async {
    var con = await getConnection();
    var result = await con.query(
        'insert into approval (aid,eid,status,type,description,attatchment,comment) values (?, ?, ?, ?, ?, ?, ?)',
        [
          approval.aid,
          approval.eid,
          approval.status,
          approval.type,
          approval.description,
          approval.attatchment,
          approval.comment,
        ]);
    con.close();
    return result.affectedRows!;
  }

  Future<List<Booking>> getAllBookings() async {
    List<Booking> bookings = [];
    var con = await getConnection();
    Results result = await con.query('select * from booking');
    con.close();
    for (var r in result) {
      bookings.add(Booking.fromJson(r.fields));
    }
    return bookings;
  }

  Future<List<Booking>> getEventBookings(String eid) async {
    List<Booking> bookings = [];
    var con = await getConnection();
    Results result =
        await con.query('select * from booking where eid = ?', [eid]);
    con.close();
    for (var r in result) {
      bookings.add(Booking.fromJson(r.fields));
    }
    return bookings;
  }

  Future<int> addBooking(Booking booking) async {
    var con = await getConnection();
    var result = await con.query(
        'insert into booking (bid,eid,vid,date,start,end) values (?, ?, ?, ?, ?, ?)',
        [
          booking.bid,
          booking.eid,
          booking.vid,
          booking.date,
          booking.start,
          booking.end,
        ]);
    con.close();
    return result.affectedRows!;
  }

  Future<List<Venue>> getAllVenues() async {
    List<Venue> venues = [];
    var con = await getConnection();
    Results result = await con.query('select * from venue');
    con.close();
    for (var r in result) {
      venues.add(Venue.fromJson(r.fields));
    }
    return venues;
  }

  Future<Venue?> getVenue(String vid) async {
    var con = await getConnection();
    Venue? venue;
    Results result =
        await con.query('select * from venue where vid = ?', [vid]);
    con.close();
    if (result.isNotEmpty) {
      venue = Venue.fromJson(result.elementAt(0).fields);
    }
    return venue;
  }

  Future<List<Venue>> getAvailableVenues(
      String date, String start, String end, int capacity) async {
    List<Venue> venues = [];
    var con = await getConnection();
    Results result = await con.query(
        'select * from venue where cap >= ? AND vid NOT IN (select vid from booking where date = ? AND start < ? AND end > ?)',
        [capacity, date, end, start]);
    con.close();
    for (var r in result) {
      venues.add(Venue.fromJson(r.fields));
    }
    return venues;
  }
}
