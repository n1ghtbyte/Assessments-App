// check this out https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/bar_chart.md

import 'dart:convert';
import 'dart:developer';
import 'package:assessments_app/pages/Student/Assessments/AssessmentSelf.dart';
import 'package:collection/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:assessments_app/InovWidgets/LegendWidget.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:assessments_app/InovWidgets/ChartData.dart';

import '../Assessments/AssessmentPeer.dart';

class StudentClassInside extends StatefulWidget {
  final String passedClassName;
  final String passedClassId;
  final Map<dynamic, dynamic> passedCompetences;
  final String passedEmail;
  final Map<dynamic, dynamic> passedWeights;

  const StudentClassInside(
      {Key? key,
      required this.passedClassId,
      required this.passedClassName,
      required this.passedCompetences,
      required this.passedEmail,
      required this.passedWeights})
      : super(key: key);

  @override
  State<StudentClassInside> createState() => _StudentClassInsideState();
}

// Define data structure for a bar group
class DataItem {
  int index;
  int hash;
  String x; //indicator
  List<dynamic> y; //

  DataItem(
      {required this.index,
      required this.hash,
      required this.x,
      required this.y});
}

// Define data structure for a line chart point
class PointLinex {
  double index;
  String competence;
  int hash;
  String type;
  double value;
  Timestamp timestampDate;

  PointLinex(
      {required this.index,
      required this.hash,
      required this.competence,
      required this.type,
      required this.value,
      required this.timestampDate});
}

class _StudentClassInsideState extends State<StudentClassInside> {
  final colorMap = generateColorMap();
  List<bool> _customTileExpanded = List<bool>.filled(10, false);
  Map<String, List<DataItem>> _bigData = {};
  Map<String, int> _leTitles =
      {}; // Also worth to Competences... not just indicators
  Map<String, int> _comp2cardinal = {};
  Map<String, List<PointLinex>> _smallData = {};

  var _max = 0;

  late CollectionReference _formativeCollection = FirebaseFirestore.instance
      .collection(
          '/classes/${widget.passedClassId}/grading/${widget.passedEmail}/formative');

  late CollectionReference _selfCollection = FirebaseFirestore.instance
      .collection(
          '/classes/${widget.passedClassId}/grading/${widget.passedEmail}/self');
  late CollectionReference _peerCollection = FirebaseFirestore.instance
      .collection(
          '/classes/${widget.passedClassId}/grading/${widget.passedEmail}/peer');

  late CollectionReference _summativeCollection = FirebaseFirestore.instance
      .collection(
          '/classes/${widget.passedClassId}/grading/${widget.passedEmail}/summative');

  late var selfs = FirebaseFirestore.instance
      .collection('assessments')
      .where('ClassId', isEqualTo: widget.passedClassId)
      .where('Students',
          arrayContains: FirebaseAuth.instance.currentUser!.email)
      .where('Type', isEqualTo: 'Self');

  late var peers = FirebaseFirestore.instance
      .collection('assessments')
      .where('ClassId', isEqualTo: widget.passedClassId)
      .where('PeerMaster', isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .where('Type', isEqualTo: 'Peer');

  var _ind = 0;

  int indicatorToHash(String indicator) {
    int _sum = 0;

    var foo = utf8.encode(indicator);
    for (var k in foo) {
      _sum += k;
    }
    _leTitles[indicator] = _sum;
    return _sum;
  }

  // Relative to bar charts
  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 50,
        // getTextStyles: (context, value) => const TextStyle(
        //   color: Color(0xff939393),
        //   fontSize: 10,
        // ),
        getTitlesWidget: (value, meta) {
          var key = _leTitles.keys.firstWhere((k) => _leTitles[k] == value,
              orElse: () => "ERROR CONTACT O3");
          return Tooltip(
            message: key,
            height: 50,
            child: Text(
              wrapText(key, 20),
              style: TextStyle(fontSize: 8, overflow: TextOverflow.fade),
            ),
          );
        },
      );

