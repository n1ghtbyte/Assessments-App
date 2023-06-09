import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StudentAddClass extends StatefulWidget {
  const StudentAddClass({Key? key}) : super(key: key);

  @override
  _StudentAddClassState createState() => _StudentAddClassState();
}

class _StudentAddClassState extends State<StudentAddClass> {
  final _controllerJoin = TextEditingController();
  @override
  void dispose() {
    _controllerJoin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.joinclass),
        centerTitle: true,
        backgroundColor: Color(0xFF29D09E),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF29D09E),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('classes')
              .doc(_controllerJoin.text)
              .get()
              .then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              var num = documentSnapshot['NumStudents'] + 1;
              List<dynamic> tmp = documentSnapshot['StudentList'];

              tmp.add(FirebaseAuth.instance.currentUser?.email);
              FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseAuth.instance.currentUser?.email)
                  .update({"Classes": _controllerJoin.text});

              FirebaseFirestore.instance
                  .collection('classes')
                  .doc(_controllerJoin.text)
                  .update({'StudentList': tmp});

              FirebaseFirestore.instance
                  .collection('classes')
                  .doc(_controllerJoin.text)
                  .update({'NumStudents': (num)});
              Navigator.pop(context);
            } else {
              final snackBar = SnackBar(
                  content:
                      Text(AppLocalizations.of(context)!.classunavailable));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          });
        },
        icon: Icon(Icons.next_plan),
        label: Text(AppLocalizations.of(context)!.join),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: ListView(
            children: [
              TextFormField(
                controller: _controllerJoin,
                decoration: InputDecoration(
                  icon: Icon(Icons.class_),
                  labelStyle: TextStyle(
                    color: Color(0xFF29D09E),
                  ),
                  helperText: AppLocalizations.of(context)!.entertheclasscode,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF29D09E)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
