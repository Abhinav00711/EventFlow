import 'dart:async';

import 'package:mysql1/mysql1.dart';

import '../models/student.dart';
import '../models/interest.dart';

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

  Future<Student> getStudent(String email) async {
    var con = await getConnection();
    Results result =
        await con.query('select * from student where email = ?', [email]);
    List<Student> s = [];
    for (var row in result) {
      Student stud = Student(
        sid: row['sid'],
        intId: row['intid'],
        name: row['name'],
        phone: row['phone'],
        email: row['email'],
        department: row['dept'],
        course: row['course'],
      );
      s.add(stud);
    }
    con.close();
    return s[0];
  }
}
