import 'dart:convert';
import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/programme.dart';
import '../models/terms.dart';
import '../models/user_data.dart';
import '../widgets/grades.dart';
import '../usos.dart';
import '../widgets/menu.dart';
import '../models/courses_user.dart';
import '../widgets/drop_down_terms.dart';

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
  var indexOfProg = 0;
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
      var response = await client.get(Uri.parse(usosApi +
          'services/grades/course_edition2?course_id=' +
          objectCourse.courseId +
          '&term_id=' +
          termId));
      final json =
          ((jsonDecode(response.body))['course_grades'] as List)[0]['1'] == null
              ? null
              : ((jsonDecode(response.body))['course_grades'] as List)[0]['1']
                  ['value_symbol'];
      objectCourse.grade = json != null
          ? double.parse(json.toString().replaceAll(',', '.'))
          : null;
    } catch (_) {
      print("Error");
      getGrade(termId, objectCourse);
    }
  }

  Future fetchCoursesByTerm(term) async {
    List<CoursesUser> userGrades = [];
    var coursesResponse = await fetchCourses();
    var coursesResponseByTerm = (coursesResponse[term] as List)
        .map((data) => CoursesUser.fromJson(data));
    await Future.forEach(coursesResponseByTerm, (CoursesUser element) async {
      if (element.courseId.substring(0, element.courseId.indexOf('>')) ==
          programmes[indexOfProg]
              .id
              .substring(0, programmes[indexOfProg].id.indexOf('-'))) {
        var ectsResponse = await http.get(
            Uri.parse("https://usos.ct8.pl/ects.php?CODE=" + element.courseId));
        element.setECTS((jsonDecode(ectsResponse.body))['ects']);
        await getGrade(term, element);
        userGrades.add(element);
      }
    });
    userGrades.sort((a, b) => a.name.compareTo(b.name));
    setState(() {
      _nowGrades = userGrades;
    });
  }

  Future refresh() async {
    setState(() {
      _nowGrades = null;
    });
    fetchCoursesByTerm(term);
  }

  void setTerm(int newTerm) {
    indexOfProg = newTerm;
    refresh();
  }

  void setProg(int newProg) {
    indexOfProg = newProg;
    refresh();
  }

  Future fetchTerms() async {
    try {
      var response = await client
          .get(Uri.parse(usosApi + 'services/courses/user?fields=terms'));
      final json = jsonDecode(response.body);
      terms =
          (json['terms'] as List).map((data) => Terms.fromJson(data)).toList();
      term = terms!.last.termId;
      setState(() {});
    } catch (_) {
      fetchTerms();
    }
    refresh();
  }

  void getData() {
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: programmes.isEmpty
            ? Text("USOS PŚ")
            : Text(programmes[indexOfProg].name),
        actions: [
          IconButton(
            onPressed: () => refresh(),
            icon: Icon(Icons.refresh),
          )
        ],
      ),
      drawer: Menu(nameUser, programmes, setProg),
      body: Column(
        children: [
          terms != null
              ? DropDownTerms(terms!, setTerm)
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
