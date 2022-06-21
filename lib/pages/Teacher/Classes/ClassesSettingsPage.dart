import 'package:flutter/material.dart';

class ClassesSettingsPage extends StatefulWidget {
  const ClassesSettingsPage({Key? key}) : super(key: key);

  @override
  _ClassesSettingsPageState createState() => _ClassesSettingsPageState();
}

class _ClassesSettingsPageState extends State<ClassesSettingsPage> {

  // bool isChecked0 =
  //     false;
  //     bool isChecked1 =
  //     false;
  // bool isChecked2 =
  //     false;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Class Settings'),
        centerTitle: true,
        backgroundColor: Color(0xFF29D09E),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.school),
                labelText: 'Change class name',
                labelStyle: TextStyle(
                  color: Color(0xFF29D09E),
                ),
                helperText: 'Year ID',
                suffixIcon: Icon(
                  Icons.check_circle,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF29D09E)),
                ),
              ),
            ),
            // const SizedBox(
            //   height: 16,
            // ),
            // Divider(
            //   thickness: 1,
            //   height: 1,
            // ),
            // const SizedBox(
            //   height: 16,
            // ),
            // CheckboxListTile(
            // title: Text("Skill 1"),

            //   value: isChecked0,
            //   onChanged: (kora0) {
            //     setState(() {
            //       isChecked0 = kora0!;
            //       }
            //     );
            //   },
            // ),
            // CheckboxListTile(
            // title: Text("Skill 2"),

            //   value: isChecked1,
            //   onChanged: (kora1) {
            //     setState(() {
            //       isChecked1 = kora1!;
            //       }
            //     );
            //   },
            // ),
            // CheckboxListTile(
            // title: Text("Skill 3"),

            //   value: isChecked2,
            //   onChanged: (kora2) {
            //     setState(() {
            //       isChecked2 = kora2!;
            //       }
            //     );
            //   },
            // ),
            // TextFormField(
            //   decoration: InputDecoration(
            //     icon: Icon(Icons.group),
            //     labelText: 'Add pupils',
            //     labelStyle: TextStyle(
            //       color: Color(0xFF29D09E),
            //     ),
            //     helperText: 'How many pupils to add?',
            //     suffixIcon: Icon(
            //       Icons.check_circle,
            //     ),
            //     enabledBorder: UnderlineInputBorder(
            //       borderSide: BorderSide(color: Color(0xFF29D09E)),
            //     ),
            //   ),
            // ),
            // ElevatedButton.icon(
            //   onPressed: () {},
            //   icon: Icon(Icons.add, size: 18),
            //   label: Text('Create'),

            // ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                primary: Color(0xFF29D09E),
              ),
              onPressed: () {
                Navigator.pop(context);

                final snackBar = SnackBar(
                    content: Text(
                        'Updated! :)'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: const Text('Change'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                primary: Color(0xFFF60000),
              ),
              onPressed: () {
                Navigator.pop(context);

                final snackBar = SnackBar(
                    content: Text(
                        'Killed the whole class! ☉ ‿ ⚆'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
