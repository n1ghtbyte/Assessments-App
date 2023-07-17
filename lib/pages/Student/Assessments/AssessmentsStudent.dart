import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AssessmentsStudent extends StatefulWidget {
  const AssessmentsStudent({Key? key}) : super(key: key);

  @override
  State<AssessmentsStudent> createState() => _AssessmentsStudentState();
}

class _AssessmentsStudentState extends State<AssessmentsStudent> {
  String? currentUser = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('assessments')
          .where('Students',
              arrayContains: FirebaseAuth.instance.currentUser!.email)
          .where('Type', isEqualTo: 'Self')
          .snapshots(),
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
              title: Text(AppLocalizations.of(context)!.assessments),
              centerTitle: true,
              backgroundColor: Color(0xFF29D09E),
            ),
            body: Center(
              child: Text(
                AppLocalizations.of(context)!.assessdisplayhere,
                style: TextStyle(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.assessments),
            centerTitle: true,
            backgroundColor: Color(0xFF29D09E),
          ),
          body: ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                // onTap: () {
                //   print(data);
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => AssessmentSelf(
                //           passedAssessmentIdName: data['documentID']),
                //     ),
                //   );
                // },
                leading: Icon(Icons.assessment),
                isThreeLine: false,
                title: Text(data['Name']),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