  // Relative to Line Chart, student progression
  SideTitles get _bottomTitlesTimestamps => SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          for (var _ in _smallData.keys) {
            for (var v in _smallData[_]!) {
              if (v.index == value) {
                return Text(
                  "\n" +
                      DateFormat.yMd()
                          .format(v.timestampDate.toDate())
                          .toString(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                  ),
                );
              }
            }
          }
          // should never reach this
          return Text("");
        },
      );

  @override
  Widget build(BuildContext context) {
    print(widget.passedCompetences);
    print(widget.passedClassId);
    print(widget.passedEmail);
    return FutureBuilder<QuerySnapshot>(
      future: _formativeCollection.orderBy('Created', descending: false).get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
        return StreamBuilder<QuerySnapshot>(
          stream: selfs.orderBy('Created', descending: false).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> selfs) {
            if (selfs.hasError) {
              return Text("Something went wrong");
            }
            if (!selfs.hasData) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return StreamBuilder<QuerySnapshot>(
              stream: peers.orderBy('Created', descending: false).snapshots(),
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> peers) {
                if (peers.hasError) {
                  return Text("Something went wrong");
                }
                if (!peers.hasData) {
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                return StreamBuilder<QuerySnapshot>(
                  stream: _selfCollection
                      .orderBy('Created', descending: false)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snpSelf) {
                    if (snpSelf.hasError) {
                      return Text("Something went wrong");
                    }
                    if (!snpSelf.hasData) {
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return StreamBuilder<QuerySnapshot>(
                      stream: _peerCollection
                          .orderBy('Created', descending: false)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snpPeer) {
                        if (snpPeer.hasError) {
                          return Text("Something went wrong");
                        }
                        if (!snpPeer.hasData) {
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        for (var ini in widget.passedCompetences.keys) {
                          _bigData[ini] = [];
                          _smallData[ini] = [];
                        }
                        List selfAssess = snpSelf.data!.docs;
                        List formAssess = snapshot.data!.docs;
                        List peerAssess = snpPeer.data!.docs;
                        List faa = [];
                        faa = selfAssess + formAssess + peerAssess;
                        faa.sort((a, b) {
                          return a['Created'].compareTo(b['Created']);
                        });
                        print(widget.passedCompetences);

                        double fakeIndex = 0;
                        Map<String, bool> tt = {};

                        for (var ini in widget.passedCompetences.keys) {
                          _bigData[ini] = [];
                          _smallData[ini] = [];
                          for (var bar in widget.passedCompetences[ini]) {
                            tt[bar] = false;
                          }
                        }
                        for (var _doc in faa) {
                          var foo = _doc.data()! as Map<dynamic, dynamic>;
                          print(foo['AssessID']);
                          print("HAKI");
                          List<double> helper = [];
                          for (var comp in foo['Competences'].keys) {
                            getColourFromComp(comp);
                            // for each competence in a given assessment
                            for (var indicator
                                in foo['Competences'][comp].keys) {
                              print(foo['Competences'][comp][indicator]);

                              helper.add(double.parse(
                                  foo['Competences'][comp][indicator]));

                              print((foo['Created'] as Timestamp).toDate());
                              if (_bigData[comp]!.isEmpty || !tt[indicator]!) {
                                _bigData[comp]?.add(DataItem(
                                    index: _ind,
                                    hash: indicatorToHash(indicator),
                                    x: indicator,
                                    y: [foo['Competences'][comp][indicator]]));
                              } else {
                                for (var i = 0;
                                    i < _bigData[comp]!.length;
                                    i++) {
                                  if (_bigData[comp]![i].x == indicator) {
                                    var tempora = _bigData[comp]![i].y;
                                    tempora.add(
                                        foo['Competences'][comp][indicator]);
                                    _bigData[comp]![i].y = tempora;
                                  }
                                }
                              }
                              _ind++;
                              tt[indicator] = true;
                            }

                            var _res = helper.average;
                            // VERIFICAR SE O DOC ESTA EM QUAL LISTA PEAR SELF FORM
                            if (selfAssess.contains(_doc)) {
                              var type = AppLocalizations.of(context)!.self;

                              _smallData[comp]?.add(PointLinex(
                                  index: fakeIndex,
                                  hash: indicatorToHash(comp),
                                  competence: comp,
                                  value: _res,
                                  type: type,
                                  timestampDate: foo['Created']));
                            }
                            if (peerAssess.contains(_doc)) {
                              var type = AppLocalizations.of(context)!.peer;

                              _smallData[comp]?.add(PointLinex(
                                  index: fakeIndex,
                                  hash: indicatorToHash(comp),
                                  competence: comp,
                                  value: _res,
                                  type: type,
                                  timestampDate: foo['Created']));
                            }
                            if (formAssess.contains(_doc)) {
                              var type =
                                  AppLocalizations.of(context)!.formative;
                              _smallData[comp]?.add(PointLinex(
                                  index: fakeIndex,
                                  hash: indicatorToHash(comp),
                                  competence: comp,
                                  value: _res,
                                  type: type,
                                  timestampDate: foo['Created']));
                            }

                            _ind = 0;
                            helper = [];
                          }
                          fakeIndex++;
                        }
                        inspect(_smallData);
                        inspect(_bigData);
                        var thevalue = 0;

                        _smallData.forEach((k, v) {
                          if (v.length > thevalue) {
                            thevalue = v.length;
                          }
                        });

                        for (var comp in widget.passedCompetences.keys) {
                          for (var i = 0; i < _bigData[comp]!.length; i++) {
                            if (_bigData[comp]![i].y.length > _max) {
                              _max = _bigData[comp]![i].y.length;
                            }
                          }
                          _comp2cardinal[comp] = _max;
                          _max = 0;
                        }
                        inspect(_comp2cardinal);

                        //Fetch summative data
                        return FutureBuilder<QuerySnapshot>(
                          future: _summativeCollection
                              .orderBy('Created', descending: false)
                              .get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshotSumm) {
                            if (snapshotSumm.hasError) {
                              return Text("Something went wrong");
                            }
                            if (!snapshotSumm.hasData) {
                              return Container(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            // Fetch Self data

                            List<Map<dynamic, dynamic>> fsum = [];
                            for (var _doc in snapshotSumm.data!.docs) {
                              fsum.add(_doc.data()! as Map<dynamic, dynamic>);
                            }

                            return DefaultTabController(
                              length: 3,
                              child: Scaffold(
                                appBar: AppBar(
                                  bottom: const TabBar(
                                    indicatorColor: Colors.green,
                                    tabs: [
                                      Tab(icon: Icon(Icons.grade)),
                                      Tab(icon: Icon(Icons.school)),
                                      Tab(icon: Icon(Icons.info)),
                                    ],
                                  ),
                                  title: Text(AppLocalizations.of(context)!
                                          .classConcept +
                                      ' ' +
                                      widget.passedClassName),
                                  centerTitle: true,
                                  backgroundColor: Color(0xFF29D09E),
                                ),
                                body: TabBarView(
                                  children: [
                                    SafeArea(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          const SizedBox(height: 16),
                                          Container(
                                            padding: EdgeInsets.all(20.0),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .assessments,
                                              style: TextStyle(
                                                  fontSize: 21,
                                                  fontWeight: FontWeight.w800),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(10.0),
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .self,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Expanded(
                                            child: ListView(
                                              children: selfs.data!.docs.map(
                                                (DocumentSnapshot document) {
                                                  Map<String, dynamic> data =
                                                      document.data()! as Map<
                                                          String, dynamic>;
                                                  return ListTile(
                                                    textColor: data['DONE'] ==
                                                            false
                                                        ? Color(0xFF29D09E)
                                                        : Color.fromARGB(
                                                            255, 123, 123, 123),
                                                    onTap: () {
                                                      if (data['DONE'] ==
                                                          false) {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                AssessmentSelf(
                                                              passedAssessmentIdName:
                                                                  data[
                                                                      'documentID'],
                                                            ),
                                                          ),
                                                        ).then((value) =>
                                                            setState(() {}));
                                                      }
                                                    },
                                                    leading:
                                                        Icon(Icons.assessment),
                                                    isThreeLine: false,
                                                    title: Text(data['Name']),
                                                    subtitle: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .self),
                                                  );
                                                },
                                              ).toList(),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(10.0),
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .peer,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Expanded(
                                            child: ListView(
                                              children: peers.data!.docs.map(
                                                (DocumentSnapshot document) {
                                                  Map<String, dynamic> data =
                                                      document.data()! as Map<
                                                          String, dynamic>;
                                                  return ListTile(
                                                    textColor: data['DONE'] ==
                                                            false
                                                        ? Color(0xFF29D09E)
                                                        : Color.fromARGB(
                                                            255, 123, 123, 123),
                                                    onTap: () {
                                                      if (data['DONE'] ==
                                                          false) {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                AssessmentPeer(
                                                              passedAssessmentIdName:
                                                                  data[
                                                                      'documentID'],
                                                            ),
                                                          ),
                                                        ).then((value) =>
                                                            setState(() {}));
                                                      }
                                                    },
                                                    leading:
                                                        Icon(Icons.assessment),
                                                    isThreeLine: false,
                                                    title: Text(data['Name']),
                                                    subtitle: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .peer),
                                                  );
                                                },
                                              ).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SafeArea(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          const SizedBox(height: 16),
                                          Container(
                                            padding: EdgeInsets.all(20.0),
                                            child: Text(
                                              AppLocalizations.of(context)!.wec,
                                              style: TextStyle(
                                                  fontSize: 21,
                                                  fontWeight: FontWeight.w800),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: widget
                                                .passedCompetences.keys
                                                .toList()
                                                .length,
                                            itemBuilder: (context, index) {
                                              return ExpansionTile(
                                                trailing: Icon(
                                                  _customTileExpanded[index]
                                                      ? Icons
                                                          .arrow_drop_down_circle
                                                      : Icons.arrow_drop_down,
                                                ),
                                                title: Text(widget
                                                    .passedCompetences.keys
                                                    .toList()[index]),
                                                subtitle: Text(widget
                                                        .passedWeights[widget
                                                            .passedCompetences
                                                            .keys
                                                            .toList()[index]]
                                                        .toString() +
                                                    "%"),
                                                children: [
                                                  ListView.builder(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: widget
                                                        .passedCompetences[widget
                                                            .passedCompetences
                                                            .keys
                                                            .toList()[index]]
                                                        .length,
                                                    itemBuilder:
                                                        (context, xipidi) {
                                                      return ListTile(
                                                        title: Text(widget
                                                            .passedCompetences[widget
                                                                .passedCompetences
                                                                .keys
                                                                .toList()[
                                                            index]][xipidi]),
                                                        dense: true,
                                                        visualDensity: VisualDensity
                                                            .adaptivePlatformDensity,
                                                      );
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(20),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .summa,
                                              style: TextStyle(
                                                  fontSize: 21,
                                                  fontWeight: FontWeight.w800),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          snapshotSumm.data!.docs.isEmpty
                                              ? Column(
                                                  children: [
                                                    DataTable(
                                                      columns: [
                                                        DataColumn(
                                                            label: Text(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .grade,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold))),
                                                        DataColumn(
                                                            label: Text(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .date,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold))),
                                                      ],
                                                      rows: [],
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(20),
                                                      child: Text(
                                                        "${AppLocalizations.of(context)!.ovr}: 0 \n${AppLocalizations.of(context)!.avg}: 0",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Column(
                                                  children: [
                                                    DataTable(
                                                      columns: [
                                                        DataColumn(
                                                            label: Text(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .grade,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold))),
                                                        DataColumn(
                                                            label: Text(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .date,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold))),
                                                      ],
                                                      rows: [
                                                        for (var dt in fsum)
                                                          DataRow(
                                                            cells: [
                                                              DataCell(Text(dt[
                                                                      'Result']
                                                                  .toStringAsFixed(
                                                                      2))),
                                                              DataCell(Text(DateFormat
                                                                      .yMMMEd()
                                                                  .format(dt[
                                                                          'Created']
                                                                      .toDate())
                                                                  .toString()))
                                                            ],
                                                            onLongPress: () =>
                                                                showDialog<
                                                                    String>(
                                                              context: context,
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  Dialog
                                                                      .fullscreen(
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: <Widget>[
                                                                    Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              14),
                                                                      child:
                                                                          Text(
                                                                        AppLocalizations.of(context)!
                                                                            .formsarg,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w800),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                    ),
                                                                    StreamBuilder<
                                                                        QuerySnapshot>(
                                                                      stream: FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              "assessments")
                                                                          .where(
                                                                              'documentID',
                                                                              whereIn: dt['Formatives'])
                                                                          .snapshots(),
                                                                      builder: (BuildContext
                                                                              context,
                                                                          AsyncSnapshot<QuerySnapshot>
                                                                              snapshot) {
                                                                        if (!snapshot
                                                                            .hasData)
                                                                          return Text(
                                                                              AppLocalizations.of(context)!.connecting);
                                                                        var assessForms = snapshot
                                                                            .data
                                                                            ?.docs;
                                                                        return ListView
                                                                            .builder(
                                                                          shrinkWrap:
                                                                              true,
                                                                          itemCount:
                                                                              assessForms?.length,
                                                                          itemBuilder:
                                                                              (BuildContext context, int index) {
                                                                            return ListTile(
                                                                              title: Text("${AppLocalizations.of(context)!.name}: ${assessForms![index]['Name'].toString()}"),
                                                                              subtitle: Text("${AppLocalizations.of(context)!.date}: ${DateFormat('yyyy-MM-dd').format((assessForms[index]['Created'] as Timestamp).toDate())}"),
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            8),
                                                                    Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              14),
                                                                      child:
                                                                          Text(
                                                                        AppLocalizations.of(context)!
                                                                            .weightsargs,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w800),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                    ),
                                                                    ListView
                                                                        .builder(
                                                                      shrinkWrap:
                                                                          true,
                                                                      itemCount: dt[
                                                                              'Weights']
                                                                          .keys
                                                                          .toList()
                                                                          .length,
                                                                      itemBuilder:
                                                                          (BuildContext context,
                                                                              int index) {
                                                                        String key = dt['Weights']
                                                                            .keys
                                                                            .toList()
                                                                            .elementAt(index);
                                                                        return ListTile(
                                                                          title:
                                                                              Text("$key"),
                                                                          subtitle:
                                                                              Text("${AppLocalizations.of(context)!.weights}: ${dt['Weights'][key]} %"),
                                                                        );
                                                                      },
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            15),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: Text(
                                                                          AppLocalizations.of(context)!
                                                                              .close),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ],
                                                ),

                                          // ERRO AQUI ! manuel:manuel
                                          // Container(
                                          //   padding: EdgeInsets.all(20),
                                          //   child: Text(
                                          //     "${AppLocalizations.of(context)!.ovr}: ${fsum.length} \n${AppLocalizations.of(context)!.avg}: ${(fsum.map((e) => e['Result']).reduce((value, element) => value + element) / fsum.length).toStringAsFixed(2)}",
                                          //     style: TextStyle(
                                          //         fontSize: 12,
                                          //         fontWeight: FontWeight.w400),
                                          //     textAlign: TextAlign.left,
                                          //   ),
                                          // ),
                                          SizedBox(
                                            height: 14,
                                          ),
                                          Divider(height: 2),
                                          SizedBox(
                                            height: 14,
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(20),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .forma,
                                              style: TextStyle(
                                                  fontSize: 21,
                                                  fontWeight: FontWeight.w800),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              for (var _comp in _bigData.keys)
                                                Column(
                                                  children: [
                                                    Text(
                                                      _comp.toString(),
                                                      style: TextStyle(
                                                          fontSize: 21,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    const SizedBox(height: 8),
                                                    LegendsListWidget(
                                                      legends: [
                                                        for (var i = 0;
                                                            i <
                                                                _comp2cardinal[
                                                                    _comp]!;
                                                            i++)
                                                          Legend(
                                                              "${DateFormat.yMd().format(_smallData[_comp]![i].timestampDate.toDate())}" +
                                                                  " " +
                                                                  _smallData[_comp]![
                                                                          i]
                                                                      .type,
                                                              colorMap[_smallData[
                                                                      _comp]![i]
                                                                  .type]![i]),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 14),
                                                    SizedBox(height: 16),
                                                    SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 20,
                                                                right: 20,
                                                                top: 55,
                                                                bottom: 20),
                                                        height: 300,
                                                        width: 100 +
                                                            (_bigData[_comp]!
                                                                    .length *
                                                                200) +
                                                            _smallData[_comp]!
                                                                    .length *
                                                                15,
                                                        child: BarChart(
                                                          BarChartData(
                                                            baselineY: 0,
                                                            titlesData:
                                                                FlTitlesData(
                                                              bottomTitles:
                                                                  AxisTitles(
                                                                      sideTitles:
                                                                          _bottomTitles),
                                                              leftTitles: AxisTitles(
                                                                  sideTitles: SideTitles(
                                                                      showTitles:
                                                                          true)),
                                                              topTitles: AxisTitles(
                                                                  sideTitles: SideTitles(
                                                                      showTitles:
                                                                          false)),
                                                              rightTitles: AxisTitles(
                                                                  sideTitles: SideTitles(
                                                                      showTitles:
                                                                          false)),
                                                            ),
                                                            gridData: FlGridData(
                                                                drawHorizontalLine:
                                                                    true,
                                                                drawVerticalLine:
                                                                    false),
                                                            maxY: 5,
                                                            minY: 0,
                                                            groupsSpace: 10,
                                                            barGroups:
                                                                _bigData[_comp]
                                                                    ?.map(
                                                                      (dataItem) =>
                                                                          BarChartGroupData(
                                                                        x: dataItem
                                                                            .hash,
                                                                        barRods: [
                                                                          for (var ind = 0;
                                                                              ind < dataItem.y.length;
                                                                              ind++)
                                                                            BarChartRodData(
                                                                                borderRadius: BorderRadius.zero,
                                                                                backDrawRodData: BackgroundBarChartRodData(
                                                                                  show: true,
                                                                                  toY: 0.1,
                                                                                  color: colorMap[_smallData[_comp]![ind].type]![ind],
                                                                                ),
                                                                                toY: double.parse(dataItem.y[ind]),
                                                                                width: 15,
                                                                                color: colorMap[_smallData[_comp]![ind].type]![ind]),
                                                                        ],
                                                                      ),
                                                                    )
                                                                    .toList(),
                                                          ),
                                                          swapAnimationDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      150), // Optional
                                                          swapAnimationCurve: Curves
                                                              .linear, // Optional
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 32,
                                                    ),
                                                    Divider(
                                                      thickness: 2,
                                                      height: 4,
                                                    ),
                                                    SizedBox(
                                                      height: 32,
                                                    ),
                                                  ],
                                                ),
                                              Column(
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .studentprog,
                                                    style: TextStyle(
                                                        fontSize: 21,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  LegendsListWidget(
                                                    legends: [
                                                      for (var i
                                                          in _smallData.keys)
                                                        Legend(
                                                            i,
                                                            getColourFromComp(
                                                                i)),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 14),
                                                  // SizedBox(height: 16),
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 50,
                                                                right: 100,
                                                                top: 100,
                                                                bottom: 40),
                                                        height: 350,
                                                        width: 200 +
                                                            thevalue * 100,
                                                        child: LineChart(
                                                          LineChartData(
                                                            titlesData:
                                                                FlTitlesData(
                                                              bottomTitles:
                                                                  AxisTitles(
                                                                      sideTitles:
                                                                          _bottomTitlesTimestamps),
                                                              leftTitles: AxisTitles(
                                                                  sideTitles: SideTitles(
                                                                      showTitles:
                                                                          true)),
                                                              topTitles: AxisTitles(
                                                                  sideTitles: SideTitles(
                                                                      showTitles:
                                                                          false)),
                                                              rightTitles: AxisTitles(
                                                                  sideTitles: SideTitles(
                                                                      showTitles:
                                                                          false)),
                                                            ),
                                                            minY: 0,
                                                            maxY: 5,
                                                            gridData: FlGridData(
                                                                show: true,
                                                                drawHorizontalLine:
                                                                    true,
                                                                drawVerticalLine:
                                                                    true),
                                                            borderData:
                                                                FlBorderData(
                                                                    show: true),
                                                            lineBarsData: [
                                                              for (var _comp
                                                                  in _smallData
                                                                      .keys)
                                                                LineChartBarData(
                                                                  spots: _smallData[
                                                                          _comp]
                                                                      ?.map((point) => FlSpot(
                                                                          point
                                                                              .index,
                                                                          point
                                                                              .value))
                                                                      .toList(),
                                                                  isCurved:
                                                                      false,
                                                                  barWidth: 2,
                                                                  color:
                                                                      getColourFromComp(
                                                                          _comp),
                                                                ),
                                                            ],
                                                          ),
                                                          swapAnimationDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      150), // Optional
                                                          swapAnimationCurve: Curves
                                                              .linear, // Optional
                                                        )),
                                                  ),
                                                  const SizedBox(height: 16),
                                                ],
                                              ),
                                            ],
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
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

String wrapText(String inputText, int wrapLength) {
  List<String> separatedWords = inputText.split(' ');
  StringBuffer intermidiateText = StringBuffer();
  StringBuffer outputText = StringBuffer();

  for (String word in separatedWords) {
    if ((intermidiateText.length + word.length) >= wrapLength) {
      intermidiateText.write('\n');
      outputText.write(intermidiateText);
      intermidiateText.clear();
      intermidiateText.write('$word ');
    } else {
      intermidiateText.write('$word ');
    }
  }

  outputText.write(intermidiateText); //Write any remaining word at the end
  intermidiateText.clear();
  return outputText.toString().trim();
}

Color getColourFromComp(String competence) {
  var hash = 0;
  for (var i = 0; i < competence.length; i++) {
    hash = competence.codeUnitAt(i) + ((hash << 5) - hash);
  }
  final finalHash = hash.abs() % (256 * 256 * 256);
  print(finalHash);
  final red = ((finalHash & 0xFF0000) >> 16);
  final blue = ((finalHash & 0xFF00) >> 8);
  final green = ((finalHash & 0xFF));
  final color = Color.fromRGBO(red, green, blue, 1);
  return color;
}
