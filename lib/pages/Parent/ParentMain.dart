import 'package:assessments_app/InovWidgets/NavBarParent.dart';
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

  final _classesStream = FirebaseFirestore.instance
      .collection('classes')
      .where('StudentList',
          arrayContains: FirebaseAuth.instance.currentUser!.email)
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
            drawer: NavBarParent(),
            appBar: AppBar(
              title: Text('Classes'),
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
                "Classes will be displayed here once your children join any",
                style: TextStyle(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return Scaffold(
          drawer: NavBarParent(),
          appBar: AppBar(
            title: Text('Classes'),
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
                        builder: (context) => StudentClassInside(
                            passedClassId: data['documentID'].toString(),
                            passedClassName: data['Name'].toString(),
                            passedEmail: currentUser.toString(),
                            passedCompetences: data['Competences'])),
                  );
                },
                leading: Icon(Icons.school),
                isThreeLine: true,
                title: Text(data['Name']),
                subtitle: Text(
                    "${data['NumStudents'].toString()} / ${data['MaxStudents'].toString()}\nHash: ${data['documentID'].toString()}"),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
