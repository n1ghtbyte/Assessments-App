import 'dart:async';
import 'package:assessments_app/assets/Mypluggin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import "package:assessments_app/utils/Competences.dart";
import 'package:overlay_kit/overlay_kit.dart';

import 'ClassSetup.dart';

class AddCompToClass extends StatefulWidget {
  final String passedClassName;
  final Map passedCompetences;

  const AddCompToClass(this.passedClassName, this.passedCompetences);

  @override
  State<AddCompToClass> createState() => _AddCompToClassState();
}

class _AddCompToClassState extends State<AddCompToClass> {
  Map<String?, List<String?>> _competences =
      ParentChildCheckbox.selectedChildrens;

  String? currentUser = FirebaseAuth.instance.currentUser!.email;
  var topG; //document ID

  List<Text> textify(List x) {
    List<Text> result = [];
    for (var k in x) {
      //print(k);
      if (k != "Name") {
        result.add(Text(
          k.toString(),
        ));
      }
    }

    return result;
  }

  List<Map<String, dynamic>> _comps = [];

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<List<Map<String, dynamic>>> _getCompetences() async {
      final snapshot = await FirebaseFirestore.instance
          .collection(getCompetencesPath())
          .get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    }

    Future<List<Map<String, dynamic>>> _getPrivateCompetences() async {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser)
          .collection('PrivateCompetences')
          .get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    }

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getCompetences(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        _comps = snapshot.data!;

        return FutureBuilder<List<Map<String, dynamic>>>(
          future: _getPrivateCompetences(),
          builder: (context, snapshotprivate) {
            if (snapshotprivate.connectionState == ConnectionState.waiting) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshotprivate.hasError) {
              return Text("Something went wrong");
            }

            _comps.insertAll(0, snapshotprivate.data!);

            // remove the values of passed competences from the list of competences
            for (var i = 0; i < _comps.length; i++) {
              for (var j = 0; j < widget.passedCompetences.length; j++) {
                if (_comps[i]['Name'] ==
                    widget.passedCompetences.keys.toList()[j]) {
                  _comps.removeAt(i);
                }
              }
            }
            return Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context)!.addcomps),
                centerTitle: true,
                backgroundColor: Color(0xFF29D09E),
              ),
              floatingActionButton: FloatingActionButton.extended(
                backgroundColor: Color(0xFF29D09E),
                onPressed: () async {
                  OverlayLoadingProgress.start(
                    widget: Container(
                      width: MediaQuery.of(context).size.width / 4,
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width / 13),
                      child: const AspectRatio(
                        aspectRatio: 1,
                        child: const CircularProgressIndicator(
                          color: Color(0xFF29D09E),
                        ),
                      ),
                    ),
                  );

                  // compute the junction of the two maps and remove the empty values
                  _competences.removeWhere((key, value) => value.isEmpty);
                  var junction = {};
                  junction.addAll(widget.passedCompetences);
                  junction.addAll(_competences);

                  await FirebaseFirestore.instance
                      .collection('classes')
                      .doc(widget.passedClassName)
                      .update(
                    {
                      'Competences': junction,
                    },
                  );

                  await Future.delayed(
                    const Duration(seconds: 1),
                  );

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ClassSetup(passedClassNameSetup: topG.id),
                    ),
                  );

                  //stop the loading
                  OverlayLoadingProgress.stop();
                },
                label: Text(AppLocalizations.of(context)!.add),
                icon: Icon(Icons.add, size: 18),
              ),
              body: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(30),
                      // center
                      alignment: Alignment.center,
                      child: Text(
                        AppLocalizations.of(context)!.addcomps,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 20),
                      ),
                    ),
                    // divider with the green color
                    const SizedBox(height: 10),
                    for (var i = 0; i < _comps.length; i++)
                      ParentChildCheckbox(
                        parentCheckboxColor: Color(0xFF29D09E),
                        childrenCheckboxColor: Color(0xff388e3c),
                        parent: Text(
                          _comps[i]['Name'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        children: textify(
                          _comps[i].keys.toList(),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
