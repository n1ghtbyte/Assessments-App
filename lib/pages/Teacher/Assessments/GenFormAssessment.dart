import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GenFormAssessment extends StatefulWidget {
  final String passedClassName;
  final String passedName;
  final Map passedCompetences;
  final String passedStudName;
  const GenFormAssessment(this.passedClassName, this.passedName,
      this.passedCompetences, this.passedStudName);

  @override
  _GenFormAssessmentState createState() => _GenFormAssessmentState();
}

class _GenFormAssessmentState extends State<GenFormAssessment> {
  late String _typeAssess;
  late List<String?> _competencesAssess = [];

  late CollectionReference assessments =
      FirebaseFirestore.instance.collection('assessments');

  String? currentUser = FirebaseAuth.instance.currentUser!.email;

  String? _iD;
  Future<void> addAssessment(Map X, Map comp, var curr) {
    if (widget.passedStudName.contains("@")) {
      return assessments.add({
        'Created': FieldValue.serverTimestamp(),
        'ClassId': widget.passedClassName,
        'ClassName': widget.passedName,
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
        'Created': FieldValue.serverTimestamp(),
        'ClassId': widget.passedClassName,
        'ClassName': widget.passedName,
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

  //11 just heristic
  List<bool> isChecked = List<bool>.filled(11, false);

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
              title: Text('Generate F.Assessment'),
              centerTitle: true,
              backgroundColor: Color(0xFF29D09E),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 16),

                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Text("Choose the Competences",
                        style: TextStyle(fontSize: 22.0)),
                  ),
                  //Start Populator
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        activeColor: Color(0xFF29D09E),
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
                        addAssessment(
                            resultMap, competencesFirebase, data['currAssess']);
                        final snackBar = SnackBar(
                            content: Text(
                                'The assessment has been issued to this Class :)'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.pop(context);
                      } else {
                        final snackBar = SnackBar(
                            content: Text(
                                'You must finish the assessment that you assigned to this class first!'));
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
