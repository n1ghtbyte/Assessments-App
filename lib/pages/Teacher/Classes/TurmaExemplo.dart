import 'package:assessments_app/pages/Teacher/Assessments/GenPeerAssessment.dart';
import 'package:assessments_app/pages/Teacher/Assessments/GenSummAssessment.dart';
import 'package:assessments_app/pages/Teacher/Classes/AddCompToClass.dart';
import 'package:assessments_app/pages/Teacher/Classes/AstaGraphs.dart';
import 'package:assessments_app/pages/Teacher/Classes/AddStudentClass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:assessments_app/pages/Teacher/Assessments/GenFormAssessment.dart';

import 'package:assessments_app/pages/Teacher/Classes/ClassSetup.dart';
import 'package:assessments_app/pages/Teacher/Classes/ClassesSettingsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../Assessments/AssessmentCheck.dart';
import '../Assessments/AssessmentFormative.dart';

enum _MenuValues {
  CompetenceAdd,
  AddStuddent,
  Setup,
  Settings,
}

class TurmaExemplo extends StatefulWidget {
  final String passedClassName;

  const TurmaExemplo(this.passedClassName);

  @override
  State<TurmaExemplo> createState() => _TurmaExemploState();
}

class _TurmaExemploState extends State<TurmaExemplo>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _textFieldController = TextEditingController();
  Future<void> _displayTextInputDialog(
      BuildContext context, String docId) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.formasse),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.formative +
                      " " +
                      AppLocalizations.of(context)!.name),
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.green,
                textColor: Colors.white,
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    db.collection("assessments").doc(docId).update({
                      "Name": valueText
                    }).then(
                        (value) =>
                            print("Updated form name successfully updated!"),
                        onError: (e) => print("Error updating document $e"));
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  String? codeDialog;
  String? valueText;

  @override
  bool get wantKeepAlive => true;
  String? currentUser = FirebaseAuth.instance.currentUser!.email;
  final db = FirebaseFirestore.instance;
  late CollectionReference _class = db.collection('classes');
  Map<dynamic, dynamic> namedStuds = {};

  bool done = false;

  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final _assessClassStream = db
        .collection('assessments')
        .where('ClassId', isEqualTo: widget.passedClassName)
        .where('Type', isEqualTo: 'Formative')
        .orderBy('Created', descending: true);

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
        Map competences = data['Competences'];

        if (data['StudentList'].isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.classConcept +
                  "${data['Name'].toString()}"),
              centerTitle: true,
              backgroundColor: Color(0xFF29D09E),
              actions: [
                PopupMenuButton<_MenuValues>(
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      child: Text(AppLocalizations.of(context)!.addstud),
                      value: _MenuValues.AddStuddent,
                    ),
                    PopupMenuItem(
                      child: Text(AppLocalizations.of(context)!.addcomps),
                      value: _MenuValues.CompetenceAdd,
                    ),
                    PopupMenuItem(
                      child: Text(AppLocalizations.of(context)!.setupweights),
                      value: _MenuValues.Setup,
                    ),
                    PopupMenuItem(
                      child: Text(AppLocalizations.of(context)!.settings),
                      value: _MenuValues.Settings,
                    ),
                  ],
                  onSelected: (value) {
                    switch (value) {
                      case _MenuValues.CompetenceAdd:
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (c) => AddCompToClass(
                                    widget.passedClassName, competences)))
                            .then((value) => setState(() {}));
                        break;
                      case _MenuValues.AddStuddent:
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (c) =>
                                    AddStudentToClass(widget.passedClassName)))
                            .then((value) => setState(() {}));
                        break;
                      case _MenuValues.Settings:
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (c) =>
                                ClassesSettingsPage(widget.passedClassName)));
                        break;
                      case _MenuValues.Setup:
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (c) => ClassSetup(
                                  passedClassNameSetup: widget.passedClassName,
                                )));
                        break;
                    }
                  },
                ),
              ],
            ),
            body: Center(
              child: Text(
                AppLocalizations.of(context)!.classtip2,
                style: TextStyle(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else {
          return StreamBuilder<QuerySnapshot>(
            stream: db.collection('users').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snp) {
              if (snp.hasError) {
                return Text('Something went wrong');
              }
              return StreamBuilder<QuerySnapshot>(
                stream: _assessClassStream.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snpAssess) {
                  if (snpAssess.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snpAssess.connectionState == ConnectionState.waiting ||
                      snpAssess.data!.docs
                          .any((element) => element['Created'] == null)) {
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(value: 80),
                      ),
                    );
                  }

                  var x = snp.data?.size;
                  List<dynamic> studs = data['StudentList'];

                  print("::::::::::::::::::");
                  print(studs);

                  for (var i = 0; i < x!; i++) {
                    Map<String, dynamic> foo =
                        snp.data?.docs[i].data()! as Map<String, dynamic>;
                    print(foo);
                    if (studs.contains(foo['Email'])) {
                      print(foo);
                      print(i);

                      namedStuds[foo['Email'].toString()] =
                          foo['FirstName'].toString() +
                              " " +
                              foo['LastName'].toString();
                    }
                  }

                  for (var i in studs) {
                    if (!namedStuds.containsKey(i)) {
                      namedStuds[i.toString()] = i.toString();
                    }
                  }

                  studs.sort((a, b) {
                    //sorting in descending order
                    return a.compareTo(b);
                  });
                  done = true;
                  Map competences = data['Competences'];
                  //print(data['StudentsList'].runtimeType);
                  return DefaultTabController(
                    length: 3,
                    child: Scaffold(
                      appBar: AppBar(
                        bottom: const TabBar(
                          indicatorColor: Colors.green,
                          tabs: [
                            Tab(
                              icon: Icon(Icons.people),
                            ),
                            Tab(
                              icon: Icon(Icons.school),
                            ),
                            Tab(
                              icon: Icon(Icons.info),
                            ),
                          ],
                        ),
                        title: Text(
                            "${AppLocalizations.of(context)!.classConcept} ${data['Name'].toString()}"),
                        centerTitle: true,
                        actions: [
                          PopupMenuButton<_MenuValues>(
                            icon: Icon(Icons.more_vert),
                            itemBuilder: (BuildContext context) => [
                              PopupMenuItem(
                                child:
                                    Text(AppLocalizations.of(context)!.addstud),
                                value: _MenuValues.AddStuddent,
                              ),
                              PopupMenuItem(
                                child: Text(
                                    AppLocalizations.of(context)!.addcomps),
                                value: _MenuValues.CompetenceAdd,
                              ),
                              PopupMenuItem(
                                child: Text(
                                    AppLocalizations.of(context)!.setupweights),
                                value: _MenuValues.Setup,
                              ),
                              PopupMenuItem(
                                child: Text(
                                    AppLocalizations.of(context)!.settings),
                                value: _MenuValues.Settings,
                              ),
                            ],
                            onSelected: (value) {
                              switch (value) {
                                case _MenuValues.CompetenceAdd:
                                  Navigator.of(context)
                                      .push(
                                        MaterialPageRoute(
                                          builder: (c) => AddCompToClass(
                                              widget.passedClassName,
                                              competences),
                                        ),
                                      )
                                      .then(
                                        (value) => setState(
                                          () {},
                                        ),
                                      );
                                  break;
                                case _MenuValues.AddStuddent:
                                  Navigator.of(context)
                                      .push(
                                        MaterialPageRoute(
                                          builder: (c) => AddStudentToClass(
                                              widget.passedClassName),
                                        ),
                                      )
                                      .then(
                                        (value) => setState(() {}),
                                      );
                                  break;
                                case _MenuValues.Settings:
                                  Navigator.of(context)
                                      .push(
                                        MaterialPageRoute(
                                          builder: (c) => ClassesSettingsPage(
                                              widget.passedClassName),
                                        ),
                                      )
                                      .then(
                                        (value) => setState(
                                          () {},
                                        ),
                                      );
                                  break;
                                case _MenuValues.Setup:
                                  Navigator.of(context)
                                      .pushReplacement(
                                        MaterialPageRoute(
                                          builder: (c) => ClassSetup(
                                            passedClassNameSetup:
                                                widget.passedClassName,
                                          ),
                                        ),
                                      )
                                      .then(
                                        (value) => setState(
                                          () {},
                                        ),
                                      );
                                  break;
                              }
                            },
                          ),
                        ],
                        backgroundColor: Color(0xFF29D09E),
                      ),
                      floatingActionButton: SpeedDial(
                        icon: Icons.assessment,
                        activeIcon: Icons.arrow_back,
                        spacing: 5,
                        openCloseDial: isDialOpen,
                        curve: Curves.bounceInOut,
                        childPadding: const EdgeInsets.all(5),
                        spaceBetweenChildren: 4,
                        backgroundColor: Color(0xFF29D09E),
                        foregroundColor: Color.fromARGB(255, 255, 255, 255),
                        overlayColor: Colors.black,
                        elevation: 8.0,
                        onOpen: () => debugPrint('OPENING DIAL'),
                        onClose: () => debugPrint('DIAL CLOSED'),
                        shape: CircleBorder(),
                        children: [
                          SpeedDialChild(
                            child: Icon(Icons.summarize),
                            backgroundColor: Color(0xFF29D09E),
                            label: AppLocalizations.of(context)!.summative,
                            elevation: 5.0,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      GenSummAssessment(widget.passedClassName),
                                ),
                              ).then(
                                (value) => setState(
                                  () {},
                                ),
                              );
                            },
                          ),
                          SpeedDialChild(
                              child: Icon(Icons.self_improvement),
                              backgroundColor:
                                  Color.fromARGB(135, 41, 208, 158),
                              label: AppLocalizations.of(context)!.self,
                              elevation: 5.0),
                          SpeedDialChild(
                            child: Icon(Icons.group),
                            backgroundColor: Color(0xFF29D09E),
                            label: AppLocalizations.of(context)!.peer,
                            elevation: 5.0,
                            onTap: () {
                              print(widget.passedClassName);
                              print(data['Name']);
                              print(competences);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GenPeerAssessment(
                                      widget.passedClassName,
                                      data['Name'].toString(),
                                      competences,
                                      data['StudentList']),
                                ),
                              ).then(
                                (value) => setState(
                                  () {},
                                ),
                              );
                            },
                          ),
                          SpeedDialChild(
                            child: Icon(Icons.quiz),
                            backgroundColor: Color(0xFF29D09E),
                            label: AppLocalizations.of(context)!.formative,
                            elevation: 5.0,
                            onTap: () {
                              print(widget.passedClassName);
                              print(data['Name']);
                              print(competences);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GenFormAssessment(
                                      widget.passedClassName,
                                      data['Name'].toString(),
                                      competences,
                                      "class"),
                                ),
                              ).then(
                                (value) => setState(
                                  () {},
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      body: TabBarView(
                        children: [
                          SafeArea(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(height: 16),
                                Container(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    AppLocalizations.of(context)!.classstuds,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: studs.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        title: Text(
                                            namedStuds[studs[index].toString()]
                                                .toString()),
                                        subtitle: studs[index] ==
                                                namedStuds[
                                                    studs[index].toString()]
                                            ? Text("")
                                            : Text(studs[index]),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AstaGraphs(
                                                passedClassName: data['Name'],
                                                passedClassId:
                                                    data['documentID'],
                                                passedLegitName:
                                                    namedStuds[studs[index]],
                                                passedEmail: studs[index],
                                                passedCompetences: competences,
                                              ),
                                            ),
                                          ).then(
                                            (value) => setState(
                                              () {},
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(height: 16),
                              Container(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  AppLocalizations.of(context)!.assessments,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Expanded(
                                child: ListView(
                                  children: snpAssess.data!.docs
                                      .map((DocumentSnapshot document) {
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;
                                    return ListTile(
                                      trailing: Wrap(
                                        spacing: -16,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 20.0,
                                            ),
                                            onPressed: () {
                                              _displayTextInputDialog(
                                                  context, data['documentID']);
                                            },
                                          ),
                                          data['Count'] == 0
                                              ? IconButton(
                                                  icon: Icon(
                                                    Icons.delete,
                                                    size: 20.0,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () {
                                                    db
                                                        .collection(
                                                            "assessments")
                                                        .doc(data['documentID'])
                                                        .delete()
                                                        .then(
                                                          (doc) => print(
                                                              "Document deleted"),
                                                          onError: (e) => print(
                                                              "Error updating document $e"),
                                                        );
                                                  },
                                                )
                                              : IconButton(
                                                  icon: Icon(
                                                    Icons.delete,
                                                    size: 0.0,
                                                    color: Colors.grey,
                                                  ),
                                                  onPressed: null),
                                        ],
                                      ),
                                      onTap: () {
                                        if (data['Type'] == 'Formative' &&
                                            data['DONE'] == false) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AssessmentFormative(
                                                passedAssessmentIdName:
                                                    data['documentID'],
                                              ),
                                            ),
                                          ).then((value) => setState(() {}));
                                        }
                                        if (data['Type'] == 'Formative' &&
                                            data['DONE'] == true) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AssessmentCheck(
                                                passedAssessmentIdName:
                                                    data['documentID'],
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      leading: Icon(Icons.assessment),
                                      isThreeLine: true,
                                      textColor: data['DONE'] == false
                                          ? Color(0xFF29D09E)
                                          : Color.fromARGB(255, 123, 123, 123),
                                      title: Text('${data['Name']}'),
                                      subtitle: data['Target'].toString() ==
                                              'Single'
                                          ? Text(
                                              "${AppLocalizations.of(context)!.student}: ${data['Students'].keys.toList()[0].toString()}\n${AppLocalizations.of(context)!.date}: ${DateFormat('yyyy-MM-dd').format((data['Created'] as Timestamp).toDate())}")
                                          : Text(
                                              "${AppLocalizations.of(context)!.done}: ${data['Count'].toString()}/${data['Students'].values.toList().length}\n${AppLocalizations.of(context)!.date}: ${DateFormat('yyyy-MM-dd').format((data['Created'] as Timestamp).toDate())}"),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                          SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(height: 16),
                                Container(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(
                                    AppLocalizations.of(context)!.wec,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount:
                                      data['Competences'].keys.toList().length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(
                                        data['Competences']
                                            .keys
                                            .toList()[index],
                                      ),
                                      subtitle: Text(
                                        data['Weights'][data['Competences']
                                                    .keys
                                                    .toList()[index]]
                                                .toString() +
                                            " %",
                                      ),
                                    );
                                  },
                                ),
                              ],
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
      },
    );
  }
}
