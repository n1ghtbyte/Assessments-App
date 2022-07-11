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

final CollectionReference _assess =
    FirebaseFirestore.instance.collection('assessments');

class _AssessmentCheckState extends State<AssessmentCheck> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: _assess.doc(widget.passedAssessmentIdName).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (!snapshot.hasData) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          print(data['Students'].keys);
          var a = Map();

          List<String> studentsList = data['Students'].keys.toList();

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
              children: List.generate(studentsList.length, (index) {
                return Center(
                  child: Text(
                    '${studentsList[index]}',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                );
              }),
            ),
          );
        });
  }
}
