import 'package:assessments_app/pages/Teacher/Classes/ReviewTheAssess.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReviewAssessments extends StatefulWidget {
  final String passedClassName;

  const ReviewAssessments(this.passedClassName);
  @override
  _ReviewAssessmentsState createState() => _ReviewAssessmentsState();
}

class _ReviewAssessmentsState extends State<ReviewAssessments> {
  var _classesStream;

  @override
  void initState() {
    super.initState();
    print(widget.passedClassName);
    _classesStream = FirebaseFirestore.instance
        .collection('assessments')
        .where('ClassId', isEqualTo: widget.passedClassName)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _classesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.data?.size.toInt() == 0) {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.reviewassessments),
              centerTitle: true,
              backgroundColor: Color(0xFF29D09E),
            ),
            body: Center(
              child: Text(
                // falta traducao
                "",
                style: TextStyle(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.reviewassessments),
              centerTitle: true,
              backgroundColor: Color(0xFF29D09E),
            ),
            body: ListView(
              children: snapshot.data!.docs.map(
                (DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;

                  return ListTile(
                    onTap: () {
                      if (data['Type'] == 'Formative') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReviewAssessment(
                              passedAssessmentIdName: data['documentID'],
                            ),
                          ),
                        );
                      }
                    },
                    leading: Icon(Icons.assessment),
                    isThreeLine: true,
                    enabled: data['DONE'] == true,
                    title: Text('${data['Type']} Assessment'),
                    subtitle: Text(
                        //\nNumber: ${data['currentNumber'].toString() LIT
                        "${AppLocalizations.of(context)!.classname}: ${data['ClassName'].toString()}\n${AppLocalizations.of(context)!.count}: ${data['Count'].toString()}/${data['Students'].values.toList().length}"),
                  );
                },
              ).toList(),
            ),
          );
        }
      },
    );
  }
}
