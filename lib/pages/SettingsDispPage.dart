import 'package:flutter/material.dart';

class SettingsDispPage extends StatelessWidget {
  const SettingsDispPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display'),
        centerTitle: true,
        backgroundColor: Color(0xFF29D09E),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          const SizedBox(height: 16),
          SwitchListTile(
            title: Text("\tEnable dark theme"),
            subtitle:
                Text("\tSave power"),
            value: false,
            onChanged: (val) {},
            contentPadding: EdgeInsets.all(0),
            activeColor: Colors.cyan,
          ),
        ],
      ),
    );
  }
}
