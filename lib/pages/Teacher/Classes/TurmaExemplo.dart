import 'package:assessments_app/pages/Teacher/Assessments/AssessmentsCreateTeacherPage.dart';
import 'package:assessments_app/pages/Teacher/Classes/AddStudentClass.dart';
import 'package:assessments_app/pages/Teacher/Classes/AstaStats.dart';
import 'package:assessments_app/pages/Teacher/Classes/ClassSetup.dart';
import 'package:assessments_app/pages/Teacher/Classes/ClassesSettingsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum _MenuValues {
  AddStuddent,
  Setup,
  Settings,
}

class TurmaExemplo extends StatefulWidget {
  final String passedClassName;

  const TurmaExemplo(this.passedClassName);

  @override
  State<TurmaExemplo> createState() => _TurmaExemploState();
}

class _TurmaExemploState extends State<TurmaExemplo> {
  @override
  Widget build(BuildContext context) {
    late CollectionReference _class =
        FirebaseFirestore.instance.collection('classes');
    Map<dynamic, dynamic> namedStuds = {};

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
          if (data['StudentList'].isEmpty) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Class ${data['Name'].toString()}"),
                centerTitle: true,
                backgroundColor: Color(0xFF29D09E),
                actions: [
                  // IconButton(icon: new Icon(Icons.more_vert), onPressed:  () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => ClassesSettingsPage()),
                  //     );
                  //   },

                  PopupMenuButton<_MenuValues>(
                    icon: Icon(Icons.more_vert),
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        child: Text('Add a Student'),
                        value: _MenuValues.AddStuddent,
                      ),
                      PopupMenuItem(
                        child: Text('Setup'),
                        value: _MenuValues.Setup,
                      ),
                      PopupMenuItem(
                        child: Text('Settings'),
                        value: _MenuValues.Settings,
                      ),
                    ],
                    onSelected: (value) {
                      switch (value) {
                        case _MenuValues.AddStuddent:
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (c) =>
                                  AddStudentToClass(widget.passedClassName)));
                          break;
                        case _MenuValues.Settings:
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (c) => ClassesSettingsPage()));
                          break;
                        case _MenuValues.Setup:
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (c) => ClassSetup(
                                    passedClassNameSetup:
                                        widget.passedClassName,
                                  )));
                          break;
                      }
                    },
                  ),
                ],
              ),
              body: Center(
                child: Text(
                  "Your students will appear here, once they have join this class\n Do not forget to setup the weights of each competence! (Pro tip: up right corner)",
                  style: TextStyle(fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> snp) {
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
                // print(x);
                // print(snp.data?.docs);
                List<dynamic> studs = data['StudentList'];
                print(studs);
                //print(x);

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

                Map competences = data['Competences'];
                //print(data['StudentsList'].runtimeType);
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Class ${data['Name'].toString()}"),
                    centerTitle: true,
                    actions: [
                      // IconButton(icon: new Icon(Icons.more_vert), onPressed:  () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(builder: (context) => ClassesSettingsPage()),
                      //     );
                      //   },

                      PopupMenuButton<_MenuValues>(
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem(
                            child: Text('Add a Student'),
                            value: _MenuValues.AddStuddent,
                          ),
                          PopupMenuItem(
                            child: Text('Setup'),
                            value: _MenuValues.Setup,
                          ),
                          PopupMenuItem(
                            child: Text('Settings'),
                            value: _MenuValues.Settings,
                          ),
                        ],
                        onSelected: (value) {
                          switch (value) {
                            case _MenuValues.AddStuddent:
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (c) => AddStudentToClass(
                                      widget.passedClassName)));
                              break;
                            case _MenuValues.Settings:
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (c) => ClassesSettingsPage()));
                              break;
                            case _MenuValues.Setup:
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (c) => ClassSetup(
                                        passedClassNameSetup:
                                            widget.passedClassName,
                                      )));
                              break;
                          }
                        },
                      ),
                    ],
                    backgroundColor: Color(0xFF29D09E),
                  ),
                  floatingActionButton: FloatingActionButton(
                      child: Icon(Icons.assessment),
                      backgroundColor: Color(0xFF29D09E),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AssessmentsCreateTeacherPage(
                                        widget.passedClassName,
                                        data['Name'].toString(),
                                        competences,
                                        "null")));
                      }),
                  body: SafeArea(
                    child: ListView.builder(
                      itemCount: studs.length,
                      itemBuilder: (context, index) => Card(
                        elevation: 8,
                        margin: EdgeInsets.all(7),
                        child: ListTile(
                          //     title: FirebaseFirestore.instance
                          // .collection("users")
                          // .doc(studs[index].toString())
                          // .get()
                          // .then((value) => Text(value.data().toString())),
                          title: Text(
                              namedStuds[studs[index].toString()].toString()),
                          // title: Text(FirebaseFirestore.instance
                          //     .collection('users')
                          //     .doc(studs[index].toString())
                          //     .id),
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => AstaStats(
                            //         passedClassID:
                            //             widget.passedClassName.toString(),
                            //         passedStudentName: studs[index].toString(),
                            //         passedCompetences: competences,
                            //         passedClassName: data['Name'].toString()),
                            //   ),
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AstaStats(
                                    passedClassID:
                                        widget.passedClassName.toString(),
                                    passedStudentName:
                                        namedStuds[studs[index].toString()],
                                    passedCompetences: competences,
                                    passedClassName: data['Name'].toString(),
                                    passedEmail: studs[index].toString()),
                              ),
                            );
                          },
                          // subtitle: Text(studs[index]["subtitle"]),
                          // trailing: Icon(Icons.add_a_photo),
                        ),
                      ),
                    ),
                  ),
                );
              });
        });
  }
}
