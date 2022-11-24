import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddStudentToClass extends StatefulWidget {
  final String passedClassName;

  const AddStudentToClass(this.passedClassName);

  @override
  State<AddStudentToClass> createState() => _AddStudentToClassState();
}

class _AddStudentToClassState extends State<AddStudentToClass> {
  final _controllerJoin = TextEditingController();
  @override
  void dispose() {
    _controllerJoin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late CollectionReference _class =
        FirebaseFirestore.instance.collection('classes');
    return FutureBuilder<DocumentSnapshot>(
      future: _class.doc(widget.passedClassName).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (!snapshot.hasData) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
        print(data['StudentList'].length);
        return Scaffold(
          appBar: AppBar(
            title: Text('Add Student'),
            centerTitle: true,
            backgroundColor: Color(0xFF29D09E),
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: const Color(0xFF29D09E),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('classes')
                  .doc(widget.passedClassName)
                  .get()
                  .then((DocumentSnapshot documentSnapshot) {
                if (documentSnapshot.exists) {
                  var num = documentSnapshot['NumStudents'] + 1;
                  List<dynamic> tmp = documentSnapshot['StudentList'];
                  tmp.add(_controllerJoin.text.toString());
                  print(_controllerJoin.text.toString());
                  print(tmp);
                  FirebaseFirestore.instance
                      .collection('classes')
                      .doc(widget.passedClassName)
                      .update({'StudentList': tmp});

                  FirebaseFirestore.instance
                      .collection('classes')
                      .doc(widget.passedClassName)
                      .update({'NumStudents': (num)});

                  Navigator.of(context).pop();
                } else {
                  final snackBar = SnackBar(content: Text('NANI KORE DAYO!?'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              });
              // Navigator.pop(context);
              // Respond to button press
            },
            icon: Icon(Icons.add),
            label: Text('Add'),
          ),
          body: SafeArea(
            child: ListView(
              children: [
                TextFormField(
                  controller: _controllerJoin,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'Student Name',
                    labelStyle: TextStyle(
                      color: Color(0xFF29D09E),
                    ),
                    helperText: 'Enter the name of the student',
                    suffixIcon: Icon(
                      Icons.check_circle,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF29D09E)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
