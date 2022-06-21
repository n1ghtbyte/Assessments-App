import 'package:assessments_app/pages/Teacher/Skills/Skills2.dart';
import 'package:assessments_app/pages/Teacher/Skills/SkillsCreatePage.dart';
import 'package:assessments_app/pages/Teacher/Skills/SkillsInfoPage.dart';
import 'package:flutter/material.dart';

// class SkillsPage extends StatefulWidget {
//   const SkillsPage({ Key? key }) : super(key: key);

//   @override
//   _SkillsPageState createState() => _SkillsPageState();
// }

// class _SkillsPageState extends State<SkillsPage> {
//   bool value = false;
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(appBar: AppBar(
//         title: Text('Skills'),
//         centerTitle: true,
//         backgroundColor: Color(0xFF29D09E),
//       ),
//       body: ListView(
//         scrollDirection: Axis.vertical,
//         children: <Widget>[
//           const SizedBox(height: 16),
//           ListTile(
//             title: Text("         Skill 1"),
//             leading: Icon(Icons.menu_book),
//             subtitle: Text(
//                 "          Critical Thinking"),
//           ),
//         ],
//       ),
//       ),
//     );
//   }
// }
class SkillsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Competences'),
        centerTitle: true,
        backgroundColor: Color(0xFF29D09E),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SkillsCreatePage()),
          );
        },
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          const SizedBox(height: 32),
          ListTile(
            leading: Icon(Icons.menu_book),
            title: Text("Competence 1"),
            subtitle: Text("Critical Thinking"),
            trailing: Icon(Icons.arrow_right_alt),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SkillsInfoPage()),
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
            leading: Icon(Icons.menu_book),
            title: Text("Competence 2"),
            subtitle: Text("Creativity"),
            trailing: Icon(Icons.arrow_right_alt),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Skills2()),
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
            leading: Icon(Icons.menu_book),
            title: Text("Competence 3"),
            subtitle: Text("Interpersonal Communication"),
            trailing: Icon(Icons.arrow_right_alt),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SkillsInfoPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
