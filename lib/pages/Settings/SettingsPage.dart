import 'package:flutter/material.dart';
import 'package:assessments_app/pages/Settings/SettingsDispPage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.settings),
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
              title: Text("Dark-theme"),
              // subtitle: Text(AppLocalizations.of(context)!.da),
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
            // ListTile(
            //   leading: Icon(Icons.bug_report),
            //   title: Text("Bug Report"),
            //   subtitle: Text("Send a request ticket to InovLabs HQ"),
            //   onTap: () async {
            //     String email = Uri.encodeComponent("tgoncalves@inovlabs.com");
            //     String subject =
            //         Uri.encodeComponent("ASSESSMENTS App report from user");
            //     String body = Uri.encodeComponent(
            //         "Hi! I'm testing the wonderfull assessments app from Inovlabs\n I would like to say that: ");
            //     print(subject);
            //     Uri mail =
            //         Uri.parse("mailto:$email?subject=$subject&body=$body");
            //     if (await canLaunchUrl(mail)) {
            //       launchUrl(mail);
            //       //email app opened
            //     } else {
            //       final snackBar = SnackBar(
            //           content: Text(
            //               'You must download an email app in order to send some feedback, thanks.'));
            //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
            //     }
            //   },
            // ),
          ],
        ));
  }
}
