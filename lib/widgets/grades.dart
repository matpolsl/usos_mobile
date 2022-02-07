import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:usos/widgets/mean_grades.dart';

import 'package:usos/widgets/subject.dart';
import 'package:usos/models/courses_user.dart';
import 'package:usos/usos.dart';

class Grades extends StatefulWidget {
  Grades(this._nowGrades, {Key? key}) : super(key: key);
  List<CoursesUser> _nowGrades;
  @override
  _GradesState createState() => _GradesState(_nowGrades);
}

class _GradesState extends State<Grades> {
  late oauth1.Client client;
  late String term;
  _GradesState(this._nowGrades);

  final List<CoursesUser> _nowGrades;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (ctx, index) => Subject(_nowGrades[index]),
                    itemCount: _nowGrades.length,
                  ),
                ),
              ],
            ),
          ),
          GradesMean(_nowGrades),
        ],
      ),
    );
  }
}
