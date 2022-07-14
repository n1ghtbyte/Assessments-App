import 'package:assessments_app/pages/Teacher/Classes/ClassesCreatePage.dart';
import 'package:assessments_app/pages/Teacher/Classes/TurmaExemplo.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
                      builder: (context) => ClassesCreatePage(
                            addMessage: (String message) {},
                          )),
                );
              },
            ),
            body: Center(
              child: Text(
                "Classes will be displayed here, once they are created",
                style: TextStyle(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        // print("pppppppppppppppppppppppppppppppppppppppppp");
        // print(i);

        //print(_comps);
        // print(snp.data?.docs[i].data().runtimeType);

        return Scaffold(
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
                    builder: (context) => ClassesCreatePage(
                          addMessage: (String message) {},
                        )),
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
                    "${data['NumStudents'].toString()} / ${data['MaxStudents'].toString()}\nHash: ${data['documentID'].toString()}"),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
