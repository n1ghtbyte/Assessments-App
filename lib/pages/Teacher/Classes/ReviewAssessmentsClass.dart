import 'package:assessments_app/pages/Teacher/AssessmentFormative.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewAssessments extends StatefulWidget {
  ReviewAssessments({Key? key}) : super(key: key);
  @override
  _ReviewAssessmentsState createState() => _ReviewAssessmentsState();
}

class _ReviewAssessmentsState extends State<ReviewAssessments> {
  final _classesStream = FirebaseFirestore.instance
      .collection('assessments')
      .where('Creator', isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _classesStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.data?.size.toInt() == 0) {
            return MaterialApp(
              home: Scaffold(
                  appBar: AppBar(
                    title: Text('Review Assessments'),
                    centerTitle: true,
                    backgroundColor: Color(0xFF29D09E),
                  ),
                  body: Center(
                    child: Text(
                      "Assessments will be displayed here, once they are completed",
                      style: TextStyle(fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  )),
            );
          } else {
            return MaterialApp(
              home: Scaffold(
                appBar: AppBar(
                  title: Text('Review Assessments'),
                  centerTitle: true,
                  backgroundColor: Color(0xFF29D09E),
                ),
                body: ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;

                    return ListTile(
                      onTap: () {
                        if (data['Type'] == 'Formative') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AssessmentFormative(
                                      passedAssessmentIdName:
                                          data['documentID'],
                                    )),
                          );
                        }
                      },
                      leading: Icon(Icons.assessment),
                      isThreeLine: true,
                      enabled: data['DONE'] == true,
                      title: Text('${data['Type']} Assessment'),
                      subtitle: Text(
                          "Class Name:${data['ClassName'].toString()}\nCount:${data['Count'].toString()}/${data['Students'].values.toList().length}\nNumber:${data['currentNumber'].toString()}"),
                    );
                  }).toList(),
                ),
              ),
            );
          }
        });
  }
}
