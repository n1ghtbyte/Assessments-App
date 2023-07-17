import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:assessments_app/assets/group_radio_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import "package:assessments_app/utils/Competences.dart";

class AssessmentSelf extends StatefulWidget {
  final String passedAssessmentIdName;
  const AssessmentSelf({Key? key, required this.passedAssessmentIdName})
      : super(key: key);
  @override
  _AssessmentSelfState createState() => _AssessmentSelfState();
}

class _AssessmentSelfState extends State<AssessmentSelf> {
  String? currentUser = FirebaseAuth.instance.currentUser!.email;

  Future<void> addGrade(String stud, Map<dynamic, Map<dynamic, dynamic>> comp,
      var assessinfo, String _id) {
    late CollectionReference assessments = FirebaseFirestore.instance
        .collection('classes')
        .doc(assessinfo['ClassId'].toString())
        .collection("grading")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("self");

    // Call the user's CollectionReference to add a new assessment
    return assessments.add({
      'Created': FieldValue.serverTimestamp(),
      'ClassName': assessinfo['ClassId'],
      'Creator': currentUser,
      'Type': "Self",
      'Competences': comp,
      'AssessID': _id,
      'Name': assessinfo['Name'],
    }).then((value) {
      print(value.id);
    });
  }

  String? number; //no radio button will be selected
  Map<dynamic, Map<dynamic, dynamic>> _mapao = {};
  Map<dynamic, dynamic> kek = Map();
  Map<dynamic, dynamic> _mapinha = {};
  Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection(getCompetencesPath()).snapshots();

  final CollectionReference _assess =
      FirebaseFirestore.instance.collection('assessments');

  Future<void> updateAssessment(String _docid) {
    return _assess
        .doc(_docid)
        .update({
          'DONE': true,
        })
        .then((value) => print("Assessment Updated"))
        .catchError((error) => print("Failed to update assessment: $error"));
  }

  List<String> textifier(List<dynamic>? x) {
    return x!.cast<String>();
  }

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

        return StreamBuilder<QuerySnapshot>(
          stream: _stream,
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
            //Competencias default
            Map<String, List<dynamic>> _comps = {};
            for (var i = 0; i < 11; i++) {
              Map<String, dynamic> foo =
                  snp.data?.docs[i].data()! as Map<String, dynamic>;
              for (var f in foo.keys) {
                if (f.toString() != "Name") {
                  _comps[f.toString()] = foo[f.toString()];
                }
              }
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

                for (var i = 0; i < snapshotprivate.data!.docs.length; i++) {
                  Map<String, dynamic> foo = snapshotprivate.data?.docs[i]
                      .data()! as Map<String, dynamic>;
                  for (var f in foo.keys) {
                    if (f.toString() != "Name") {
                      _comps[f.toString()] = foo[f.toString()];
                    }
                  }
                }

                String stud = data['Students'][0];
                var assesId = data['documentID'];

                //List<bool> isChecked = List<bool>.filled(50, false);
                var _indicators = [];
                List<String> namesC = [];
                List<String> allIndicators = [];

                var namesComp = data['Competences'].keys;
                for (var t in namesComp) {
                  namesC.add(t);
                }

                for (var x in data['Competences'].values) {
                  _indicators.add(x);
                }

                for (var i in _indicators) {
                  for (var j in i) {
                    allIndicators.add(j);
                  }
                }

                return Scaffold(
                  appBar: AppBar(
                    title: Text(stud.toString()),
                    centerTitle: true,
                    backgroundColor: Color(0xFF29D09E),
                  ),
                  floatingActionButton: FloatingActionButton.extended(
                    backgroundColor: const Color(0xFF29D09E),
                    heroTag: "btn2",
                    onPressed: () {
                      for (var ent in _mapinha.keys) {
                        _mapinha[ent] =
                            _mapinha[ent].toString().substring(0, 1);
                      }
                      print("-----------------------------------------");
                      for (var skill in _mapao.keys) {
                        _mapao[skill]?.updateAll(
                            ((key, value) => value = value.substring(0, 1)));
                      }
                      if (_mapinha.values.length == allIndicators.length) {
                        print(_mapao.keys.length);
                        print(allIndicators.length);
                        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");

                        // print(uploadComps);
                        addGrade(stud, _mapao, data, assesId);

                        updateAssessment(widget.passedAssessmentIdName);

                        Navigator.pop(context);
                      } else {
                        print("DSDS");
                        print(_mapinha.values.length);

                        print(allIndicators.length);
                        final snackBar = SnackBar(
                            content: Text(
                                AppLocalizations.of(context)!.forgotassess));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    icon: Icon(Icons.skip_next),
                    label: Text(AppLocalizations.of(context)!.next),
                  ),
                  body: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          for (var k in namesC)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    k,
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  for (String x in List<String>.from(
                                      data['Competences'][k] as List))
                                    Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Column(
                                        children: <Widget>[
                                          Divider(
                                            height: 4,
                                          ),
                                          Text(
                                            x,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          RadioGroup<String>.builder(
                                            spacebetween: 65.0,
                                            direction: Axis.vertical,
                                            groupValue: _mapinha[x.toString()]
                                                .toString(),
                                            horizontalAlignment:
                                                MainAxisAlignment.start,
                                            onChanged: (value) {
                                              setState(
                                                () {
                                                  _mapinha[x.toString()] =
                                                      value.toString();
                                                  if (_mapao[k.toString()] !=
                                                      null) {
                                                    _mapao[k.toString()]![
                                                            x.toString()] =
                                                        value.toString();
                                                  } else {
                                                    _mapao[k.toString()] =
                                                        Map();
                                                  }
                                                  _mapao[k.toString()]![
                                                          x.toString()] =
                                                      value.toString();

                                                  print(_mapao.toString());
                                                },
                                              );
                                            },
                                            activeColor: Color(0xFF29D09E),
                                            items: textifier(_comps[x]),
                                            textStyle: TextStyle(
                                              fontSize: 14,
                                            ),
                                            itemBuilder: (item) =>
                                                RadioButtonBuilder(
                                                    item.toString(),
                                                    textPosition:
                                                        RadioButtonTextPosition
                                                            .left),
                                          ),
                                        ],
                                      ),
                                    )
                                ],
                              ),
                            ),
                          SizedBox(
                            height: 32,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
