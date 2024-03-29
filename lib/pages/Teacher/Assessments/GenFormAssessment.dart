import 'package:assessments_app/pages/Teacher/Assessments/AssessmentFormative.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overlay_kit/overlay_kit.dart';
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
  List<bool> isChecked = List<bool>.filled(20, false);

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
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Color(0xFF29D09E),
            onPressed: () async {
              _competencesAssess = [];
              _typeAssess = "Formative";
              for (int i = 0; i < list.length; i++) {
                if (isChecked[i] == true) {
                  _competencesAssess.add(list[i]);
                }
              }
              if (_competencesAssess.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!.fieldsdead,
                    ),
                  ),
                );
              } else {
                OverlayLoadingProgress.start(
                  widget: Container(
                    width: MediaQuery.of(context).size.width / 4,
                    padding:
                        EdgeInsets.all(MediaQuery.of(context).size.width / 13),
                    child: const AspectRatio(
                      aspectRatio: 1,
                      child: const CircularProgressIndicator(
                        color: Color(0xFF29D09E),
                      ),
                    ),
                  ),
                );

                FirebaseFirestore.instance
                    .collection('classes')
                    .doc(widget.passedClassName)
                    .update({'currAssess': FieldValue.increment(1)});

                Map<String, dynamic> competencesFirebase = {};
                for (var x in widget.passedCompetences.entries) {
                  if (_competencesAssess.contains(x.key.toString()) == true) {
                    competencesFirebase[x.key] = x.value;
                  }
                }
                await Future.delayed(
                  const Duration(seconds: 1),
                );
                await addAssessment(
                    resultMap, competencesFirebase, data['currAssess']);
                await Future.delayed(
                  const Duration(seconds: 1),
                );
                print(docID);
                final snackBar = SnackBar(
                    content: Text(AppLocalizations.of(context)!.issuedassess));
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
                //stop the loading
                OverlayLoadingProgress.stop();
              }
            },
            label: Text(AppLocalizations.of(context)!.create),
            icon: Icon(Icons.add, size: 18),
          ),
          body: SingleChildScrollView(
            // physics for the scroll but just a bit
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
                        setState(
                          () {
                            isChecked[index] = value!;
                          },
                        );
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
