import 'package:assessments_app/pages/Teacher/Skills/CompetencePicked.dart';
import 'package:assessments_app/pages/Teacher/Skills/SkillsCreatePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SkillsPage extends StatefulWidget {
  @override
  State<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> {
  final CollectionReference _competences =
      FirebaseFirestore.instance.collection('Competences');

  String? currentUser = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: _competences.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser)
              .collection('PrivateCompetences')
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshotprivate) {
            if (snapshotprivate.hasError) {
              return Text("Something went wrong");
            }
            if (!snapshotprivate.hasData) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return Scaffold(
              appBar: AppBar(
                title: Text('Competences'),
                centerTitle: true,
                backgroundColor: Color(0xFF29D09E),
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                backgroundColor: Color(0xFF29D09E),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SkillsCreatePage(),
                    ),
                  );
                },
              ),
              body: SafeArea(
                child: ListView(
                  children: snapshotprivate.data!.docs.map(
                        (DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return ListTile(
                            visualDensity: VisualDensity.standard,
                            onTap: () {
                              print(data);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CompetencePicked(
                                    passedComp: data,
                                    name: data['Name'],
                                  ),
                                ),
                              );
                            },
                            trailing: Icon(Icons.arrow_circle_right_rounded),
                            title: Text(
                              data['Name'],
                            ),
                          );
                        },
                      ).toList() +
                      snapshot.data!.docs.map(
                        (DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return ListTile(
                            visualDensity: VisualDensity.standard,
                            onTap: () {
                              print(data);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CompetencePicked(
                                    passedComp: data,
                                    name: data['Name'],
                                  ),
                                ),
                              );
                            },
                            trailing: Icon(Icons.arrow_circle_right_rounded),
                            title: Text(
                              data['Name'],
                            ),
                          );
                        },
                      ).toList(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
