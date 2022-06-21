import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
          print(data);
          return Scaffold(
            appBar: AppBar(
              title: Text('Add Student'),
              centerTitle: true,
              backgroundColor: Color(0xFF29D09E),
            ),
            body: SafeArea(
              child: ListView(
                children: [
                  TextFormField(
                    controller: _controllerJoin,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: Color(0xFF29D09E),
                      ),
                      helperText: 'Enter the Student\'s name',
                      suffixIcon: Icon(Icons.check_circle),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF29D09E)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
