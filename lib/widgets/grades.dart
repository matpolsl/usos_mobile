import 'package:flutter/material.dart';

import 'package:usos/widgets/mean_grades.dart';
import 'package:usos/widgets/subject.dart';
import 'package:usos/models/courses_user.dart';

class Grades extends StatelessWidget {
  const Grades(this._nowGrades, {Key? key}) : super(key: key);
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
