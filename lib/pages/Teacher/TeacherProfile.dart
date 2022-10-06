
import 'package:flutter/material.dart';

class TeacherProfile extends StatefulWidget {
  @override
  _TeacherProfileState createState() => _TeacherProfileState();
}

class _TeacherProfileState extends State<TeacherProfile>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher\'s Account'),
        centerTitle: true,
        backgroundColor: Color(0xFF29D09E),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new FloatingActionButton(
                elevation: 0.0,
                mini: true,
                child: new Icon(Icons.edit),
                backgroundColor: Color(0xFF29D09E),
                onPressed: () {})
          ],
        ),
      ),
      body: _body(context),
    );
  }

  _body(BuildContext context) =>
      ListView(physics: BouncingScrollPhysics(), children: <Widget>[
        Container(
            padding: EdgeInsets.all(15),
            child: Column(children: <Widget>[_headerSignUp(), _formUI()])),
        ListTile()
      ]);

  _headerSignUp() => Column(children: <Widget>[
        Container(
          height: 80,
          child: ClipOval(
            child: Image.network(
              'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.SicWhEKAfmTaTl1me6rTOgHaDt%26pid%3DApi&f=1',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 12.0),
        Text('Name',
            style: TextStyle(
                fontWeight: FontWeight.w700, color: Color(0xFF29D09E))),
      ]);

  _formUI() {
    return new Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 40.0),
          _email(),
          // SizedBox(height: 12.0),
          // _mobile(),
          SizedBox(height: 12.0),
          _birthDate(),
          SizedBox(height: 12.0),
        ],
      ),
    );
  }

  _email() {
    return Row(children: <Widget>[
      _prefixIcon(Icons.email),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Email', style: TextStyle(fontWeight: FontWeight.w700)),
          // color: Colors.grey)),
          SizedBox(height: 1),
          Text('teacher@domain.tld')
        ],
      )
    ]);
  }

  _birthDate() {
    return Row(children: <Widget>[
      _prefixIcon(Icons.date_range),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Birth date',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                // color: Colors.grey
              )),
          SizedBox(height: 1),
          Text('00-00-0000')
        ],
      )
    ]);
  }

  _prefixIcon(IconData iconData) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 48.0, minHeight: 48.0),
      child: Container(
          padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
          margin: const EdgeInsets.only(right: 8.0),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                  bottomRight: Radius.circular(10.0))),
          child: Icon(
            iconData,
            color: Colors.grey,
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}