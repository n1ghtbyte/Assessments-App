import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:assessments_app/assets/group_radio_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AssessmentFormative extends StatefulWidget {
  final String passedAssessmentIdName;
  const AssessmentFormative({Key? key, required this.passedAssessmentIdName})
      : super(key: key);
  @override
  _AssessmentFormativeState createState() => _AssessmentFormativeState();
}

class _AssessmentFormativeState extends State<AssessmentFormative> {
  String? currentUser = FirebaseAuth.instance.currentUser!.email;

  Future<void> addGrade(String stud, Map<dynamic, Map<dynamic, dynamic>> comp,
      var currAssess, var assessinfo, String _id) {
    late CollectionReference assessments = FirebaseFirestore.instance
        .collection('classes')
        .doc(assessinfo['ClassId'].toString())
        .collection("grading")
        .doc(stud.toString())
        .collection("formative");

    // Call the user's CollectionReference to add a new assessment
    return assessments.add({
      'Created': FieldValue.serverTimestamp(),
      'ClassName': assessinfo['ClassId'],
      'Creator': currentUser,
      'Current': currAssess,
      'Type': "Formative",
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
      FirebaseFirestore.instance.collection('CompetencesPT').snapshots();

  final CollectionReference _assess =
      FirebaseFirestore.instance.collection('assessments');

  Future<void> updateAssessment(
      String _docid, Map _alumni, var data, bool done) {
    return _assess
        .doc(_docid)
        .update({
          'Students': _alumni,
          'DONE': done,
          'Count': data['Count'] + 1,
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

                List studsToAssess = [];

                Map studs = data['Students'];
                var assesId = data['documentID'];

                studs.forEach((key, value) {
                  if (value == false) studsToAssess.add(key);
                });

                var currentStudent = studsToAssess[0];

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
                    title: Text(currentStudent.toString()),
                    centerTitle: true,
                    backgroundColor: Color(0xFF29D09E),
                  ),
                  floatingActionButton: Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        FloatingActionButton(
                          heroTag: "btn1",
                          onPressed: () {
                            print(_mapao.toString());
                            print(_mapinha.toString());
                            for (var foo in _mapao.keys) {
                              _mapao[foo] = {};
                            }
                            _mapinha = {};
                            setState(
                              () {},
                            );

                            print(_mapao.toString());
                            print(_mapinha.toString());
                          },
                          child: Icon(Icons.clear),
                          backgroundColor: Color(0xFF29D09E),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(child: Container()),
                        FloatingActionButton.extended(
                          backgroundColor: const Color(0xFF29D09E),
                          heroTag: "btn2",
                          onPressed: () {
                            for (var ent in _mapinha.keys) {
                              _mapinha[ent] =
                                  _mapinha[ent].toString().substring(0, 1);
                            }
                            print("-----------------------------------------");
                            for (var skill in _mapao.keys) {
                              _mapao[skill]?.updateAll(((key, value) =>
                                  value = value.substring(0, 1)));
                            }
                            if (_mapinha.values.length ==
                                allIndicators.length) {
                              print(_mapao.keys.length);
                              print(allIndicators.length);
                              studs[currentStudent] = true;
                              print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");

                              // print(uploadComps);
                              addGrade(
                                  currentStudent,
                                  _mapao,
                                  data['currentNumber'].toString(),
                                  data,
                                  assesId);
                              bool x = true;
                              for (var k in studs.values) {
                                if (k == false) x = false;
                              }
                              updateAssessment(widget.passedAssessmentIdName,
                                  studs, data, x);
                              if (x == true) {
                                FirebaseFirestore.instance
                                    .collection('classes')
                                    .doc(data['ClassId'])
                                    .update({
                                  'prevAssess': FieldValue.increment(1)
                                });
                                Navigator.pop(context);
                              } else {
                                print(studs);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            super.widget));
                              }
                            } else {
                              print("DSDS");
                              print(_mapinha.values.length);

                              print(allIndicators.length);
                              final snackBar = SnackBar(
                                  content: Text(AppLocalizations.of(context)!
                                      .forgotassess));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          icon: Icon(Icons.skip_next),
                          label: Text(AppLocalizations.of(context)!.next),
                        ),
                      ],
                    ),
                  ),
                  body: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              "${AppLocalizations.of(context)!.student}: $currentStudent\n${AppLocalizations.of(context)!.classConcept}: ${data['ClassName']}\n${AppLocalizations.of(context)!.count}: ${data['Count']}/${studs.length}\n",
                              style: TextStyle(fontSize: 26),
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                            ),
                            onPressed: () {
                              for (var comp in namesC) {
                                _mapao[comp] = {};
                                for (var ind in data['Competences'][comp]) {
                                  print(ind);
                                  _mapao[comp]![ind] = "0";
                                }
                                // There were no translations for this...
                                // final snackBar = SnackBar(
                                //     content: Text(
                                //         'This student was given 0 in all indicators'));
                                // ScaffoldMessenger.of(context)
                                //     .showSnackBar(snackBar);
                              }
                              print(_mapao);
                              studs[currentStudent] = true;

                              addGrade(
                                  currentStudent,
                                  _mapao,
                                  data['currentNumber'].toString(),
                                  data,
                                  assesId);
                              bool x = true;
                              for (var k in studs.values) {
                                if (k == false) x = false;
                              }
                              updateAssessment(widget.passedAssessmentIdName,
                                  studs, data, x);
                              if (x == true) {
                                FirebaseFirestore.instance
                                    .collection('classes')
                                    .doc(data['ClassId'])
                                    .update({
                                  'prevAssess': FieldValue.increment(1)
                                });
                                Navigator.pop(context);
                              } else {
                                print(studs);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            super.widget));
                              }
                            },
                            child: Text(AppLocalizations.of(context)!
                                .dontassessstudent),
                          ),
                          for (var k in namesC)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Divider(
                                    height: 20,
                                    thickness: 4,
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
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
