import 'package:assessments_app/pages/Teacher/Classes/ClassesPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClassesSettingsPage extends StatefulWidget {
  final String passedClassName;

  const ClassesSettingsPage(this.passedClassName);

  @override
  State<ClassesSettingsPage> createState() => _ClassesSettingsPageState();
}

class _ClassesSettingsPageState extends State<ClassesSettingsPage> {
  final nameController = TextEditingController();
  final collectionClasses = FirebaseFirestore.instance.collection('/classes');
  final collectionAssessments =
      FirebaseFirestore.instance.collection('/assessments');

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
        title: Text(AppLocalizations.of(context)!.classsettings),
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
                labelText: AppLocalizations.of(context)!.changename,
                labelStyle: TextStyle(
                  color: Color(0xFF29D09E),
                ),
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
                child: Text(AppLocalizations.of(context)!.changeclassname),
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
                            title:
                                Text(AppLocalizations.of(context)!.killclass),
                            content: Text(AppLocalizations.of(context)!
                                .killclassandassess),
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
                                child:
                                    Text(AppLocalizations.of(context)!.cancel),
                              ),
                              TextButton(
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blue),
                                ),
                                onPressed: () async {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();

                                  // Delete the class from /classes
                                  // This does not removed subcollections

                                  await collectionClasses
                                      .doc(widget
                                          .passedClassName) // <-- Doc ID to be deleted.
                                      .delete() // <-- Delete
                                      .then((_) => print('Deleted'))
                                      .catchError((error) =>
                                          print('Delete failed: $error'));

                                  // Delete assessments in /assessments

                                  await collectionAssessments
                                      .where("ClassId",
                                          isEqualTo:
                                              widget.passedClassName.toString())
                                      .get()
                                      .then(
                                    (querySnapshot) {
                                      querySnapshot.docs.forEach(
                                        (doc) {
                                          doc.reference.delete();
                                        },
                                      );
                                    },
                                    onError: (e) => print("Error deleting: $e"),
                                  );

                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => ClassesPage()));
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.cancel,
                                ),
                              ),
                            ],
                          ));
                },
                child: Text(
                  AppLocalizations.of(context)!.delete,
                  style: TextStyle(color: Colors.red, fontSize: 18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
