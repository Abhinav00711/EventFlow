class Student {
  final String sid;
  final String intId;
  final String name;
  final String phone;
  final String email;
  final String department;
  final String course;

  Student({
    required this.sid,
    required this.intId,
    required this.name,
    required this.phone,
    required this.email,
    required this.department,
    required this.course,
  });

  factory Student.fromJson(Map<String, Object?> json) {
    return Student(
      sid: json['sid'] as String,
      intId: json['intid'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      department: json['dept'] as String,
      course: json['course'] as String,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'sid': sid,
      'intid': intId,
      'name': name,
      'phone': phone,
      'email': email,
      'dept': department,
      'course': course,
    };
  }
}
