import 'package:assessments_app/pages/Student/Classes/StudentClassInside.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChildClasses extends StatefulWidget {
  final String passedEmail;

  const ChildClasses({Key? key, required this.passedEmail}) : super(key: key);

  @override
  State<ChildClasses> createState() => _ChildClassesState();
}

class _ChildClassesState extends State<ChildClasses> {
  final _classesStream = FirebaseFirestore.instance.collection('classes');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _classesStream
          .where('StudentList', arrayContains: widget.passedEmail)
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
              title: Text(
                  '${widget.passedEmail}\'s ${AppLocalizations.of(context)!.classes}'),
              centerTitle: true,
              backgroundColor: Color(0xFF29D09E),
            ),
            body: Center(
              child: Text(
                AppLocalizations.of(context)!.classdisplayhere,
                style: TextStyle(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.classes),
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
                    print(data);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StudentClassInside(
                              passedWeights: data['Weights'],
                              passedClassId: data['documentID'].toString(),
                              passedClassName: data['Name'].toString(),
                              passedEmail: widget.passedEmail.toString(),
                              passedCompetences: data['Competences'])),
                    );
                  },
                  leading: Icon(Icons.school),
                  isThreeLine: false,
                  title: Text(data['Name']),
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }
}
