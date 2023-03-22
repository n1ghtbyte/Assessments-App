import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SkillEdit extends StatefulWidget {
  final Map passedComp;
  final int passedIndNumber;

  final String name;
  const SkillEdit(
      {Key? key,
      required this.passedComp,
      required this.name,
      required this.passedIndNumber})
      : super(key: key);

  @override
  State<SkillEdit> createState() => _SkillEditState();
}

class _SkillEditState extends State<SkillEdit> {
  List<List<TextEditingController>> _descriptionComp = List.generate(
      5, (index) => List.generate(6, (index) => TextEditingController()));
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  Map noDamage = {};
  var x = 0;

  @override
  Widget build(BuildContext context) {
    for (var key in widget.passedComp.keys) {
      if (key != 'Name') {
        noDamage[key] = widget.passedComp[key];
      }
    }
    _descriptionComp[0][0] = new TextEditingController(text: widget.name);
    for (var i = 1; i < widget.passedIndNumber + 1; i++) {
      for (var j = 0; j < 6; j++) {
        if (j == 0) {
          _descriptionComp[i][j] =
              new TextEditingController(text: noDamage.keys.toList()[x]);
        } else {
          _descriptionComp[i][j] = new TextEditingController(
              text: noDamage[noDamage.keys.toList()[x]][j - 1].substring(4));
        }
      }
      x++;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Editing a competence"),
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
              const SnackBar(content: Text('Competence created')),
            );
            Map<String, dynamic> data = Map();
            data['Name'] = _descriptionComp[0][0].text.toString();
            for (var i = 1; i < widget.passedIndNumber + 1; i++) {
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
                .doc(widget.name.toString())
                .set(data)
                .onError((e, _) => print("Error writing document: $e"));
            final snackBar =
                SnackBar(content: Text('The competence was updated!'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Some fields are missing')),
            );
          }
        },
      ),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: TextFormField(
                      controller: _descriptionComp[0][0],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        icon: Icon(Icons.comment),
                        labelText: 'Competence Name',
                        labelStyle: TextStyle(
                          color: Color(0xFF29D09E),
                        ),
                        helperText: 'What is the competence name?',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF29D09E)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Divider(
                    height: 8,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  for (var ind = 1; ind < widget.passedIndNumber + 1; ind++)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _descriptionComp[ind][0],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              icon: Icon(Icons.comment),
                              labelText: 'Indicator $ind',
                              labelStyle: TextStyle(
                                color: Color(0xFF29D09E),
                              ),
                              helperText: 'Indicator $ind name',
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF29D09E)),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 30, top: 8, right: 30, bottom: 15),
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: 5,
                            itemBuilder: (context, index2) {
                              return SingleChildScrollView(
                                child: TextFormField(
                                  controller: _descriptionComp[ind][index2 + 1],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    isDense: true,
                                    icon: Icon(Icons.comment),
                                    labelText: 'Descriptor ${index2 + 1}',
                                    labelStyle: TextStyle(
                                      color: Color(0xFF29D09E),
                                    ),
                                    helperText:
                                        'Describe asserting a ${index2 + 1} score',
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF29D09E),
                                      ),
                                    ),
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
      ),
    );
  }
}
