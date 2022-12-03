import 'package:flutter/material.dart';
import 'package:assessments_app/pages/SettingsNotifPage.dart';
import 'package:assessments_app/pages/SettingsDispPage.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          centerTitle: true,
          backgroundColor: Color(0xFF29D09E),
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            const SizedBox(height: 16),
            ListTile(
              enabled: false,
              leading: Icon(Icons.notifications),
              title: Text("Notifications"),
              subtitle: Text("Change the occurance"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsNotifPage()),
                );
              },
            ),
            const SizedBox(height: 16),
            Divider(
              thickness: 1,
              height: 1,
            ),
            const SizedBox(height: 16),
            ListTile(
              enabled: false,
              leading: Icon(Icons.settings_display),
              title: Text("Display"),
              subtitle: Text("Dark mode, colors, navigation"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsDispPage()),
                );
              },
            ),
            const SizedBox(height: 16),
            Divider(
              thickness: 1,
              height: 1,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.bug_report),
              title: Text("Bug Report"),
              subtitle: Text("Send a request ticket to InovLabs HQ"),
              onTap: () {
                final snackBar = SnackBar(
                    content: Text(
                        'You have send a request to the InovLabs HQ, wait until we reach you.'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                // Navigator.push( mostrar snackbar a avisar que o request foi feito !!!
                //   context,
                //   //
                //   //showBuggieSnackie()
                // );
              },
            ),
          ],
        ));
  }
}
