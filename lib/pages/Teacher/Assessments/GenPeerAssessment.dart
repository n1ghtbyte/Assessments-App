import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:assessments_app/utils/PeerSet.dart';

class GenPeerAssessment extends StatefulWidget {
  final String passedClassName; //Class ID
  final String passedName; // The real name, ie. Class Soprano
  final Map passedCompetences; // Map of competences
  final List passedListStudents;
  const GenPeerAssessment(this.passedClassName, this.passedName,
      this.passedCompetences, this.passedListStudents);

  @override
  _GenPeerAssessmentState createState() => _GenPeerAssessmentState();
}

class _GenPeerAssessmentState extends State<GenPeerAssessment> {
  late String _typeAssess;
  late List<String?> _competencesAssess = [];
  late String docID;

  final String content =
      'A formative assessement is: "the process of providing feedback to students during the learning process.  These are often low stakes activities that allow the instructor to check student work and provide feedback. Formative assessment refers to a wide variety of methods that teachersuse to conduct in-process evaluations of student comprehension, learning needs, and academic progress during a lesson, unit, or course. Formative assessments help teachers identify concepts that students are struggling to understand, skills they are having difficulty acquiring, or learning standards they have not yet achieved so that adjustments can be made to lessons, instructional techniques, and academic support.\nThe general goal of formative assessment is to collect detailed information that can be used to improve instruction and student learning while it’s happening. What makes an assessment “formative” is not the design of a test, technique, or self-evaluation, per se, but the way it is used—i.e., to inform in-process teaching and learning modifications."\n (Weimer, 2013)';

  late CollectionReference assessments =
      FirebaseFirestore.instance.collection('/assessments/');

  TextEditingController _controllerName = TextEditingController();

  String? currentUser = FirebaseAuth.instance.currentUser!.email;

  String? _iD;
  Future<void> addAssessment(Map comp, String peerMaster, Map peerSlaves) {
    return assessments.add(
      {
        'Created': FieldValue.serverTimestamp(),
        'ClassId': widget.passedClassName,
        'ClassName': widget.passedName,
        'Creator': currentUser,
        'Type': _typeAssess,
        'Competences': comp,
        'DONE': false,
        'PeerMaster': peerMaster,
        'PeerSlaves': peerSlaves,
        'Count': 0,
        'documentID': _iD,
        'Name': _controllerName.text
      },
    ).then(
      (value) {
        print(value.id);
        docID = value.id;
        updateAssessment(value.id);
      },
    );
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
  List<String?> list = [];

  Widget build(BuildContext context) {
    widget.passedCompetences.entries.forEach((e) => list.add(e.key));

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.peer),
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
                  helperText: AppLocalizations.of(context)!.assessnamequestion,
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
              itemCount: widget.passedCompetences.length,
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
                _competencesAssess = [];
                _typeAssess = "Peer";
                for (int i = 0; i < widget.passedCompetences.length; i++) {
                  if (isChecked[i] == true) {
                    _competencesAssess.add(list[i]);
                  }
                }
                print(_competencesAssess);
                print(widget.passedListStudents);
                var peerSets = getPeerSet(widget.passedListStudents);
                print(peerSets);
                Map<String, dynamic> competencesFirebase = {};
                for (var x in widget.passedCompetences.entries) {
                  if (_competencesAssess.contains(x.key.toString()) == true) {
                    competencesFirebase[x.key] = x.value;
                  }
                }
                for (var stud in peerSets.keys) {
                  await addAssessment(
                      competencesFirebase, stud, peerSets[stud] as Map);
                }

                final snackBar = SnackBar(
                    content: Text(AppLocalizations.of(context)!.issuedassess));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.pop(context);
              },
              child: Text(
                (AppLocalizations.of(context)!.create),
                style: new TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
