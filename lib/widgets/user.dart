import 'dart:convert';
import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:flutter/material.dart';
import 'package:usos/models/courses_user.dart';
import 'package:http/http.dart' as http;
import 'package:usos/models/programme.dart';
import 'package:usos/models/terms.dart';
import 'package:usos/models/user_data.dart';
import 'package:usos/usos.dart';
import 'package:usos/widgets/grades.dart';
import 'package:usos/widgets/menu.dart';

import 'drop_down_terms.dart';

class User extends StatefulWidget {
  User(this.client, this.nameUser, {Key? key}) : super(key: key);
  late oauth1.Client client;
  late UserData nameUser;
  @override
  _UserState createState() => _UserState(client, nameUser);
}

class _UserState extends State<User> {
  late oauth1.Client client;
  late UserData nameUser;
  late Future<Map<String, dynamic>> courses;
  List<Terms>? terms;
  _UserState(this.client, this.nameUser);
  String? term;
  List<CoursesUser>? _nowGrades;
  List<Programme> programmes = [];
  @override
  void initState() {
    super.initState();
    fetchProgs();
    fetchTerms();
  }

  Future fetchProgs() async {
    programmes = [];
    client.get(Uri.parse(usosApi + 'services/progs/student')).then((res) {
      ((jsonDecode(res.body) as List))
          .map((data) => Programme.fromJson(data))
          .forEach((element) {
        programmes.add(element);
      });
    });
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

  Future getGrade(termId, CoursesUser objectCourse) async {
    try {
      client
          .get(Uri.parse(usosApi +
              'services/grades/course_edition2?course_id=' +
              objectCourse.courseId +
              '&term_id=' +
              termId))
          .then((res) {
        //result = null;
        final json =
            ((jsonDecode(res.body))['course_grades'] as List)[0]['1'] == null
                ? null
                : ((jsonDecode(res.body))['course_grades'] as List)[0]['1']
                    ['value_symbol'];
        objectCourse.grade = json != null
            ? double.parse(json.toString().replaceAll(',', '.'))
            : null;
        print(objectCourse.name + " " + objectCourse.grade.toString());
      });
    } catch (_) {
      getGrade(termId, objectCourse);
    }
  }

  Future fetchCoursesByTerm(term) async {
    List<CoursesUser> userGrades = [];
    fetchCourses().then((value) {
      (value[term] as List)
          .map((data) => CoursesUser.fromJson(data))
          .forEach((element) async {
        Future.delayed(const Duration(seconds: 5));
        await http
            .get(Uri.parse(
                "https://usos.ct8.pl/ects.php?CODE=" + element.courseId))
            .then((res) async {
          final ects = (jsonDecode(res.body))['ects'];
          //getGrade(element.courseId, term).then((value) => _grade = value);
          final object = CoursesUser(
            courseId: element.courseId,
            name: element.name,
            grade: null,
            ects: ects,
          );

          await getGrade(term, object);

          userGrades.add(object);
        });
      });
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _nowGrades = userGrades;
    });
  }

  Future refresh() async {
    setState(() {
      _nowGrades = null;
      fetchCoursesByTerm(term);
    });
  }

  void setTerm(String newTerm) {
    term = newTerm;
    refresh();
  }

  Future fetchTerms() async {
    client
        .get(Uri.parse(usosApi + 'services/courses/user?fields=terms'))
        .then((res) {
      final json = jsonDecode(res.body);
      terms =
          (json['terms'] as List).map((data) => Terms.fromJson(data)).toList();
      term = terms!.last.termId;
      getData();
    });
  }

  Future getData() async {
    setState(() {
      refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Usos PŚ"),
        actions: [
          IconButton(
            onPressed: () => refresh(),
            icon: Icon(Icons.refresh),
          )
        ],
      ),
      drawer: Menu(nameUser, programmes),
      body: Column(
        children: [
          terms != null
              ? DropDownTerms(terms!,setTerm)
              : const Center(
                  child: CircularProgressIndicator(),
                ),
          _nowGrades != null
              ? Grades(_nowGrades!)
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ],
      ),
    );
  }
}
