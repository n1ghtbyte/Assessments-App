import 'package:flutter/material.dart';

class AstaSettings extends StatefulWidget {
  const AstaSettings({Key? key}) : super(key: key);

  @override
  _AstaSettingsState createState() => _AstaSettingsState();
}

class _AstaSettingsState extends State<AstaSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Settings'),
        centerTitle: true,
        backgroundColor: Color(0xFF29D09E),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Name',
                helperText: 'Change name displayed',
                labelStyle: TextStyle(
                  color: Color(0xFF29D09E),
                ),
                suffixIcon: Icon(
                  Icons.check_circle,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF29D09E)),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.bug_report),
              title: Text("Contact"),
              subtitle: Text("Get student and his/her parent's email"),
              onTap: () {
                final snackBar =
                    SnackBar(content: Text('Check your email box :)'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                // Navigator.push( mostrar snackbar a avisar que o request foi feito !!!
                //   context,
                //   //
                //   //showBuggieSnackie()
                // );
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF29D09E),
              ),
              onPressed: () {
                Navigator.pop(context);

                final snackBar =
                    SnackBar(content: Text('Asta name was changed to Yuno'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: const Text('Save'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFFF60000),
              ),
              onPressed: () {
                Navigator.pop(context);

                final snackBar = SnackBar(content: Text('Killed! ☉ ‿ ⚆'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: const Text('Remove'),
            ),
          ],
        ),
      ),
    );
  }
}
