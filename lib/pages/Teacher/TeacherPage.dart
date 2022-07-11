import 'package:assessments_app/InovWidgets/NavBarTeacher.dart';
import 'package:assessments_app/pages/Teacher/AssessmentCheck.dart';
import 'package:assessments_app/pages/Teacher/AssessmentFormative.dart';
// import 'package:assessments_app/pages/Teacher/AssessmentFormative.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TeacherPage extends StatefulWidget {
  TeacherPage({Key? key}) : super(key: key);
  @override
  _TeacherPageState createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
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
                  drawer: NavBarTeacher(),
                  appBar: AppBar(
                    title: Text('Feed'),
                    centerTitle: true,
                    backgroundColor: Color(0xFF29D09E),
                  ),
                  body: Center(
                    child: Text(
                      "Assessments will be displayed here, once they are generated",
                      style: TextStyle(fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  )),
            );
          } else {
            return MaterialApp(
              home: Scaffold(
                drawer: NavBarTeacher(),
                appBar: AppBar(
                  title: Text('Assessments'),
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
                        if (data['Type'] == 'Formative' &&
                            data['DONE'] == false) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AssessmentFormative(
                                      passedAssessmentIdName:
                                          data['documentID'],
                                    )),
                          );
                        }
                        if (data['Type'] == 'Formative' &&
                            data['DONE'] == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AssessmentCheck(
                                      passedAssessmentIdName:
                                          data['documentID'],
                                    )),
                          );
                        }
                      },
                      leading: Icon(Icons.assessment),
                      isThreeLine: true,
                      textColor: data['DONE'] == false
                          ? Color(0xFF29D09E)
                          : Color.fromARGB(255, 123, 123, 123),
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
