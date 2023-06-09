import 'package:assessments_app/pages/Teacher/Assessments/AssessReviewSolo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AssessmentCheck extends StatefulWidget {
  final String passedAssessmentIdName;

  const AssessmentCheck({Key? key, required this.passedAssessmentIdName})
      : super(key: key);

  @override
  State<AssessmentCheck> createState() => _AssessmentCheckState();
}

final CollectionReference _assess =
    FirebaseFirestore.instance.collection('assessments');
Map<dynamic, dynamic> namedStuds = {};

class _AssessmentCheckState extends State<AssessmentCheck> {
  @override
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

          List<String> studs = data['Students'].keys.toList();
          return StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> snp) {
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
                var x = snp.data?.size;
                print(studs);

                for (var i = 0; i < x!; i++) {
                  Map<String, dynamic> foo =
                      snp.data?.docs[i].data()! as Map<String, dynamic>;
                  print(foo);
                  if (studs.contains(foo['Email'])) {
                    print(foo);
                    print(i);

                    namedStuds[foo['Email'].toString()] =
                        foo['FirstName'].toString() +
                            " " +
                            foo['LastName'].toString();
                  }
                }
                print(namedStuds);
                for (var i in studs) {
                  if (!namedStuds.containsKey(i)) {
                    namedStuds[i.toString()] = i.toString();
                  }
                }
                print("::::::");
                print(studs);

                return Scaffold(
                    appBar: AppBar(
                      title: Text(AppLocalizations.of(context)!.review),
                      centerTitle: true,
                      backgroundColor: Color(0xff29d092),
                    ),
                    body: Column(
                      children: [
                        SizedBox(
                          height: 14,
                        ),
                        Container(
                          padding: EdgeInsets.all(14.0),
                          child: Text(
                            "${AppLocalizations.of(context)!.name}: ${data['Name']}\n${AppLocalizations.of(context)!.classConcept}: ${data['ClassName']}\n${AppLocalizations.of(context)!.date}: ${DateFormat('yyyy-MM-dd').format((data['Created'] as Timestamp).toDate())}",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Divider(
                          height: 20,
                          thickness: 4,
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: studs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  title: Text(
                                      namedStuds[studs[index].toString()]
                                          .toString()),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AssessReview(
                                          passedAssessmentIdName:
                                              widget.passedAssessmentIdName,
                                          passedClassName: data['ClassId'],
                                          passedStudName: studs[index],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                        ),
                      ],
                    ));
              });
        });
  }
}
