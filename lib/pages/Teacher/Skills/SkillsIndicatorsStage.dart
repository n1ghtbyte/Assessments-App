import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SkillsIndicatorsStage extends StatefulWidget {
  final double passedNumIndicator;
  final String passedCompetenceName;

  const SkillsIndicatorsStage({
    Key? key,
    required this.passedNumIndicator,
    required this.passedCompetenceName,
  }) : super(key: key);
  @override
  _SkillsIndicatorsStage createState() => _SkillsIndicatorsStage();
}

class _SkillsIndicatorsStage extends State<SkillsIndicatorsStage> {
  List<List<TextEditingController>> _descriptionComp = List.generate(
      5, (index) => List.generate(6, (index) => TextEditingController()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Indicators Creation'),
        centerTitle: true,
        backgroundColor: Color(0xFF29D09E),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Color(0xFF29D09E),
          onPressed: () {
            Map<String, dynamic> data = Map();
            data['Name'] = widget.passedCompetenceName;
            for (var i = 0; i < widget.passedNumIndicator; i++) {
              for (var j = 1; j < 6; j++) {
                if (data[_descriptionComp[i][0].text.toString()] == null) {
                  data[_descriptionComp[i][0].text.toString()] = [
                    "$j - " + _descriptionComp[i][j].text.toString()
                  ];
                } else {
                  data[_descriptionComp[i][0].text.toString()]
                      .add("$j - " + _descriptionComp[i][j].text.toString());
                }
              }
            }
            print(data);
            FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.email)
                .collection("PrivateCompetences")
                .doc(widget.passedCompetenceName.toString())
                .set(data)
                .onError((e, _) => print("Error writing document: $e"));
          }),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Column(
            children: [
              for (var ind = 0; ind < widget.passedNumIndicator; ind++)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _descriptionComp[ind][0],
                      decoration: InputDecoration(
                        icon: Icon(Icons.comment),
                        labelText: 'Indicator ${ind + 1}',
                        labelStyle: TextStyle(
                          color: Color(0xFF29D09E),
                        ),
                        helperText: 'Indicator ${ind + 1} name',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF29D09E)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 30, top: 0, right: 0, bottom: 15),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 5,
                        itemBuilder: (context, index2) {
                          return TextFormField(
                            controller: _descriptionComp[ind][index2 + 1],
                            decoration: InputDecoration(
                              icon: Icon(Icons.comment),
                              labelText: 'Descriptor ${index2 + 1}',
                              labelStyle: TextStyle(
                                color: Color(0xFF29D09E),
                              ),
                              helperText:
                                  'Describe asserting a ${index2 + 1} score',
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF29D09E)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
