import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import 'package:assessments_app/InovWidgets/ChartData.dart';
import 'package:assessments_app/InovWidgets/LegendWidget.dart';
import 'package:assessments_app/pages/Teacher/Assessments/AssessmentCheck.dart';
import 'package:assessments_app/pages/Teacher/Assessments/AssessmentFormative.dart';
import 'package:assessments_app/pages/Teacher/Assessments/GenFormAssessment.dart';
import 'package:assessments_app/pages/Teacher/Assessments/GenMultipleSelfAssessments.dart';
import 'package:assessments_app/pages/Teacher/Assessments/GenPeerAssessment.dart';
import 'package:assessments_app/pages/Teacher/Assessments/GenSummAssessment.dart';
import 'package:assessments_app/pages/Teacher/Classes/AddCompToClass.dart';
import 'package:assessments_app/pages/Teacher/Classes/AddStudentClass.dart';
import 'package:assessments_app/pages/Teacher/Classes/AstaGraphs.dart';
import 'package:assessments_app/pages/Teacher/Classes/ClassReport.dart';
import 'package:assessments_app/pages/Teacher/Classes/ClassSetup.dart';
import 'package:assessments_app/pages/Teacher/Classes/ClassesSettingsPage.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  bool vis = false;
  Map<String, List<DataItem>> _bigData = {};
  Map<String, int> _comp2cardinal = {};
  Map<String, List<PointLinex>> _smallData = {};
  Map<String, List<PointLinex>> _finalData = {};
  Map<String, List<PointLinex>> averagedPointLinexList = {};
  List<bool> _customTileExpanded = List<bool>.filled(15, false);

  TextEditingController _textFieldController = TextEditingController();
  Map<String, int> _leTitles = {};

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
                setState(
                  () {
                    db.collection("assessments").doc(docId).update({
                      "Name": valueText
                    }).then(
                        (value) =>
                            print("Updated form name successfully updated!"),
                        onError: (e) => print("Error updating document $e"));
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, List<PointLinex>>> _fetchFormativeData(
      var stds, var comps, var assess) async {
    for (var ini in comps.keys) {
      _finalData[ini] = [];
    }
    int indicatorToHash(String indicator) {
      int _sum = 0;

      var foo = utf8.encode(indicator);
      for (var k in foo) {
        _sum += k;
      }
      _leTitles[indicator] = _sum;
      return _sum;
    }

    for (String user in stds) {
      var _ind = 0;
      var _max = 0;

      QuerySnapshot formativeSnapshot = await FirebaseFirestore.instance
          .collection('classes')
          .doc(widget.passedClassName)
          .collection('grading')
          .doc(user)
          .collection('formative')
          .get();

      var faa = formativeSnapshot.docs;
      faa.sort((a, b) {
        return a['Created'].compareTo(b['Created']);
      });

      double fakeIndex = 0;
      Map<String, bool> tt = {};

      //init
      for (var ini in comps.keys) {
        _bigData[ini] = [];
        _smallData[ini] = [];
        for (var bar in comps[ini]) {
          tt[bar] = false;
        }
      }
      for (var _doc in faa) {
        var foo = _doc.data()! as Map<dynamic, dynamic>;

        List<double> helper = [];
        // for each competence in a given assessment

        for (var comp in foo['Competences'].keys) {
          _ind = 0;

          for (var indicator in foo['Competences'][comp].keys) {
            print(foo['Competences'][comp][indicator]);

            helper.add(double.parse(foo['Competences'][comp][indicator]));

            if (_bigData[comp]!.isEmpty || !tt[indicator]!) {
              vis = true;
              _bigData[comp]?.add(DataItem(
                  index: _ind,
                  hash: indicatorToHash(indicator),
                  x: indicator,
                  y: [foo['Competences'][comp][indicator]]));
            } else {
              for (var i = 0; i < _bigData[comp]!.length; i++) {
                if (_bigData[comp]![i].x == indicator) {
                  var tempora = _bigData[comp]![i].y;
                  print(tempora);
                  tempora.add(foo['Competences'][comp][indicator]);
                  _bigData[comp]![i].y = tempora;
                }
              }
            }
            _ind++;
            tt[indicator] = true;
          }

          var _res = helper.average;
          // VERIFICAR SE O DOC ESTA EM QUAL LISTA PEAR SELF FORM

          _finalData[comp]?.add(PointLinex(
              index: fakeIndex,
              hash: indicatorToHash(comp),
              competence: comp,
              value: _res,
              type: foo['AssessID'],
              timestampDate: foo['Created']));

          _smallData[comp]?.add(PointLinex(
              index: fakeIndex,
              hash: indicatorToHash(comp),
              competence: comp,
              value: _res,
              type: foo['AssessID'],
              timestampDate: foo['Created']));

          _ind = 0;
          helper = [];
        }
        fakeIndex++;
      }

      var thevalue = 0;

      _smallData.forEach((k, v) {
        if (v.length > thevalue) {
          thevalue = v.length;
        }
      });

      for (var comp in comps.keys) {
        for (var i = 0; i < _bigData[comp]!.length; i++) {
          if (_bigData[comp]![i].y.length > _max) {
            _max = _bigData[comp]![i].y.length;
          }
        }
        _comp2cardinal[comp] = _max;
        _max = 0;
      }
    }

    for (var x in comps.keys) {
      Map<String, Map<String, List<double>>> typeToValuesMap = {};
      typeToValuesMap[x] = {};
      averagedPointLinexList[x] = [];

      for (PointLinex pointLinex in _finalData[x]!) {
        if (!typeToValuesMap[x]!.containsKey(pointLinex.type)) {
          typeToValuesMap[x]![pointLinex.type] = [pointLinex.value];
        } else {
          typeToValuesMap[x]![pointLinex.type]!.add(pointLinex.value);
        }
      }

      // Initialize a Timestamp object from the DateTime
      typeToValuesMap[x]!.forEach((type, values) {
        DocumentSnapshot doc =
            assess.firstWhere((document) => document['documentID'] == type);

        double sum = values.reduce((a, b) => a + b);
        double averageValue = sum / values.length;
        print(values.first);

        print(assess);

        print(doc['Created']);
        print(assess.indexOf(assess
            .firstWhere((document) => document['Created'] == doc['Created'])));
        print(assess.length);
        print(assess);
        var kappa = assess.indexOf(assess
            .firstWhere((document) => document['Created'] == doc['Created']));
        var indd = assess.length - kappa;

        // Create a new PointLinex object with the averaged value
        PointLinex averagedPointLinex = PointLinex(
          index: double.parse(indd.toString()) -
              1, // You might need to adjust this
          hash: indicatorToHash(x), // You might need to adjust this
          competence: x, // You might need to adjust this
          value: averageValue,
          type: type,
          timestampDate: doc['Created'], // You might need to adjust this
        );
        averagedPointLinexList[x]!.add(averagedPointLinex);
      });

      print('Averaged PointLinex objects:');
      for (PointLinex averagedPoint in averagedPointLinexList[x]!) {
        print(
            'Type: $x ${averagedPoint.type}, Average Value: ${averagedPoint.value}');
      }
      averagedPointLinexList[x]!.sort((a, b) {
        return a.index.compareTo(b.index);
      });
    }

    return averagedPointLinexList;
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
                  ' ' +
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
                        Navigator.of(context).push(MaterialPageRoute(
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
          // HERE
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
                                      .push(
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
                            child: Icon(Icons.print),
                            backgroundColor: Color(0xFF29D09E),
                            visible: vis,
                            label: "PDF",
                            elevation: 5.0,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PdfPreview(
                                    canChangeOrientation: false,
                                    canChangePageFormat: false,
                                    canDebug: false,
                                    initialPageFormat: PdfPageFormat.a4,
                                    pdfFileName: "ASSESS.pdf",
                                    build: (format) => generateClassReport(
                                        _bigData,
                                        averagedPointLinexList,
                                        [
                                          data['Name'],
                                        ],
                                        context),
                                  ),
                                ),
                              );
                            },
                          ),
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
                            backgroundColor: Color(0xFF29D09E),
                            label: AppLocalizations.of(context)!.self,
                            elevation: 5.0,
                            onTap: () {
                              print(widget.passedClassName);
                              print(data['Name']);
                              print(competences);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      GenMultipleSelfAssessment(
                                    widget.passedClassName,
                                    data['Name'].toString(),
                                    competences,
                                    data['StudentList'],
                                  ),
                                ),
                              ).then(
                                (value) => setState(
                                  () {},
                                ),
                              );
                            },
                          ),
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
                                        onLongPress: () {
                                          showDialog(
                                              context: context,
                                              builder: (_) => AlertDialog(
                                                    title: Text(
                                                        "Delete this student"),
                                                    content: Text(
                                                        "Are you sure you want to remove this?"),
                                                    actions: [
                                                      TextButton(
                                                        style: ButtonStyle(
                                                          foregroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(
                                                                      Colors
                                                                          .blue),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .cancel),
                                                      ),
                                                      TextButton(
                                                        style: ButtonStyle(
                                                          foregroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(
                                                                      Colors
                                                                          .blue),
                                                        ),
                                                        onPressed: () async {
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pop();
                                                          var x;
                                                          if (studs[index] !=
                                                              namedStuds[studs[
                                                                      index]
                                                                  .toString()]) {
                                                            x = studs[index]
                                                                .toString();
                                                          } else {
                                                            x = namedStuds[studs[
                                                                        index]
                                                                    .toString()]
                                                                .toString();
                                                          }
                                                          print(x);

                                                          // Delete the class from /classes
                                                          // This does not removed subcollections

                                                          // Delete assessments in /assessments

                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'classes')
                                                              .doc(widget
                                                                  .passedClassName)
                                                              .update({
                                                            'StudentList':
                                                                FieldValue
                                                                    .arrayRemove(
                                                                        [x]),
                                                          });
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'classes')
                                                              .doc(widget
                                                                  .passedClassName)
                                                              .update({
                                                            'NumStudents':
                                                                FieldValue
                                                                    .increment(
                                                                        -1),
                                                          });
                                                          setState(() {});
                                                        },
                                                        child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .delete,
                                                        ),
                                                      ),
                                                    ],
                                                  ));
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
                                              "${AppLocalizations.of(context)!.student}: ${data['Students'].keys.toList()[0].toString()}\n${AppLocalizations.of(context)!.date}: ${DateFormat('dd-MM-yyyy').format((data['Created'] as Timestamp).toDate())}")
                                          : Text(
                                              "${AppLocalizations.of(context)!.done}: ${data['Count'].toString()}/${data['Students'].values.toList().length}\n${AppLocalizations.of(context)!.date}: ${DateFormat('dd-MM-yyyy').format((data['Created'] as Timestamp).toDate())}"),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                          SingleChildScrollView(
                            child: FutureBuilder<Map<String, List<PointLinex>>>(
                              future: _fetchFormativeData(
                                  studs, competences, snpAssess.data!.docs),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Text('No formative data found.');
                                } else {
                                  return SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 16),
                                        Container(
                                          padding: EdgeInsets.all(20.0),
                                          child: Text(
                                            AppLocalizations.of(context)!.wec,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        data['Weights'][data['Competences']
                                                    .keys
                                                    .toList()[0]] !=
                                                null
                                            ? ListView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: data['Competences']
                                                    .keys
                                                    .toList()
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  return ExpansionTile(
                                                    trailing: Icon(
                                                      _customTileExpanded[index]
                                                          ? Icons
                                                              .arrow_drop_down_circle
                                                          : Icons
                                                              .arrow_drop_down,
                                                    ),
                                                    title: Text(
                                                        data['Competences']
                                                            .keys
                                                            .toList()[index]),
                                                    subtitle: Text(data[
                                                                'Weights'][data[
                                                                    'Competences']
                                                                .keys
                                                                .toList()[index]]
                                                            .toString() +
                                                        "%"),
                                                    children: [
                                                      ListView.builder(
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount: data[
                                                                'Competences'][data[
                                                                    'Competences']
                                                                .keys
                                                                .toList()[index]]
                                                            .length,
                                                        itemBuilder:
                                                            (context, xipidi) {
                                                          return ListTile(
                                                            title: Text(data[
                                                                'Competences'][data[
                                                                        'Competences']
                                                                    .keys
                                                                    .toList()[
                                                                index]][xipidi]),
                                                            dense: true,
                                                            visualDensity:
                                                                VisualDensity
                                                                    .adaptivePlatformDensity,
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              )
                                            : Text("0%\n\n"),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .classprog,
                                          style: TextStyle(
                                              fontSize: 21,
                                              fontWeight: FontWeight.w400),
                                          textAlign: TextAlign.left,
                                        ),
                                        const SizedBox(height: 8),
                                        LegendsListWidget(
                                          legends: [
                                            for (var i in competences.keys)
                                              Legend(i, getColourFromComp(i)),
                                          ],
                                        ),
                                        const SizedBox(height: 14),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                left: 50,
                                                right: 100,
                                                top: 100,
                                                bottom: 40),
                                            height: 350,
                                            width: 460,
                                            child: LineChart(
                                              LineChartData(
                                                titlesData: FlTitlesData(
                                                  bottomTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                          showTitles: false)),
                                                  leftTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                          showTitles: true)),
                                                  topTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                          showTitles: false)),
                                                  rightTitles: AxisTitles(
                                                      sideTitles: SideTitles(
                                                          showTitles: false)),
                                                ),
                                                minY: 0,
                                                maxY: 5,
                                                gridData: FlGridData(
                                                    show: true,
                                                    drawHorizontalLine: true,
                                                    drawVerticalLine: true),
                                                borderData:
                                                    FlBorderData(show: true),
                                                lineBarsData: [
                                                  for (var _comp
                                                      in averagedPointLinexList
                                                          .keys)
                                                    LineChartBarData(
                                                      spots: averagedPointLinexList[
                                                              _comp]
                                                          ?.map((point) =>
                                                              FlSpot(
                                                                  point.index,
                                                                  point.value))
                                                          .toList(),
                                                      isCurved: false,
                                                      barWidth: 1,
                                                      color: getColourFromComp(
                                                          _comp),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                      ],
                                    ),
                                  );
                                }
                              },
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
