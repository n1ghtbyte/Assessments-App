import 'package:assessments_app/utils/UserPrefs.dart';
import 'package:assessments_app/model/Student.dart';
import 'package:assessments_app/InovWidgets/ProfileWidget.dart';
import 'package:assessments_app/InovWidgets/StatsWidget.dart';

import 'package:flutter/material.dart';

class AccountTeacherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final student = UserPrefs.myUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        centerTitle: true,
        backgroundColor: Color(0xFF29D09E),
      ),
      body: ListView(
        children: [
          ProfileWidget(imagePath: student.imagePath, onClicked: () async {}),
          const SizedBox(height: 24),
          buildName(student),
          const SizedBox(height: 24),
          StatsWidget(),
        ],
      ),
    );
  }
}

//       body: Stack(
//         children: <Widget>[
//          ListView(
//            ProfileWidget(
//             imagePath: student.imagePath,
//             onClicked: () async {}
//             ),
//           const SizedBox(height: 24),
//           buildName(student),
//           const SizedBox(height: 24),
//           StatsWidget(),
//          )
//         ],
//       ),
//     );
//   }
// }

Widget buildName(Student user) => Column(
      children: [
        Text(
          user.name + ', on the ' + user.grade,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 4),
      ],
    );
