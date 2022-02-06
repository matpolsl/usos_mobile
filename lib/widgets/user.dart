import 'dart:convert';
import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:flutter/material.dart';

import 'package:usos/models/terms.dart';
import 'package:usos/models/user_data.dart';
import 'package:usos/usos.dart';
import 'package:usos/widgets/grades.dart';

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
  late String term;
  @override
  void initState() {
    super.initState();
    nameUser = fetchName();

    terms = fetchTerms();
    getData();
  }

  Future<UserData> fetchName() async {
    return client.get(Uri.parse(usosApi + 'services/users/user')).then((res) {
      return UserData.fromJson(jsonDecode(res.body));
    });
  }

  //Future<List<CoursesUser>> fetchCoursesByLastTerm() async {
  //  var term = await terms;
  ///  return fetchCoursesByTerm(term.last.termId);
  //}

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

  Future getData() async {
    fetchTerms().then((result) {
      setState(() {
        term = result.last.termId;
      });
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
        Grades(client, term),
      ],
    );
  }
}
