// import 'package:assessments_app/pages/Teacher/AssessReviewSolo.dart';

import 'package:assessments_app/pages/Teacher/Assessments/AssessmentCheck.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:assessments_app/assets/src/LinkedLabelCheckbox.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart'; // From the docs
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GenSingleSummAssessment extends StatefulWidget {
  final String passedClassName; //Class ID
  final String passedName; // The real name, ie. Class Soprano
  final Map passedCompetences; // Map of competences
  final String passedStudName; // Student to asses if its pointed to him/her
  const GenSingleSummAssessment(this.passedClassName, this.passedName,
      this.passedCompetences, this.passedStudName);
  @override
  _GenSingleSummAssessmentState createState() =>
      _GenSingleSummAssessmentState();
}

class _GenSingleSummAssessmentState extends State<GenSingleSummAssessment> {
  final String content =
      'A summative assessement is one "that occurs at a point in time and is carried out to summarise achievement at that point in time. Often more structured than formative assessment, it provides teachers, students and parents with information on student progress and level of achievement. Summative assessments are used to evaluate student learning, skill acquisition, and academic achievement at the conclusion of a defined instructional period—typically at the end of a project, unit, course, semester, program, or school year. \n(NCVER, 2014)';

  final db = FirebaseFirestore.instance;
  late CollectionReference _formativeCollection = FirebaseFirestore.instance
      .collection(
          '/classes/${widget.passedClassName}/grading/${widget.passedStudName}/formative');
  String? currentUser = FirebaseAuth.instance.currentUser!.email;

  List<dynamic> _assessmentsFormativeMultiple = [];
  List<bool> _isSelected = List<bool>.generate(100, (int index) => false,
      growable: true); // 100 assessments... TOO MUCH

  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _formativeCollection
          .orderBy('Created', descending: false)
          .snapshots(),
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

        _assessmentsFormativeMultiple = snapshot.data!.docs;

        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.genassess),
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
                  child: ReadMoreText(
                    AppLocalizations.of(context)!.summtext,
                    trimLength: 4,
                    textAlign: TextAlign.justify,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: AppLocalizations.of(context)!.sm,
                    trimExpandedText: AppLocalizations.of(context)!.sl,
                    lessStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFF29D09E)),
                    moreStyle: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFF29D09E)),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text(AppLocalizations.of(context)!.pickassess,
                      style: TextStyle(fontSize: 18.0)),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return LinkedLabelCheckbox(
                      label: (snapshot.data!.docs[index].data()
                                  as Map<dynamic, dynamic>)['Name']
                              .toString() +
                          "\n" +
                          DateFormat('yyyy-MM-dd')
                              .format(((snapshot.data!.docs[index].data()
                                          as Map<dynamic, dynamic>)['Created']
                                      as Timestamp)
                                  .toDate())
                              .toString(),
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      goto: AssessmentCheck(
                          passedAssessmentIdName: (snapshot.data!.docs[index]
                              .data() as Map<dynamic, dynamic>)['AssessID']),
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
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFF29D09E),
                  ),
                  onPressed: () {
                    List<dynamic> asses = [];
                    List<dynamic> assessToUpload = [];

                    final docRef =
                        db.collection("/classes").doc(widget.passedClassName);
                    docRef.get().then(
                      (DocumentSnapshot doc) async {
                        final data = doc.data() as Map<String, dynamic>;
                        var weigths = data['Weights'];

                        _isSelected.removeRange(
                            _assessmentsFormativeMultiple.length, 100);

                        // _isSelected = _isSelected.reversed.toList();

                        for (var i = 0; i < _isSelected.length; i++) {
                          if (_isSelected[i]) {
                            asses.add(i);
                          }
                        }

                        print(
                            "INICIONNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN");
                        print(asses);

                        Map<String, List<dynamic>> kiki = Map();
                        var elStud = widget.passedStudName;
                        var sumativo;
                        num result = 0;
                        Map<String, List<dynamic>> summComp = {};

                        print(widget.passedClassName);

                        for (var i = 0; i < asses.length; i++) {
                          print(_assessmentsFormativeMultiple[asses[i]]
                              ['AssessID']);
                          assessToUpload.add(
                              _assessmentsFormativeMultiple[asses[i]]
                                  ['AssessID']);

                          kiki[elStud] = [];
                          await db
                              .collection(
                                  "classes/${widget.passedClassName}/grading/$elStud/formative")
                              .where('AssessID',
                                  isEqualTo:
                                      _assessmentsFormativeMultiple[asses[i]]
                                              ['AssessID']
                                          .toString())
                              .get()
                              .then(
                            (value) {
                              for (var doc in value.docs) {
                                print(doc.data());
                                kiki[elStud]?.add(doc.data());
                                print(doc.data()['Created']);
                              }
                            },
                          );

                          // now we have all documents of that elStudent
                          print("Current 'i' is : " + i.toString());

                          for (var doc in kiki[elStud]!) {
                            for (var comp in doc['Competences'].keys) {
                              if (summComp[comp] == null) {
                                summComp[comp] = [];
                              }
                              for (var indvalue
                                  in doc['Competences'][comp].values) {
                                print("KIKI");
                                print(indvalue.toString());
                                if (summComp[comp] != null) {
                                  summComp[comp.toString()]
                                      ?.add(int.parse(indvalue));
                                }
                              }
                            }
                          }
                        }
                        print(elStud);
                        print(summComp.entries);
                        for (var i in summComp.keys) {
                          num foo = 0;
                          for (var j in summComp[i]!) {
                            foo += j;
                          }
                          sumativo = foo / summComp[i]!.length;
                          // print(sumativo);
                          // print(weigths[i]);

                          result += sumativo * (weigths[i] / 100);
                          // print(result);

                          // print(kiki['a']);
                        } // here bellow
                        print("here");
                        print("result: " + result.toString());
                        await db
                            .collection(
                                "classes/${widget.passedClassName}/grading/$elStud/summative")
                            .add(
                          {
                            'Created': FieldValue.serverTimestamp(),
                            'Formatives': assessToUpload,
                            'Result': result,
                            'Weights': weigths,
                            'Targets': 'Single'
                          },
                        );
                        summComp = {};

                        result = 0;
                        sumativo = 0;
                        print("FIIIIIIIIIIIIIIIIIIIIIIIIIIIIM");
                      },
                      onError: (e) => print("Error getting document: $e"),
                    );
                    SnackBar(
                        content:
                            Text(AppLocalizations.of(context)!.summissued));

                    Navigator.pop(context);
                  },
                  child: Text((AppLocalizations.of(context)!.generate),
                      style: new TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
