class Teacher {
  final String tid;
  final String intId;
  final String name;
  final String phone;
  final String email;
  final String department;

  Teacher({
    required this.tid,
    required this.intId,
    required this.name,
    required this.phone,
    required this.email,
    required this.department,
  });

  factory Teacher.fromJson(Map<String, Object?> json) {
    return Teacher(
      tid: json['tid'] as String,
      intId: json['intid'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      department: json['dept'] as String,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'tid': tid,
      'intid': intId,
      'name': name,
      'phone': phone,
      'email': email,
      'dept': department,
    };
  }
}
