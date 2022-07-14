import 'package:assessments_app/pages/Teacher/AssessReviewSolo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AssessmentCheck extends StatefulWidget {
  final String passedAssessmentIdName;

  const AssessmentCheck({Key? key, required this.passedAssessmentIdName})
      : super(key: key);

  @override
  State<AssessmentCheck> createState() => _AssessmentCheckState();
}

final db = FirebaseFirestore.instance;
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

                return Scaffold(
                  appBar: AppBar(
                    title: Text('Review'),
                    centerTitle: true,
                    backgroundColor: Color(0xff29d092),
                  ),
                  floatingActionButton: FloatingActionButton.extended(
                    onPressed: null,
                    backgroundColor: const Color(0xFF29D09E),
                    label: Text('All'),
                    icon: Icon(Icons.all_inclusive),
                  ),
                  body: SafeArea(
                    child: ListView.builder(
                      itemCount: studs.length,
                      itemBuilder: (context, index) => Card(
                        elevation: 8,
                        margin: EdgeInsets.all(7),
                        child: ListTile(
                          //title: Text("KII"),
                          title: Text(
                              namedStuds[studs[index].toString()].toString()),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AssessReviewSolo(
                                    passedAssessmentIdName:
                                        namedStuds[studs[index].toString()]),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              });
        });
  }
}
