// check this out https://github.com/imaNNeoFighT/fl_chart/blob/master/repo_files/documentations/bar_chart.md

import 'dart:convert';
import 'dart:developer';
import 'package:collection/collection.dart';
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

// Define data structure for a line chart point
class PointLinex {
  double index;
  String competence;
  int hash;
  double value;
  Timestamp timestampDate;

  PointLinex(
      {required this.index,
      required this.hash,
      required this.competence,
      required this.value,
      required this.timestampDate});
}

class _AstaGraphsState extends State<AstaGraphs> {
  Map<String, List<DataItem>> _bigData = {};
  Map<String, int> _leTitles =
      {}; // Also worth to Competences... not just indicators
  Map<String, int> _comp2cardinal = {};
  Map<String, List<PointLinex>> _smallData = {};

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

  static Map<String, Color> _compColour = {
    "Writing Skills": Color.fromARGB(255, 172, 55, 137),
    "Project Management": Color.fromARGB(255, 166, 229, 42),
  };
  int indicatorToHash(String indicator) {
    int _sum = 0;

    var foo = ascii.encode(indicator);
    for (var k in foo) {
      _sum += k;
    }
    _leTitles[indicator] = _sum;
    return _sum;
  }

  // Relative to bar charts
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

  // Relative to Line charts
  SideTitles get _bottomTitlesTimestamps => SideTitles(
        showTitles: true,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff939393),
          fontSize: 10,
        ),
        getTitles: (value) {
          var ret = "";
          if (value % 1 != 0) {
            return ret;
          }
          if (value == 0) {
            ret = "1st Assess";
            return ret;
          } else if (value == 1) {
            ret = "2nd Assess";
            return ret;
          } else if (value == 2) {
            ret = "3rd Assess";
            return ret;
          } else {
            var k = value + 1;
            ret = k.toString() + "th Assess";
            return ret;
          }
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
          _smallData[ini] = [];
        }
        for (var _doc in snapshot.data!.docs) {
          var foo = _doc.data()! as Map<dynamic, dynamic>;
          print("HAKI");
          List<double> helper = [];
          for (var comp in foo['Competences'].keys) {
            getColourFromComp(comp);
            // for each competence in a given assessment
            for (var indicator in foo['Competences'][comp].keys) {
              print(foo['Competences'][comp][indicator]);

              helper.add(double.parse(foo['Competences'][comp][indicator]));
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

            var _res = helper.average;
            _smallData[comp]?.add(PointLinex(
                index: double.parse(foo['Current']),
                hash: indicatorToHash(comp),
                competence: comp,
                value: _res,
                timestampDate: foo['Created']));

            _ind = 0;
            helper = [];
          }
        }
        inspect(_smallData);
        // inspect(_bigData);

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
                            child: BarChart(
                              BarChartData(
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
                                                      colors: [
                                                        _leColours[ind]
                                                      ]),
                                              ]))
                                      .toList()),
                              swapAnimationDuration:
                                  Duration(milliseconds: 150), // Optional
                              swapAnimationCurve: Curves.linear, // Optional
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
                        "Competences Line Chart",
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.w400),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 8),
                      LegendsListWidget(
                        legends: [
                          for (var i in _smallData.keys)
                            Legend(i, getColourFromComp(i)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(height: 16),
                      AspectRatio(
                        aspectRatio: 1.5,
                        child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: LineChart(
                              LineChartData(
                                titlesData: FlTitlesData(
                                  bottomTitles: _bottomTitlesTimestamps,
                                  leftTitles: SideTitles(showTitles: true),
                                  topTitles: SideTitles(showTitles: false),
                                  rightTitles: SideTitles(showTitles: false),
                                ),
                                minY: 0,
                                maxY: 5,
                                gridData: FlGridData(
                                    show: true,
                                    drawHorizontalLine: true,
                                    drawVerticalLine: false),
                                borderData: FlBorderData(show: true),
                                lineBarsData: [
                                  for (var _comp in _smallData.keys)
                                    LineChartBarData(
                                      spots: _smallData[_comp]
                                          ?.map((point) =>
                                              FlSpot(point.index, point.value))
                                          .toList(),
                                      isCurved: false,
                                      barWidth: 2,
                                      colors: [getColourFromComp(_comp)],
                                    ),
                                ],
                              ),
                              swapAnimationDuration:
                                  Duration(milliseconds: 150), // Optional
                              swapAnimationCurve: Curves.linear, // Optional
                            )),
                      ),
                      const SizedBox(height: 16),
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

Color getColourFromComp(String competence) {
  final Map<String, Color> _compColour = {
    "Writing Skills": Color.fromARGB(255, 167, 193, 53),
    "Project Management": Color.fromARGB(255, 0, 157, 189),
    "Problem Solving": Color.fromARGB(255, 131, 46, 164),
    "Oral Communication": Color.fromARGB(255, 166, 229, 42),
    "Learning Orientation": Color.fromARGB(255, 42, 76, 229),
    "Interpersonal Communication": Color.fromARGB(255, 198, 152, 192),
    "Ethical Sense": Color.fromARGB(255, 154, 119, 119),
    "Diversity and Interculturality": Color.fromARGB(255, 98, 97, 135),
    "Critical Thinking": Color.fromARGB(255, 229, 145, 42),
    "Creativity": Color.fromARGB(255, 229, 42, 42),
    "Collaboration - Teamwork": Color.fromARGB(255, 24, 126, 142),
  };
  var colour = _compColour[competence];
  if (colour != null) {
    return colour;
  }

  return Colors.black;
}
