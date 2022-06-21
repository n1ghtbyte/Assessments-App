import 'package:flutter/material.dart';

class AssessmentsTeacherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assessments'),
        centerTitle: true,
        backgroundColor: Color(0xFF29D09E),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => AssessmentsCreateTeacherPage()),
          // );
        },
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: const <Widget>[],
      ),
    );
  }
}
