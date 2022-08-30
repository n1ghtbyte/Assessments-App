import 'package:assessments_app/pages/Teacher/Classes/ClassesPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClassesSettingsPage extends StatefulWidget {
  final String passedClassName;

  const ClassesSettingsPage(this.passedClassName);

  @override
  State<ClassesSettingsPage> createState() => _ClassesSettingsPageState();
}

class _ClassesSettingsPageState extends State<ClassesSettingsPage> {
  final nameController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Class Settings'),
        centerTitle: true,
        backgroundColor: Color(0xFF29D09E),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                icon: Icon(Icons.school),
                labelText: 'Change class name',
                labelStyle: TextStyle(
                  color: Color(0xFF29D09E),
                ),
                helperText: 'Year ID',
                suffixIcon: Icon(
                  Icons.check_circle,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF29D09E)),
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              width: double.infinity,
              child: RawMaterialButton(
                child: Text('Change the class\'s name'),
                onPressed: () {
                  var collection =
                      FirebaseFirestore.instance.collection('/classes');
                  collection
                      .doc(widget
                          .passedClassName) // <-- Doc ID where data should be updated.
                      .update({'Name': nameController.text}) // <-- Updated data
                      .then((_) => print('Updated'))
                      .catchError((error) => print('Update failed: $error'));
                  Navigator.pop(context);
                },
              ),
            ),
            Container(
                alignment: Alignment.bottomCenter,
                width: double.infinity,
                child: RawMaterialButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Text("Delete this class"),
                              content: Text(
                                  'Are you sure you wish to delete this class and delete all their assesments?'),
                              actions: [
                                TextButton(
                                  style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.blue),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                  child: Text('CANCEL'),
                                ),
                                TextButton(
                                  style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.blue),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    final collection = FirebaseFirestore
                                        .instance
                                        .collection('/classes');
                                    collection
                                        .doc(widget
                                            .passedClassName) // <-- Doc ID to be deleted.
                                        .delete() // <-- Delete
                                        .then((_) => print('Deleted'))
                                        .catchError((error) =>
                                            print('Delete failed: $error'));
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ClassesPage()));
                                  },
                                  child: Text(
                                    'DELETE',
                                  ),
                                ),
                              ],
                            ));
                  },
                  child: Text(
                    "Delete Class",
                    style: TextStyle(color: Colors.red, fontSize: 18.0),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
