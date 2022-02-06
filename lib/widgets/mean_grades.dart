import 'package:flutter/material.dart';
import 'package:usos/models/courses_user.dart';

class GradesMean extends StatefulWidget {
  GradesMean(this.grades, {Key? key}) : super(key: key);
  late List<CoursesUser>? grades;

  @override
  _GradesMeanState createState() => _GradesMeanState(grades);
}

class _GradesMeanState extends State<GradesMean> {
  late List<CoursesUser>? grades;
  _GradesMeanState(this.grades);
  double mean(List<CoursesUser>? grades) {
    var sum = 0.0;
    var sumECTS = 0;
    for (var item in grades!) {
      if (item.grade != null) {
        sum += item.grade! * item.ects!;
        sumECTS += item.ects!;
      }
    }
    return sum / sumECTS;
  }

  String ects(List<CoursesUser>? grades) {
    var sum = 0;
    var sumECTS = 0;
    for (var item in grades!) {
      if (item.grade != null) {
        sum += item.ects!;
      }
      sumECTS += item.ects!;
    }
    return "${sum}/${sumECTS}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 2,
        ),
      ),
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(10),
      child: Row(
        children: [
          Text(
            "Średnia: " + mean(grades).toStringAsFixed(2),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Text(
            "ECTS: " + ects(grades),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.blue[900],
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
    );
  }
}
