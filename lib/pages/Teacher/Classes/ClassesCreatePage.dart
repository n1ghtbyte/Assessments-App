import 'dart:async';
import 'package:flutter/material.dart';
import 'package:assessments_app/assets/Mypluggin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClassesCreatePage extends StatefulWidget {
  const ClassesCreatePage({required this.addMessage});

  final FutureOr<void> Function(String message) addMessage;

  @override
  _ClassesCreatePageState createState() => _ClassesCreatePageState();
}

class _ClassesCreatePageState extends State<ClassesCreatePage> {
  late Stream<QuerySnapshot> _stream;

  final _controllerName = TextEditingController();
  final _controllerMaxStudents = TextEditingController();
  Map<String?, List<String?>> _competences =
      ParentChildCheckbox.selectedChildrens;

  CollectionReference classes =
      FirebaseFirestore.instance.collection('classes');

  String? currentUser = FirebaseAuth.instance.currentUser!.email;
  String? _iD;
  Future<void> addClass() {
    // Call the user's CollectionReference to add a new user
    _competences.removeWhere((key, value) => value.isEmpty);
    return classes.add({
      'Created': FieldValue.serverTimestamp(),
      'Name': _controllerName.text, // John Doe
      'TeacherID': currentUser,
      'NumStudents': 0,
      'MaxStudents': _controllerMaxStudents.text, // 42
      'Competences': _competences,
      'StudentList': [],
      'documentID': _iD
    }).then((value) {
      print(value.id);
      updateClass(value.id);
    });
  }

  List<Text> textify(List x) {
    List<Text> result = [];
    for (var k in x) {
      //print(k);
      if (k != "Name") {
        result.add(Text(
          k.toString(),
          // overflow: TextOverflow.ellipsis,
          // softWrap: true,
        ));
      }
    }

    return result;
  }

  Future<void> updateClass(String _docid) {
    return classes
        .doc(_docid)
        .update({'documentID': _docid})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  List<Map<String, dynamic>> _comps = [];
  @override
  void initState() {
    // Only create the stream once
    _stream = FirebaseFirestore.instance.collection('Competences').snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _stream,
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
          print("--------------------------------------------");
          // print(snapshot.data!.docs[0].data()?.toString());
          int actualNumberComp = snapshot.data!.docs.length;
          for (var i = 0; i < actualNumberComp; i++) {
            // print("pppppppppppppppppppppppppppppppppppppppppp");
            // print(i);

            //print(_comps);

            Map<String, dynamic> foo =
                snapshot.data?.docs[i].data()! as Map<String, dynamic>;
            _comps.add(foo);
            // print(foo['Name']);
          }

          return Scaffold(
            appBar: AppBar(
              title: Text('Create a Class'),
              centerTitle: true,
              backgroundColor: Color(0xFF29D09E),
            ),
            body: SafeArea(
              child: ListView(
                children: [
                  TextFormField(
                    controller: _controllerName,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: 'Class Name',
                      labelStyle: TextStyle(
                        color: Color(0xFF29D09E),
                      ),
                      helperText: 'Enter the name that will be displayed',
                      suffixIcon: Icon(
                        Icons.check_circle,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF29D09E)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Divider(
                    thickness: 1,
                    height: 1,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _controllerMaxStudents,
                    decoration: InputDecoration(
                      icon: Icon(Icons.group),
                      labelText: 'Number of pupils',
                      labelStyle: TextStyle(
                        color: Color(0xFF29D09E),
                      ),
                      helperText: 'Enter the number of students',
                      suffixIcon: Icon(
                        Icons.check_circle,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF29D09E)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Divider(
                    thickness: 1,
                    height: 1,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ListTile(
                    leading: Icon(Icons.computer),
                    title: Text("Competences"),
                    subtitle: Text("Choose the indicators"),
                    enabled: true,
                    // trailing: Icon(Icons.arrow_drop_down),
                  ),

                  const SizedBox(
                    height: 16,
                  ),
                  for (var i = 0; i < actualNumberComp; i++)
                    ParentChildCheckbox(
                        parent: Text(
                          _comps[i]['Name'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        children: textify(_comps[i].keys.toList())),

                  // ParentChildCheckbox(
                  //   parent: Text('Critical Thinking'),
                  //   children: [
                  //     Text('Showing critical spirit'),
                  //     Text('Actively participating in discussion'),
                  //   ],
                  //   parentCheckboxColor: Colors.lightBlue,
                  //   childrenCheckboxColor: Colors.greenAccent,
                  // ),

                  // ParentChildCheckbox(
                  //   parent: Text('Creativity'),
                  //   children: [
                  //     Text(
                  //         'Contributing suggestions for the ideas, \nsituations, cases or problems posed'),
                  //     Text(
                  //         'Proposing ideas that are innovative as far\n as contents, development, etc. are concerned'),
                  //   ],
                  //   parentCheckboxColor: Colors.lightBlue,
                  //   childrenCheckboxColor: Colors.pink,
                  // ),
                  // ParentChildCheckbox(
                  //   parent: Text('Interpersonal Communication'),
                  //   children: [
                  //     Text('Listening attentively'),
                  //     Text('Saying what one thinks and feels on a subject'),
                  //   ],
                  //   parentCheckboxColor: Colors.lightBlue,
                  //   childrenCheckboxColor: Colors.pink,
                  // ),
                  // // ElevatedButton.icon(
                  // //   onPressed: () {},
                  // //   icon: Icon(Icons.add, size: 18),
                  // //   label: Text('Create'),

                  // // ),
                  // const SizedBox(
                  //   height: 32,
                  // ),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.white,
                      primary: Color(0xFF29D09E),
                    ),
                    onPressed: () {
                      addClass();
                      // print("kiki");
                      // print(ParentChildCheckbox.selectedChildrens.toString());

                      // print(_competences.toString());
                      // print(ParentChildCheckbox.selectedChildrens.entries);
                      // print("koko");
                      // print(_weights);

                      Navigator.pop(context);
                    },
                    // Navigator.pop(context);

                    // final snackBar = SnackBar(
                    //     content: Text(
                    //         'The login credentials will be sent to your email :)'));
                    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    label: Text('Create'),
                    icon: Icon(Icons.add, size: 18),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
