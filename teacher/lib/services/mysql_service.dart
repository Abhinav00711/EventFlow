import 'dart:async';

import 'package:mysql1/mysql1.dart';

import '../models/teacher.dart';
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

  Future<int> addTeacher(Teacher teacherData, Interest interestData) async {
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
          'insert into teacher (tid,intid,name,email,phone,dept) values (?,?,?,?,?,?)',
          [
            teacherData.tid,
            teacherData.intId,
            teacherData.name,
            teacherData.email,
            teacherData.phone,
            teacherData.department,
          ]);
    }
    else{
      print("Some error");
    }
    con.close();
    return result.affectedRows!;
  }

  Future<Teacher> getTeacher(String email) async {
    var con = await getConnection();
    Results result =
        await con.query('select * from teacher where email = ?', [email]);
    List<Teacher> t = [];
    for (var row in result) {
      Teacher stud = Teacher(
        tid: row['tid'],
        intId: row['intid'],
        name: row['name'],
        phone: row['phone'],
        email: row['email'],
        department: row['dept'],
      );
      t.add(stud);
    }
    con.close();
    return t[0];
  }
}
