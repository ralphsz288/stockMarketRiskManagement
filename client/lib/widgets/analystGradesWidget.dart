import 'package:flutter/material.dart';

class AnalystGrades extends StatelessWidget {
  final String gradingCompany;
  final String newGrade;
  final String previousGrade;
  final String date;
  const AnalystGrades({Key? key,required this.gradingCompany,required this.newGrade,required this.previousGrade,required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15,),
        Text("Grading company: " + gradingCompany,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
        Text("New grade: " + newGrade,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
        Text("Previous grade: " + previousGrade,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
        Text("Date: " + date,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),

      ],
    );
  }
}
