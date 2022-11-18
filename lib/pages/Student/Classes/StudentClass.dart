import 'package:assessments_app/pages/Teacher/Assessments/GenSummAssessment.dart';
import 'package:assessments_app/pages/Teacher/Classes/AstaGraphs.dart';
import 'package:assessments_app/pages/Teacher/Classes/ReviewAssessmentsClass.dart';
import 'package:assessments_app/pages/Teacher/Classes/AddStudentClass.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:assessments_app/pages/Teacher/Assessments/GenFormAssessment.dart';

import 'package:assessments_app/pages/Teacher/Classes/ClassSetup.dart';
import 'package:assessments_app/pages/Teacher/Classes/ClassesSettingsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum _MenuValues {
  Settings,
}

class StudentClass extends StatefulWidget {
  final String passedClassName;

  const StudentClass(this.passedClassName);

  @override
  State<StudentClass> createState() => _StudentClassState();
}

class _StudentClassState extends State<StudentClass> {
  @override
  Widget build(BuildContext context) {
    late CollectionReference _class =
        FirebaseFirestore.instance.collection('classes');
    Map<dynamic, dynamic> namedStuds = {};

    ValueNotifier<bool> isDialOpen = ValueNotifier(false);

    return FutureBuilder<DocumentSnapshot>(
      future: _class.doc(widget.passedClassName).get(),
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

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snp) {
            if (snp.hasError) {
              return Text('Something went wrong');
            }

            if (snp.connectionState == ConnectionState.waiting) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            var x = snp.data?.size;
            List<dynamic> studs = data['StudentList'];
            print("::::::::::::::::::");
            print(studs);

            for (var i = 0; i < x!; i++) {
              Map<String, dynamic> foo =
                  snp.data?.docs[i].data()! as Map<String, dynamic>;
              print(foo);
              if (studs.contains(foo['Email'])) {
                print(foo);
                print(i);

                namedStuds[foo['Email'].toString()] =
                    foo['FirstName'].toString() +
                        " " +
                        foo['LastName'].toString();
              }
            }
            print(namedStuds);
            for (var i in studs) {
              if (!namedStuds.containsKey(i)) {
                namedStuds[i.toString()] = i.toString();
              }
            }
            studs.sort((a, b) {
              //sorting in descending order
              return a.compareTo(b);
            });
            Map competences = data['Competences'];
            //print(data['StudentsList'].runtimeType);
            return Scaffold(
              appBar: AppBar(
                title: Text("Class ${data['Name'].toString()}"),
                centerTitle: true,
                actions: [
                  PopupMenuButton<_MenuValues>(
                    icon: Icon(Icons.more_vert),
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        child: Text('Settings'),
                        value: _MenuValues.Settings,
                      ),
                    ],
                    onSelected: (value) {
                      switch (value) {
                        case _MenuValues.Settings:
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (c) =>
                                  ClassesSettingsPage(widget.passedClassName),
                            ),
                          );
                          break;
                      }
                    },
                  ),
                ],
                backgroundColor: Color(0xFF29D09E),
              ),
              // floatingActionButton: SpeedDial(
              //   icon: Icons.assessment,
              //   activeIcon: Icons.arrow_back,
              //   spacing: 5,
              //   openCloseDial: isDialOpen,
              //   curve: Curves.bounceInOut,
              //   childPadding: const EdgeInsets.all(5),
              //   spaceBetweenChildren: 4,
              //   backgroundColor: Color(0xFF29D09E),
              //   foregroundColor: Color.fromARGB(255, 255, 255, 255),
              //   overlayColor: Colors.black,
              //   elevation: 8.0,
              //   onOpen: () => debugPrint('OPENING DIAL'),
              //   onClose: () => debugPrint('DIAL CLOSED'),
              //   shape: CircleBorder(),
              //   children: [
              //     SpeedDialChild(
              //       child: Icon(Icons.summarize),
              //       backgroundColor: Color(0xFF29D09E),
              //       label: 'Summative',
              //       elevation: 5.0,
              //       onTap: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) =>
              //                 GenSummAssessment(widget.passedClassName),
              //           ),
              //         );
              //       },
              //     ),
              //     SpeedDialChild(
              //         child: Icon(Icons.self_improvement),
              //         backgroundColor: Color.fromARGB(135, 41, 208, 158),
              //         label: 'Self',
              //         elevation: 5.0),
              //     SpeedDialChild(
              //         child: Icon(Icons.group),
              //         backgroundColor: Color.fromARGB(135, 41, 208, 158),
              //         label: 'Peer',
              //         elevation: 5.0),
              //     SpeedDialChild(
              //       child: Icon(Icons.quiz),
              //       backgroundColor: Color(0xFF29D09E),
              //       label: 'Formative',
              //       elevation: 5.0,
              //       onTap: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => GenFormAssessment(
              //                 widget.passedClassName,
              //                 data['Name'].toString(),
              //                 competences,
              //                 "null"),
              //           ),
              //         );
              //       },
              //     ),
              //   ],
              // ),
              body: SafeArea(
                child: ListView.builder(
                  itemCount: studs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title:
                          Text(namedStuds[studs[index].toString()].toString()),
                      subtitle:
                          studs[index] == namedStuds[studs[index].toString()]
                              ? Text("Has no account")
                              : Text(studs[index]),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AstaGraphs(
                              passedClassName: data['Name'],
                              passedClassId: data['documentID'],
                              passedLegitName: namedStuds[studs[index]],
                              passedEmail: studs[index],
                              passedCompetences: competences,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
