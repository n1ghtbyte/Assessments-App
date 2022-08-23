import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AssessmentsCreateTeacherPage extends StatefulWidget {
  final String passedClassName;
  final String passedName;
  final Map passedCompetences;
  final String passedStudName;
  const AssessmentsCreateTeacherPage(this.passedClassName, this.passedName,
      this.passedCompetences, this.passedStudName);

  @override
  _AssessmentsCreateTeacherPageState createState() =>
      _AssessmentsCreateTeacherPageState();
}

class _AssessmentsCreateTeacherPageState
    extends State<AssessmentsCreateTeacherPage> {
  late String _typeAssess;
  late List<String?> _competencesAssess = [];

  late CollectionReference assessments =
      FirebaseFirestore.instance.collection('assessments');

  String? currentUser = FirebaseAuth.instance.currentUser!.email;

  String? _iD;
  Future<void> addAssessment(Map X, Map comp, var curr) {
    if (widget.passedStudName.contains("@")) {
      return assessments.add({
        'ClassId': widget.passedClassName,
        'ClassName': widget.passedName,
        'Created': FieldValue.serverTimestamp(),
        'Creator': currentUser,
        'Type': _typeAssess,
        'Target': "Single",
        'Competences': comp,
        'Students': {widget.passedStudName: false},
        'DONE': false,
        'Count': 0,
        'documentID': _iD
      }).then((value) {
        print(value.id);
        updateAssessment(value.id);
      });
    } else {
      // Call the user's CollectionReference to add a new assessment
      return assessments.add({
        'ClassId': widget.passedClassName,
        'ClassName': widget.passedName,
        'Created': FieldValue.serverTimestamp(),
        'Creator': currentUser,
        'Type': _typeAssess,
        'Target': "Multiple",
        'Competences': comp,
        'Students': X,
        'DONE': false,
        'Count': 0,
        'currentNumber': curr,
        'documentID': _iD
      }).then((value) {
        print(value.id);
        updateAssessment(value.id);
      });
    }
  }

  Future<void> updateAssessment(String _docid) {
    return assessments
        .doc(_docid)
        .update({'documentID': _docid})
        .then((value) => print("Assessment Updated"))
        .catchError((error) => print("Failed to update assessment: $error"));
  }

  // Default Radio Button Selected Item When App Starts.
  String radioButtonItem = 'Peer';

  // Group Value for Radio Button.
  int id = 1;

  //10 just heristic
  List<bool> isChecked = List<bool>.filled(10, false);

  Widget build(BuildContext context) {
    late CollectionReference _class =
        FirebaseFirestore.instance.collection('classes');
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
          var comp = data['Competences'];
          List<String?> list = [];
          comp.entries.forEach((e) => list.add(e.key));
          var studsList = data['StudentList'];
          var resultMap = {for (var v in studsList) v: false};

          return Scaffold(
            appBar: AppBar(
              title: Text('Generate Assessment'),
              centerTitle: true,
              backgroundColor: Color(0xFF29D09E),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Text("Assessment type",
                        style: TextStyle(fontSize: 20.0)),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio(
                        value: 1,
                        groupValue: id,
                        onChanged: (val) {
                          setState(() {
                            radioButtonItem = 'Peer';
                            id = 1;
                          });
                        },
                      ),
                      Text(
                        'Peer',
                        style: new TextStyle(fontSize: 16),
                      ),
                      Radio(
                        value: 2,
                        groupValue: id,
                        onChanged: (val) {
                          setState(() {
                            radioButtonItem = 'Self';
                            id = 2;
                          });
                        },
                      ),
                      Text(
                        'Self',
                        style: new TextStyle(fontSize: 14),
                      ),
                      Radio(
                        value: 3,
                        groupValue: id,
                        onChanged: (val) {
                          setState(() {
                            radioButtonItem = 'Formative';
                            id = 3;
                          });
                        },
                      ),
                      Text(
                        'Formative',
                        style: new TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Radio(
                        value: 4,
                        groupValue: id,
                        onChanged: (val) {
                          setState(() {
                            radioButtonItem = 'Summative';
                            id = 4;
                          });
                        },
                      ),
                      Text(
                        'Sumative',
                        style: new TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(
                    thickness: 1,
                    height: 1,
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Text("Choose the Competences",
                        style: TextStyle(fontSize: 20.0)),
                  ),
                  //Start Populator
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        title: Text("${list[index]}"),
                        value: isChecked[index],
                        onChanged: (value) {
                          setState(() {
                            isChecked[index] = value!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      );
                    },
                  ),

                  //End Populator

                  // CheckboxListTile(
                  //   title: Text("Skill 1"),
                  //   value: isChecked0,
                  //   onChanged: (kora0) {
                  //     setState(() {
                  //       isChecked0 = kora0!;
                  //     });
                  //   },
                  //   controlAffinity: ListTileControlAffinity
                  //       .leading, //  <-- leading Checkbox
                  // ),
                  // CheckboxListTile(
                  //   title: Text("Skill 2"),
                  //   value: isChecked1,
                  //   onChanged: (kora1) {
                  //     setState(() {
                  //       isChecked1 = kora1!;
                  //     });
                  //   },
                  //   controlAffinity: ListTileControlAffinity
                  //       .leading, //  <-- leading Checkbox
                  // ),
                  // CheckboxListTile(
                  //   title: Text("Skill 3"),
                  //   value: isChecked2,
                  //   onChanged: (kora2) {
                  //     setState(() {
                  //       isChecked2 = kora2!;
                  //     });
                  //   },
                  //   controlAffinity: ListTileControlAffinity
                  //       .leading, //  <-- leading Checkbox
                  // ),
                  // const SizedBox(height: 16),
                  // Divider(
                  //   thickness: 1,
                  //   height: 1,
                  // ),
                  const SizedBox(height: 16),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.white,
                      primary: Color(0xFF29D09E),
                    ),
                    onPressed: () {
                      if (data['prevAssess'] == data['currAssess']) {
                        FirebaseFirestore.instance
                            .collection('classes')
                            .doc(widget.passedClassName)
                            .update({'currAssess': FieldValue.increment(1)});
                        _competencesAssess = [];
                        //Navigator.pop(context);
                        if (id == 3) {
                          _typeAssess = "Formative";
                          for (int i = 0; i < list.length; i++) {
                            if (isChecked[i] == true) {
                              _competencesAssess.add(list[i]);
                            }
                          }

                          Map<String, dynamic> competencesFirebase = {};
                          for (var x in widget.passedCompetences.entries) {
                            if (_competencesAssess.contains(x.key.toString()) ==
                                true) {
                              competencesFirebase[x.key] = x.value;
                            }
                          }
                          addAssessment(resultMap, competencesFirebase,
                              data['currAssess']);
                          final snackBar = SnackBar(
                              content: Text(
                                  'The assessment has been issued to this Class :)'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.pop(context);
                        } else {
                          final snackBar =
                              SnackBar(content: Text('Still in dev.'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      } else {
                        final snackBar = SnackBar(
                            content: Text(
                                'You must end the assessment that you assigned to this class first!'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Text(('Create'), style: new TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
