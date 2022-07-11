import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AssessmentCheck extends StatefulWidget {
  final String passedAssessmentIdName;

  const AssessmentCheck({Key? key, required this.passedAssessmentIdName})
      : super(key: key);

  @override
  State<AssessmentCheck> createState() => _AssessmentCheckState();
}

class _AssessmentCheckState extends State<AssessmentCheck> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review'),
        centerTitle: true,
        backgroundColor: Color(0xff29d092),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: null,
        backgroundColor: const Color(0xFF29D09E),
        label: Text('All'),
        icon: Icon(Icons.all_inclusive),
      ),
      body: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 3,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(12, (index) {
          return Center(
            child: Text(
              'Item $index',
              style: Theme.of(context).textTheme.headline5,
            ),
          );
        }),
      ),
    );
  }
}
