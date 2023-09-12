import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GenMultipleSelfAssessment extends StatefulWidget {
  final String passedClassName; //Class ID
  final String passedName; // The real name, ie. Class Soprano
  final Map passedCompetences; // Map of competences
  final List passedStuds; // Student to asses if its pointed to him/her
  const GenMultipleSelfAssessment(this.passedClassName, this.passedName,
      this.passedCompetences, this.passedStuds);

  @override
  _GenMultipleSelfAssessmentState createState() =>
      _GenMultipleSelfAssessmentState();
}

class _GenMultipleSelfAssessmentState extends State<GenMultipleSelfAssessment> {
  late String _typeAssess;
  late List<String?> _competencesAssess = [];
  late String docID;

  final String content = 'THIS IS A SELF TEMPLATE NEED TEXT HERE IMPORTANT';

  late CollectionReference assessments =
      FirebaseFirestore.instance.collection('assessments');

  TextEditingController _controllerName = TextEditingController();

  String? currentUser = FirebaseAuth.instance.currentUser!.email;

  String? _iD;
  Future<void> addAssessment(String X, Map comp) {
    // Call the user's CollectionReference to add a new assessment
    return assessments.add({
      'Created': FieldValue.serverTimestamp(),
      'ClassId': widget.passedClassName,
      'ClassName': widget.passedName,
      'Creator': currentUser,
      'Type': _typeAssess,
      'Competences': comp,
      'Students': [X],
      'DONE': false,
      'documentID': _iD,
      'Name': _controllerName.text
    }).then((value) {
      print(value.id);
      docID = value.id;
      updateAssessment(value.id);
    });
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
                    for (var stud in widget.passedStuds) {
                      _competencesAssess = [];
                      _typeAssess = "Self";
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
                          stud, competencesFirebase);
                      print(docID);
                    }
                    final snackBar = SnackBar(
                        content:
                            // TRANSLATE NEED HERE
                            Text(AppLocalizations.of(context)!.issuedassess));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.pop(context);
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
