class CoursesUser {
  final String courseId;
  final String name;
  double? grade;
  int? ects;
  CoursesUser({
    required this.courseId,
    required this.name,
    this.grade,
    this.ects,
  });
  setECTS(val) {
    this.ects = val;
  }

  factory CoursesUser.fromJson(Map<String, dynamic> json) {
    return CoursesUser(
      courseId: json['course_id'],
      name: json['course_name']['pl'],
    );
  }
}
