import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.indicators),
        centerTitle: true,
        backgroundColor: Color(0xFF29D09E),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        backgroundColor: Color(0xFF29D09E),
        onPressed: () {
          // Validate returns true if the form is valid, or false otherwise.
          if (_formKey.currentState!.validate()) {
            // If the form is valid, display a snackbar. In the real world,
            // you'd often call a server or save the information in a database.
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(AppLocalizations.of(context)!.compcreated)),
            );
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
            final snackBar = SnackBar(
                content: Text(AppLocalizations.of(context)!.compcreated));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context)!.fieldsdead)),
            );
          }
        },
      ),
      body: Form(
        key: _formKey,
        child: ListView(
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.entertxt;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          icon: Icon(Icons.comment),
                          labelText:
                              '${AppLocalizations.of(context)!.indicator} ${ind + 1}',
                          labelStyle: TextStyle(
                            color: Color(0xFF29D09E),
                          ),
                          helperText:
                              '${AppLocalizations.of(context)!.indicator} ${ind + 1} ${AppLocalizations.of(context)!.name}',
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(context)!.entertxt;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                icon: Icon(Icons.comment),
                                labelText:
                                    '${AppLocalizations.of(context)!.descriptor} ${index2 + 1}',
                                labelStyle: TextStyle(
                                  color: Color(0xFF29D09E),
                                ),
                                // LIT
                                // helperText:
                                //     'Describe asserting a ${index2 + 1} score',
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
      ),
    );
  }
}
