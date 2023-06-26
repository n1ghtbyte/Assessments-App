import 'package:assessments_app/pages/Teacher/Classes/ClassesCreatePage.dart';
import 'package:assessments_app/pages/Teacher/Classes/TurmaExemplo.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../InovWidgets/NavBarTeacher.dart';

class ClassesPage extends StatefulWidget {
  const ClassesPage({Key? key}) : super(key: key);

  @override
  State<ClassesPage> createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  String? currentUser = FirebaseAuth.instance.currentUser!.email;

  final _classesStream = FirebaseFirestore.instance
      .collection('classes')
      .where('TeacherID', isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .orderBy("Created", descending: true)
      .snapshots();

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
            drawer: NavBarTeacher(),
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.classes),
              centerTitle: true,
              backgroundColor: Color(0xFF29D09E),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Color(0xFF29D09E),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClassesCreatePage(),
                  ),
                );
              },
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
          drawer: NavBarTeacher(),
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.classes),
            centerTitle: true,
            backgroundColor: Color(0xFF29D09E),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Color(0xFF29D09E),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClassesCreatePage(),
                ),
              );
            },
          ),
          body: ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                onTap: () {
                  print(data);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TurmaExemplo(data['documentID'].toString())),
                  );
                },
                leading: Icon(Icons.school),
                isThreeLine: true,
                title: Text(data['Name']),
                subtitle: Text(
                    "${AppLocalizations.of(context)!.students}: ${data['NumStudents'].toString()}\n${AppLocalizations.of(context)!.joinc}: ${data['documentID'].toString()}"),
                onLongPress: () async {
                  final docId = data['documentID'];
                  final snackBar = SnackBar(
                      content:
                          Text(AppLocalizations.of(context)!.copyclipboard));
                  await Clipboard.setData(ClipboardData(text: docId))
                      .then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }).catchError((error) {
                    // Handle clipboard operation errors
                    print('Error copying to clipboard: $error');
                  });
                  print(docId);
                  await Clipboard.getData(Clipboard.kTextPlain).then((value) {
                    print(value?.text); //value is clipbarod data
                  });
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
