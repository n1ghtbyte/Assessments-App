// check this out https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/bar_chart.md

import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:assessments_app/InovWidgets/LegendWidget.dart';

class AstaGraphs extends StatefulWidget {
  final String passedLegitName;
  final String passedClassId;
  final Map<dynamic, dynamic> passedCompetences;
  final String passedEmail;

  const AstaGraphs(
      {Key? key,
      required this.passedClassId,
      required this.passedLegitName,
      required this.passedCompetences,
      required this.passedEmail})
      : super(key: key);

  @override
  State<AstaGraphs> createState() => _AstaGraphsState();
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

class _AstaGraphsState extends State<AstaGraphs> {
  Map<String, List<DataItem>> _bigData = {};
  Map<String, int> _leTitles = {};
  Map<String, int> _comp2cardinal = {};

  var _max = 0;

  late CollectionReference _gradesCollection = FirebaseFirestore.instance
      .collection(
          'classes/${widget.passedClassId}/grading/${widget.passedEmail}/grades');
  var _ind = 0;

  static List _leColours = [
    Color(0xffa5d6a7),
    Color(0xff81c784),
    Color(0xff66bb6a),
    Color(0xff4caf50),
    Color(0xff43a047),
    Color(0xff388e3c),
    Color(0xff2e7d32),
    Color(0xff1b5e20),
    Color(0xff33691e),
  ];

  int indicatorToHash(String indicator) {
    int _sum = 0;

    var foo = ascii.encode(indicator);
    for (var k in foo) {
      _sum += k;
    }
    _leTitles[indicator] = _sum;
    return _sum;
  }

  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 30,
        margin: 8,
        interval: null,
        rotateAngle: 0,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff939393),
          fontSize: 10,
        ),
        getTitles: (value) {
          var key = _leTitles.keys.firstWhere((k) => _leTitles[k] == value,
              orElse: () => "ERROR CONTACT O3");
          return wrapText(key, 20);
        },
      );

  @override
  Widget build(BuildContext context) {
    print(widget.passedCompetences);
    print(widget.passedClassId);
    print(widget.passedEmail);
    print(widget.passedLegitName);
    return FutureBuilder<QuerySnapshot>(
      future: _gradesCollection.orderBy('Current', descending: false).get(),
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

        print(widget.passedCompetences);

        for (var ini in widget.passedCompetences.keys) {
          _bigData[ini] = [];
        }
        for (var _doc in snapshot.data!.docs) {
          var foo = _doc.data()! as Map<dynamic, dynamic>;
          print("HAKI");
          for (var comp in foo['Competences'].keys) {
            // for each competence in a given assessment
            for (var indicator in foo['Competences'][comp].keys) {
              // for each indicator in that compentence
              // print('ola');
              // print(foo['Current']);
              // print(_ind);
              // print(foo['Competences'][comp][indicator]);
              if (int.parse(foo['Current']) == 0) {
                _bigData[comp]?.add(DataItem(
                    index: _ind,
                    hash: indicatorToHash(indicator),
                    x: indicator,
                    y: [foo['Competences'][comp][indicator]]));
              } else {
                // print(_ind);
                // print("next");
                for (var i = 0; i < _bigData[comp]!.length; i++) {
                  if (_bigData[comp]![i].x == indicator) {
                    var tempora = _bigData[comp]![i].y;
                    tempora.add(foo['Competences'][comp][indicator]);
                    _bigData[comp]![i].y = tempora;
                  }
                }
              }
              _ind++;
            }
            _ind = 0;
          }
        }

        inspect(_bigData);

        for (var comp in widget.passedCompetences.keys) {
          for (var i = 0; i < _bigData[comp]!.length; i++) {
            if (_bigData[comp]![i].y.length > _max) {
              _max = _bigData[comp]![i].y.length;
            }
          }
          _comp2cardinal[comp] = _max;
          _max = 0;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('${widget.passedLegitName} data'),
            centerTitle: true,
            backgroundColor: Color(0xFF29D09E),
          ),
          body: ListView(
            children: [
              SizedBox(
                height: 24,
              ),
              Column(
                children: [
                  for (var _comp in _bigData.keys)
                    Column(
                      children: [
                        Text(
                          _comp.toString(),
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 8),
                        LegendsListWidget(
                          legends: [
                            for (var i = 0; i < _comp2cardinal[_comp]!; i++)
                              Legend("${i + 1}# Assessment", _leColours[i]),
                          ],
                        ),
                        const SizedBox(height: 14),
                        SizedBox(height: 16),
                        AspectRatio(
                          aspectRatio: 1.5,
                          child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: BarChart(BarChartData(
                                titlesData: FlTitlesData(
                                  bottomTitles: _bottomTitles,
                                  leftTitles: SideTitles(showTitles: true),
                                  topTitles: SideTitles(showTitles: false),
                                  rightTitles: SideTitles(showTitles: false),
                                ),
                                gridData: FlGridData(
                                    drawHorizontalLine: true,
                                    drawVerticalLine: false),
                                maxY: 5,
                                minY: 0,
                                groupsSpace: 10,
                                barGroups: _bigData[_comp]
                                    ?.map((dataItem) => BarChartGroupData(
                                            x: dataItem.hash,
                                            barRods: [
                                              for (var ind = 0;
                                                  ind < dataItem.y.length;
                                                  ind++)
                                                BarChartRodData(
                                                    y: double.parse(
                                                        dataItem.y[ind]),
                                                    width: 15,
                                                    colors: [_leColours[ind]]),
                                            ]))
                                    .toList())),
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
                ],
              ),
            ],
          ),
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
