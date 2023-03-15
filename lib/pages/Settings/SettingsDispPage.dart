import 'package:flutter/material.dart';

class SettingsDispPage extends StatelessWidget {
  const SettingsDispPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display'),
        centerTitle: false,
        backgroundColor: Color(0xFF29D09E),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            child: SwitchListTile(
              title: Text("\tEnable dark theme"),
              subtitle: Text("\tSave power"),
              value: false,
              onChanged: (val) {},
              activeColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
