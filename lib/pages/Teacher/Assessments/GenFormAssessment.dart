import 'package:assessments_app/pages/Teacher/Assessments/AssessmentFormative.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GenFormAssessment extends StatefulWidget {
  final String passedClassName; //Class ID
  final String passedName; // The real name, ie. Class Soprano
  final Map passedCompetences; // Map of competences
  final String passedStudName; // Student to asses if its pointed to him/her
  const GenFormAssessment(this.passedClassName, this.passedName,
      this.passedCompetences, this.passedStudName);

  @override
  _GenFormAssessmentState createState() => _GenFormAssessmentState();
}

class _GenFormAssessmentState extends State<GenFormAssessment> {
  late String _typeAssess;
  late List<String?> _competencesAssess = [];
  late String docID;

  final String content =
      'A formative assessement is: "the process of providing feedback to students during the learning process.  These are often low stakes activities that allow the instructor to check student work and provide feedback. Formative assessment refers to a wide variety of methods that teachersuse to conduct in-process evaluations of student comprehension, learning needs, and academic progress during a lesson, unit, or course. Formative assessments help teachers identify concepts that students are struggling to understand, skills they are having difficulty acquiring, or learning standards they have not yet achieved so that adjustments can be made to lessons, instructional techniques, and academic support.\nThe general goal of formative assessment is to collect detailed information that can be used to improve instruction and student learning while it’s happening. What makes an assessment “formative” is not the design of a test, technique, or self-evaluation, per se, but the way it is used—i.e., to inform in-process teaching and learning modifications."\n (Weimer, 2013)';

  late CollectionReference assessments =
      FirebaseFirestore.instance.collection('assessments');

  TextEditingController _controllerName = TextEditingController();

  String? currentUser = FirebaseAuth.instance.currentUser!.email;

  String? _iD;
  Future<void> addAssessment(Map X, Map comp, var curr) {
    if (widget.passedStudName != "class") {
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
        'documentID': _iD,
        'Name': _controllerName.text
      }).then((value) {
        print(value.id);
        docID = value.id;
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
        'documentID': _iD,
        'Name': _controllerName.text
      }).then((value) {
        print(value.id);
        docID = value.id;
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
                    AppLocalizations.of(context)!.formtext,
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
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    maxLength: 30,
                    controller: _controllerName,
                    decoration: InputDecoration(
                      icon: Icon(Icons.comment),
                      labelText: AppLocalizations.of(context)!.assessname,
                      labelStyle: TextStyle(
                        color: Color(0xFF29D09E),
                      ),
                      helperText:
                          AppLocalizations.of(context)!.assessnamequestion,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF29D09E)),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text(AppLocalizations.of(context)!.pickcomps,
                      style: TextStyle(fontSize: 18.0)),
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
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFF29D09E),
                  ),
                  onPressed: () async {
                    // if (data['prevAssess'] == data['currAssess']) {
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
                    await addAssessment(
                        resultMap, competencesFirebase, data['currAssess']);
                    print(docID);
                    final snackBar = SnackBar(
                        content:
                            Text(AppLocalizations.of(context)!.issuedassess));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AssessmentFormative(
                          passedAssessmentIdName: docID,
                        ),
                      ),
                    );
                    // } else {
                    //   final snackBar = SnackBar(
                    //       content: Text(
                    //           AppLocalizations.of(context)!.finishassessfirst));
                    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    // }
                  },
                  child: Text((AppLocalizations.of(context)!.create),
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
