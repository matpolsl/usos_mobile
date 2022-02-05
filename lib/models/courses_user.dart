class CoursesUser {
  final String courseId;
  final String name;
  double? grade;
  final int? ects;
  CoursesUser({
    required this.courseId,
    required this.name,
    this.grade,
    this.ects,
  });

  factory CoursesUser.fromJson(Map<String, dynamic> json) {
    print(json['course_name']['pl']);
    return CoursesUser(
      courseId: json['course_id'],
      name: json['course_name']['pl'],
    );
  }
}
