import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AssessmentsStudentAll extends StatefulWidget {
  AssessmentsStudentAll({Key? key}) : super(key: key);
  @override
  _AssessmentsStudentAllState createState() => _AssessmentsStudentAllState();
}

class _AssessmentsStudentAllState extends State<AssessmentsStudentAll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.assessments),
        centerTitle: true,
        backgroundColor: Color(0xFF29D09E),
      ),
      body: Center(
        child: Text(
          AppLocalizations.of(context)!.assessdisplayhere,
          style: TextStyle(fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
