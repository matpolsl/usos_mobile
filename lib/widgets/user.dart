import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:usos/models/courses_user.dart';
import 'package:usos/models/terms.dart';
import 'package:usos/models/user_data.dart';

import 'package:usos/usos.dart';
import 'package:usos/widgets/subject.dart';
import 'login.dart';

class User extends StatefulWidget {
  User(this.client, {Key? key}) : super(key: key);
  late oauth1.Client client;
  @override
  _UserState createState() => _UserState(client);
}

class _UserState extends State<User> {
  late oauth1.Client client;
  late Future<UserData> nameUser;
  late Future<Map<String, dynamic>> courses;
  late Future<List<Terms>> terms;
  _UserState(this.client);
  late Future<List<CoursesUser>> _nowCourses;

  @override
  void initState() {
    super.initState();
    nameUser = fetchName();
    courses = fetchCourses();
    terms = fetchTerms();
    _nowCourses = fetchCoursesByLastTerm();
  }

  Future<UserData> fetchName() async {
    return client.get(Uri.parse(usosApi + 'services/users/user')).then((res) {
      return UserData.fromJson(jsonDecode(res.body));
    });
  }

  Future<List<CoursesUser>> fetchCoursesByTerm(term) async {
    List<CoursesUser> userGrades = [];
    fetchCourses().then((value) {
      (value[term] as List)
          .map((data) => CoursesUser.fromJson(data))
          .forEach((element) {
        client
            .get(Uri.parse(usosApi +
                'services/grades/course_edition2?course_id=' +
                element.courseId +
                '&term_id=' +
                term))
            .then((res) {
          final json = (jsonDecode(res.body))['course_grades'] as List;
          print("https://usos.ct8.pl/ects.php?CODE=" + element.courseId);
          http
              .get(Uri.parse(
                  "https://usos.ct8.pl/ects.php?CODE=" + element.courseId))
              .then((res) {
            final ects = (jsonDecode(res.body))['ects'];
            print(ects);
            userGrades.add(CoursesUser(
              courseId: element.courseId,
              name: element.name,
              grade: json[0]['1'] == null
                  ? null
                  : double.parse(json[0]['1']['value_symbol']),
              ects: ects,
            ));
            print(
                userGrades.last.name + " " + userGrades.last.grade.toString());
          });
        });
      });
    });
    return userGrades;
  }

  Future<List<CoursesUser>> fetchCoursesByLastTerm() async {
    var term = await terms;
    return fetchCoursesByTerm(term.last.termId);
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

  Future<List<Terms>> fetchTerms() async {
    return client
        .get(Uri.parse(usosApi + 'services/courses/user?fields=terms'))
        .then((res) {
      final json = jsonDecode(res.body);
      return (json['terms'] as List)
          .map((data) => Terms.fromJson(data))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<UserData>(
          future: nameUser,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                  snapshot.data!.firstName + " " + snapshot.data!.lastName);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
        //testy

        SizedBox(
          height: 500,
          child: FutureBuilder<List<CoursesUser>>(
            future: _nowCourses,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Subject(snapshot.data![index]);
                    });
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {});
          },
          child: Text('Refresh'),
        ),
      ],
    );
  }
}
