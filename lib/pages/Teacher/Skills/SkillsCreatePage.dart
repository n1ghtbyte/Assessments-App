import 'package:assessments_app/pages/Teacher/Skills/SkillsIndicatorsStage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SkillsCreatePage extends StatefulWidget {
  const SkillsCreatePage({Key? key}) : super(key: key);

  @override
  _SkillsCreatePageState createState() => _SkillsCreatePageState();
}

class _SkillsCreatePageState extends State<SkillsCreatePage> {
  double _sliderDiscreteValue = 2;
  final _competenceName = TextEditingController();

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
        title: Text(AppLocalizations.of(context)!.createcomp),
        centerTitle: true,
        backgroundColor: Color(0xFF29D09E),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF29D09E),
        onPressed: () {
          // Validate returns true if the form is valid, or false otherwise.
          if (_formKey.currentState!.validate()) {
            // If the form is valid, display a snackbar. In the real world,
            // you'd often call a server or save the information in a database.

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SkillsIndicatorsStage(
                        passedCompetenceName: _competenceName.text,
                        passedNumIndicator: _sliderDiscreteValue,
                      )),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(AppLocalizations.of(context)!.entercompname)),
            );
          }

          // Respond to button press
        },
        icon: Icon(Icons.skip_next),
        label: Text(AppLocalizations.of(context)!.next),
      ),
      body: Form(
        key: _formKey,
        child: Column(children: [
          Container(
            padding: EdgeInsets.all(20),
            child: TextFormField(
              maxLength: 20,
              controller: _competenceName,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.entertxt;
                }
                return null;
              },
              decoration: InputDecoration(
                icon: Icon(Icons.comment),
                labelText: AppLocalizations.of(context)!.compname,
                labelStyle: TextStyle(
                  color: Color(0xFF29D09E),
                ),
                helperText: AppLocalizations.of(context)!.compnamequestion,
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
            title: Text(AppLocalizations.of(context)!.hminds),
          ),
          Slider(
            value: _sliderDiscreteValue,
            min: 1,
            max: 5,
            divisions: 4,
            label: _sliderDiscreteValue.round().toString(),
            onChanged: (value) {
              setState(() {
                _sliderDiscreteValue = value;
              });
            },
          )
        ]),
      ),
    );
  }
}
