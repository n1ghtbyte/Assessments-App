import 'package:flutter/material.dart';

class SettingsNotifPage extends StatelessWidget {
  const SettingsNotifPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        centerTitle: true,
        backgroundColor: Color(0xFF29D09E),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          const SizedBox(height: 16),
          SwitchListTile(
            title: Text("         Disable notifications"),
            subtitle: Text(
                "          Completely disable notifications"),
            value: true,
            onChanged: (val) {},
            contentPadding: EdgeInsets.all(0),
            activeColor: Colors.cyan,
          ),
        ],
      ),
    );
  }
}
