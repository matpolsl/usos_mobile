import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oauth1/oauth1.dart' as oauth1;

import 'package:usos/widgets/subject.dart';
import 'package:usos/models/courses_user.dart';
import 'package:usos/usos.dart';

class Grades extends StatefulWidget {
  Grades(this.client, this.term, {Key? key}) : super(key: key);
  late oauth1.Client client;
  late String term;
  @override
  _GradesState createState() => _GradesState(client, term);
}

class _GradesState extends State<Grades> {
  late oauth1.Client client;
  late String term;
  _GradesState(this.client, this.term);

  List<CoursesUser>? _nowGrades;
  @override
  void initState() {
    super.initState();
    fetchCoursesByTerm(term);
  }

  Future<Map<String, dynamic>> fetchCourses() async {
    return client
        .get(Uri.parse(usosApi +
            'services/courses/user?fields=course_editions%5Bcourse_id%7Ccourse_name%5D'))
        .then((res) {
      final json = jsonDecode(res.body);
      return json['course_editions'];
    });
  }

  Future getGrade(courseId, termId, CoursesUser objectCourse) async {
    try {
      client
          .get(Uri.parse(usosApi +
              'services/grades/course_edition2?course_id=' +
              courseId +
              '&term_id=' +
              termId))
          .then((res) async {
        //result = null;
        final json =
            ((jsonDecode(res.body))['course_grades'] as List)[0]['1'] == null
                ? null
                : ((jsonDecode(res.body))['course_grades'] as List)[0]['1']
                    ['value_symbol'];
        objectCourse.grade = json != null ? double.parse(json) : null;
      });
    } catch (_) {
      getGrade(courseId, termId, objectCourse);
    }
  }

  Future fetchCoursesByTerm(term) async {
    List<CoursesUser> userGrades = [];
    fetchCourses().then((value) {
      (value[term] as List)
          .map((data) => CoursesUser.fromJson(data))
          .forEach((element) {
        Future.delayed(const Duration(seconds: 5));
        http
            .get(Uri.parse(
                "https://usos.ct8.pl/ects.php?CODE=" + element.courseId))
            .then((res) {
          final ects = (jsonDecode(res.body))['ects'];
          //getGrade(element.courseId, term).then((value) => _grade = value);
          final object = CoursesUser(
            courseId: element.courseId,
            name: element.name,
            grade: null,
            ects: ects,
          );
          getGrade(element.courseId, term, object);

          userGrades.add(object);
          print(userGrades.last.name + " " + userGrades.last.grade.toString());
        });
      });
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _nowGrades = userGrades;
    });
  }

  Future refresh() async {
    fetchCoursesByTerm(term);
  }

  @override
  Widget build(BuildContext context) {
    return _nowGrades != null
        ? Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (ctx, index) => Subject(_nowGrades![index]),
                    itemCount: _nowGrades!.length,
                  ),
                ),
                ElevatedButton(
                  onPressed: refresh,
                  child: Text('Refresh'),
                ),
              ],
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
