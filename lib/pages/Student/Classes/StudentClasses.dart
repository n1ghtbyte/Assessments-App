import 'package:assessments_app/InovWidgets/NavBarStudent.dart';
import 'package:assessments_app/pages/Student/Classes/StudentAddClass.dart';
import 'package:assessments_app/pages/Student/Classes/StudentClassInside.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudClassesMain extends StatefulWidget {
  const StudClassesMain({Key? key}) : super(key: key);

  @override
  State<StudClassesMain> createState() => _StudClassesMainState();
}

class _StudClassesMainState extends State<StudClassesMain> {
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
            drawer: NavBarStudent(),
            appBar: AppBar(
              title: Text('Classes'),
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
                    builder: (context) => StudentAddClass(),
                  ),
                );
              },
            ),
            body: Center(
              child: Text(
                "Classes will be displayed here, once you join any",
                style: TextStyle(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return Scaffold(
          drawer: NavBarStudent(),
          appBar: AppBar(
            title: Text('Classes'),
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
                  builder: (context) => StudentAddClass(),
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
                        builder: (context) => StudentClassInside(
                            passedClassId: data['documentID'].toString(),
                            passedClassName: data['Name'].toString(),
                            passedEmail: currentUser.toString(),
                            passedWeights: data['Weights'],
                            passedCompetences: data['Competences'])),
                  );
                },
                leading: Icon(Icons.school),
                isThreeLine: true,
                title: Text(data['Name']),
                subtitle: Text(
                    "Students: ${data['NumStudents'].toString()} \nClass Code: ${data['documentID'].toString()}"),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
