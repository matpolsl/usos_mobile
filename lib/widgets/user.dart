import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:usos/models/courses_user.dart';
import 'package:usos/models/terms.dart';
import 'package:usos/models/user_data.dart';

import 'package:usos/usos.dart';
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
          userGrades.add(CoursesUser(
            courseId: element.courseId,
            name: element.name,
            grade: json[0]['1'] == null
                ? null
                : double.parse(json[0]['1']['value_symbol']),
          ));
          print(userGrades.last.name + " " + userGrades.last.grade.toString());
        });
      });
    });
    return userGrades;
  }

  Future<List<CoursesUser>> fetchCoursesByLastTerm() async {
    var terms = await fetchTerms();
    return fetchCoursesByTerm(terms.last.termId);
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
              // WHILE THE CALL IS BEING MADE AKA LOADING
              if (ConnectionState.active != null && !snapshot.hasData) {
                return Center(child: Text('Loading'));
              }

              // WHEN THE CALL IS DONE BUT HAPPENS TO HAVE AN ERROR
              if (ConnectionState.done != null && snapshot.hasError) {
                return Center(child: Text("Błąd"));
              }

              // IF IT WORKS IT GOES HERE!

              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Row(
                      children: [
                        Text(snapshot.data![index].name + " "),
                        snapshot.data![index].grade != null
                            ? Text(snapshot.data![index].grade.toString())
                            : Text(""),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
