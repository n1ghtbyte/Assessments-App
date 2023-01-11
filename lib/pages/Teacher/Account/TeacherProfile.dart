import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TeacherProfile extends StatefulWidget {
  @override
  _TeacherProfileState createState() => _TeacherProfileState();
}

class _TeacherProfileState extends State<TeacherProfile> {
  @override
  void initState() {
    super.initState();
  }

  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    db.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: 2048576,
    );
    var teacherDoc = db.collection('users');

    String? currentUser = FirebaseAuth.instance.currentUser!.email;

    return FutureBuilder<DocumentSnapshot>(
      future: teacherDoc.doc(currentUser).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (!snapshot.hasData) {
          return Container(
            child: Center(
                // child: CircularProgressIndicator(),
                ),
          );
        }
        print(snapshot.data?.data());
        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF29D09E),
            title: Text('Teacher\'s Account'),
            centerTitle: true,
          ),
          body: Column(
            children: [
              ListTile(
                title: Text("Account Type"),
                subtitle: Text("Teacher"),
              ),
              ListTile(
                title: Text("Email"),
                subtitle: Text(data['Email']),
              ),
              ListTile(
                title: Text("Name"),
                subtitle: Text(data['FirstName'] + ' ' + data['LastName']),
              ),
              ListTile(
                title: Text("Since"),
                subtitle: Text(DateFormat('yyyy-MM-dd')
                    .format((data['Created'] as Timestamp).toDate())),
              )
            ],
          ),
        );
      },
    );
  }
}
