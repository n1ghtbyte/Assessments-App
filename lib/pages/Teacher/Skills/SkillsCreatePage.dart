import 'package:assessments_app/pages/Teacher/Skills/SkillsIndicatorsStage.dart';
import 'package:flutter/material.dart';

class SkillsCreatePage extends StatefulWidget {
  const SkillsCreatePage({Key? key}) : super(key: key);

  @override
  _SkillsCreatePageState createState() => _SkillsCreatePageState();
}

class _SkillsCreatePageState extends State<SkillsCreatePage> {
  double _sliderDiscreteValue = 2;
  final _competenceName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Competence'),
        centerTitle: true,
        backgroundColor: Color(0xFF29D09E),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF29D09E),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SkillsIndicatorsStage(
                      passedCompetenceName: _competenceName.text,
                      passedNumIndicator: _sliderDiscreteValue,
                    )),
          );
          // Respond to button press
        },
        icon: Icon(Icons.skip_next),
        label: Text('Next'),
      ),
      body: Column(children: [
        Container(
          padding: EdgeInsets.all(20),
          child: TextFormField(
            maxLength: 20,
            controller: _competenceName,
            decoration: InputDecoration(
              icon: Icon(Icons.comment),
              labelText: 'Competence name',
              labelStyle: TextStyle(
                color: Color(0xFF29D09E),
              ),
              helperText: 'What is the name of the competence?',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF29D09E)),
              ),
            ),
          ),
        ),
        Divider(),
        const SizedBox(height: 16),
        ListTile(
          leading: Icon(Icons.format_list_numbered),
          title: Text("How many indicators?"),
        ),
        Slider(
          value: _sliderDiscreteValue,
          min: 1,
          max: 5,
          divisions: 5,
          label: _sliderDiscreteValue.round().toString(),
          onChanged: (value) {
            setState(() {
              _sliderDiscreteValue = value;
            });
          },
        )
      ]),
    );
  }
}
