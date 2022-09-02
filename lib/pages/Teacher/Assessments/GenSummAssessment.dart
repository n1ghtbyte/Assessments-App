import 'package:assessments_app/pages/Teacher/AssessReviewSolo.dart';
import 'package:assessments_app/pages/Teacher/AssessmentCheck.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:assessments_app/assets/src/LinkedLabelCheckbox.dart';
import 'package:intl/intl.dart'; // From the docs

class GenSummAssessment extends StatefulWidget {
  final String passedClassName;
  const GenSummAssessment(this.passedClassName);

  @override
  _GenSummAssessmentState createState() => _GenSummAssessmentState();
}

class _GenSummAssessmentState extends State<GenSummAssessment> {
  final Query assessments =
      FirebaseFirestore.instance.collection('/assessments');
  late CollectionReference _class =
      FirebaseFirestore.instance.collection('/classes');

  List<dynamic> _assessmentsFormativeMultiple = [];

  List<bool> _isSelected = List<bool>.generate(100, (int index) => false,
      growable: true); // 100 assessments... TOO MUCH

  String? currentUser = FirebaseAuth.instance.currentUser!.email;

  Widget build(BuildContext context) {
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

        var comp = data['Weights']; //Fetch the weights

        if (comp != null) {
          return StreamBuilder<QuerySnapshot>(
            stream: assessments
                .where("Target", isEqualTo: "Multiple")
                .where("Creator", isEqualTo: currentUser.toString())
                .where("ClassId", isEqualTo: widget.passedClassName)
                .orderBy('Created', descending: true)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snp2) {
              if (snp2.hasError) {
                return Text("Something went wrong");
              }
              if (!snp2.hasData) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              _assessmentsFormativeMultiple = snp2.data!.docs;

              return Scaffold(
                appBar: AppBar(
                  title: Text('Generate Summ. Assessment'),
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
                        child: Text(
                          "Summative Assessment Definition !",
                        ),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: comp.keys.toList().length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(comp.keys.toList()[index]),
                            subtitle: Text(
                                comp[comp.keys.toList()[index]].toString() +
                                    " %"),
                          );
                        },
                      ),
                      Container(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                            "Choose which assessments to take into account",
                            style: TextStyle(fontSize: 18.0)),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _assessmentsFormativeMultiple.length,
                        itemBuilder: (context, index) {
                          return LinkedLabelCheckbox(
                            label: "Formative Assessment " +
                                (_assessmentsFormativeMultiple[index]
                                            .data()['currentNumber'] +
                                        1)
                                    .toString() +
                                "\n" +
                                DateFormat('yyyy-MM-dd')
                                    .format(
                                        (_assessmentsFormativeMultiple[index]
                                                .data()['Created'] as Timestamp)
                                            .toDate())
                                    .toString(),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            goto: AssessmentCheck(
                                passedAssessmentIdName:
                                    _assessmentsFormativeMultiple[index]
                                        .data()['documentID']),
                            value: _isSelected[index],
                            onChanged: (bool newValue) {
                              setState(
                                () {
                                  _isSelected[index] = newValue;
                                },
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          onPrimary: Colors.white,
                          primary: Color(0xFF29D09E),
                        ),
                        onPressed: () {
                          _isSelected.removeRange(
                              _assessmentsFormativeMultiple.length, 100);
                          _isSelected = _isSelected.reversed.toList();
                          print(_isSelected);
                          generateSummative(_isSelected, _assessmentsFormativeMultiple);
                          Navigator.pop(context);
                        },
                        child: Text(('Generate'),
                            style: new TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('Generate Summ. Assessment'),
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
                    child: Text(
                      "Before you can run a summative assessment, you must setup the weights of each competence!",
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
  
}
// Generate a summative assessment for the whole class
  // Regarding the formatives that were selected
  void generateSummative(List<bool> isSelected, List assessmentsFormativeMultiple) {
    
  }