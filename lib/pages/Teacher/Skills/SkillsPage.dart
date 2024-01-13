import "package:assessments_app/utils/Competences.dart";

import 'package:assessments_app/pages/Teacher/Skills/CompetencePicked.dart';
import 'package:assessments_app/pages/Teacher/Skills/SkillsCreatePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'dart:convert';

class SkillsPage extends StatefulWidget {
  @override
  State<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> {
  final CollectionReference _competences =
      FirebaseFirestore.instance.collection(getCompetencesPath());

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
                title: Text(AppLocalizations.of(context)!.competences),
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
                            textColor: Color(0xFF29D09E),
                            visualDensity: VisualDensity.standard,
                            trailing: Wrap(
                              direction: Axis.horizontal,
                              spacing: 10,
                              children: [
                                IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                                  title:
                                                      Text("Remove Competence"),
                                                  content: Text(
                                                      'Remove the indicators regarding this competence forever?'),
                                                  actions: [
                                                    TextButton(
                                                      style: ButtonStyle(
                                                        foregroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(
                                                                    Colors
                                                                        .blue),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .cancel),
                                                    ),
                                                    TextButton(
                                                      style: ButtonStyle(
                                                        foregroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(
                                                                    Colors
                                                                        .blue),
                                                      ),
                                                      child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .delete),
                                                      onPressed: () async {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection("users")
                                                            .doc(currentUser)
                                                            .collection(
                                                                'PrivateCompetences')
                                                            .doc(data['Name'])
                                                            .delete()
                                                            .then(
                                                              (doc) => print(
                                                                  "Document deleted"),
                                                              onError: (e) => print(
                                                                  "Error updating document $e"),
                                                            );
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                      },
                                                    ),
                                                  ]));

                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CompetencePicked(
                                                passedComp: data,
                                                passedName: data['Name'],
                                                editable: true,
                                              ),
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                            Icons.arrow_circle_right_rounded),
                                      );
                                    })
                              ],
                            ),
                            title: Text(
                              data['Name'],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CompetencePicked(
                                    passedComp: data,
                                    passedName: data['Name'],
                                    editable: true,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ).toList() +
                      snapshot.data!.docs.map(
                        (DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return ListTile(
                            visualDensity: VisualDensity.standard,
                            trailing: Wrap(
                              direction: Axis.horizontal,
                              spacing: 10,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CompetencePicked(
                                            passedComp: data,
                                            passedName: data['Name'],
                                            editable: false,
                                          ),
                                        ),
                                      );
                                    },
                                    icon:
                                        Icon(Icons.arrow_circle_right_rounded)),
                              ],
                            ),
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
