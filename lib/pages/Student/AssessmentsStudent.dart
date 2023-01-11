import 'package:flutter/material.dart';

class AssessmentsStudentAll extends StatefulWidget {
  AssessmentsStudentAll({Key? key}) : super(key: key);
  @override
  _AssessmentsStudentAllState createState() => _AssessmentsStudentAllState();
}

class _AssessmentsStudentAllState extends State<AssessmentsStudentAll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assessments'),
        centerTitle: true,
        backgroundColor: Color(0xFF29D09E),
      ),
      body: Center(
        child: Text(
          "Assessments will be displayed here, once they have been issues to you :)",
          style: TextStyle(fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
