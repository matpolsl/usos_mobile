import 'package:flutter/material.dart';
import 'package:usos/models/courses_user.dart';

class Subject extends StatelessWidget {
  CoursesUser course;
  Subject(this.course, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          child: Column(
            children: [
              Text(
                course.grade != null ? course.grade!.toStringAsFixed(1) : "?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.purple,
                ),
              ),
              Text(
                "ECTS: ${course.ects.toString()}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          margin: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.purple,
              width: 2,
            ),
          ),
          padding: EdgeInsets.all(10),
        ),
        Flexible(
          child: Column(
            children: [
              Text(
                course.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ),
      ],
    );
  }
}
