import 'package:flutter/material.dart';
import 'package:assessments_app/pages/Settings/SettingsDispPage.dart';
import 'package:url_launcher/url_launcher.dart';

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
              onTap: () async {
                String email = Uri.encodeComponent("tgoncalves@inovlabs.com");
                String subject =
                    Uri.encodeComponent("ASSESSMENTS App report from user");
                String body = Uri.encodeComponent(
                    "Hi! I'm testing the wonderfull assessments app from Inovlabs\n I would like to say ");
                print(subject);
                Uri mail =
                    Uri.parse("mailto:$email?subject=$subject&body=$body");
                if (await launchUrl(mail)) {
                  //email app opened
                } else {
                  final snackBar = SnackBar(
                      content: Text(
                          'You must download an email app to send some feedback'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
            ),
          ],
        ));
  }
}
