import 'package:assessments_app/InovWidgets/NavBarParent.dart';
import 'package:assessments_app/pages/Parent/Student/ChildClasses.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ParentMainScreen extends StatefulWidget {
  const ParentMainScreen({Key? key}) : super(key: key);

  @override
  State<ParentMainScreen> createState() => _ParentMainScreenState();
}

class _ParentMainScreenState extends State<ParentMainScreen> {
  String? currentUser;
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser!.email;
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser)
          .get();
      setState(() {
        data = snapshot.data() as Map<String, dynamic>;
      });
    } catch (error) {
      // Handle the error condition
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return Scaffold(
        drawer: NavBarParent(),
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.children),
          centerTitle: true,
          backgroundColor: Color(0xFF29D09E),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (data!['children'] == null) {
      return Scaffold(
        drawer: NavBarParent(),
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.children),
          centerTitle: true,
          backgroundColor: Color(0xFF29D09E),
        ),
        body: Center(
          child: Text(
            ".......",
            style: TextStyle(fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      return Scaffold(
        drawer: NavBarParent(),
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.children),
          centerTitle: true,
          backgroundColor: Color(0xFF29D09E),
        ),
        body: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: data!['children'].length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("${data!['children'][index]}"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChildClasses(
                      passedEmail: data!['children'][index].toString(),
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    }
  }
}
