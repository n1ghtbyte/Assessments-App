import 'package:assessments_app/InovWidgets/NavBarParent.dart';
import 'package:assessments_app/pages/Parent/Student/ChildClasses.dart';
import 'package:assessments_app/pages/Student/Classes/StudentClassInside.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ParentMainScreen extends StatefulWidget {
  const ParentMainScreen({Key? key}) : super(key: key);

  @override
  State<ParentMainScreen> createState() => _ParentMainScreenState();
}

class _ParentMainScreenState extends State<ParentMainScreen> {
  String? currentUser = FirebaseAuth.instance.currentUser!.email;

  final _classesStream = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(currentUser).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        Map? data = snapshot.data?.data() as Map?;

        if (data!['children'] == null) {
          return Scaffold(
            drawer: NavBarParent(),
            appBar: AppBar(
              title: Text('Children'),
              centerTitle: true,
              backgroundColor: Color(0xFF29D09E),
            ),
            // floatingActionButton: FloatingActionButton(
            //   child: Icon(Icons.add),
            //   backgroundColor: Color(0xFF29D09E),
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => StudentAddClass(),
            //       ),
            //     );
            //   },
            // ),
            body: Center(
              child: Text(
                "You have no official children",
                style: TextStyle(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else {
          return Scaffold(
            drawer: NavBarParent(),
            appBar: AppBar(
              title: Text('Children'),
              centerTitle: true,
              backgroundColor: Color(0xFF29D09E),
            ),
            body: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: data['children'].length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("${data['children'][index]}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChildClasses(
                          passedEmail: data['children'][index].toString(),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        }
      },
    );
  }
}
