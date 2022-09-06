import 'package:flutter/material.dart';
import 'package:assessments_app/InovWidgets/NavBarStudent.dart';

class StudentPage extends StatefulWidget {
  StudentPage({Key? key}) : super(key: key);
  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBarStudent(),
      appBar: AppBar(
        title: Text('Main Page'),
        centerTitle: true,
        backgroundColor: Color(0xFF29D09E),
      ),
      body: Center(
        child: Text(
          "Assessments will be displayed here, once they are generated",
          style: TextStyle(fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: NavBar(),
//       appBar: AppBar(
//         title: Text('Main Page'),
//         centerTitle: true,
//       ),
//       body: Center(),
//     );
//   }
// }

// class MyHomePage extends StatelessWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final textTheme = theme.textTheme;

//     return Scaffold(
//       appBar: AppBar(title: Text(title)),
//       body: const Center(
//         child: Text('Home Page Feed'),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.all(20.0),
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 'Dashboard',
//                 style: textTheme.headline6
//               ),
//             ),
//             Divider(
//               height: 1,
//               thickness: 1,
//             ),
//             ListTile(
//               leading: Icon(Icons.assessment),
//               title: const Text('Assessments'),
//               onTap: () {
//                 // Update the state of the app
//                 // ...
//                 // Then close the drawer
//                 Navigator.pop(context);
//               },
//             ),

//             ListTile(
//               leading: Icon(Icons.text_snippet),
//               title: const Text('Evaluations'),
//               onTap: () {
//                 // Update the state of the app
//                 // ...
//                 // Then close the drawer
//                 Navigator.pop(context);
//               },
//             ),

//              ListTile(
//               leading: Icon(Icons.account_box),
//               title: const Text('Account'),
//               onTap: () {
//                 // Update the state of the app
//                 // ...
//                 // Then close the drawer
//                 Navigator.pop(context);
//               },

//             ),
//             ListTile(
//               leading: Icon(Icons.settings),
//               title: const Text('Settings'),
//               onTap: () {
//                 // Update the state of the app
//                 // ...
//                 // Then close the drawer
//                 Navigator.pop(context);
//               },

//             ),
//             ListTile(
//               leading: Icon(Icons.logout),
//               title: const Text('Log out'),
//               onTap: () {
//                 // Update the state of the app
//                 // ...
//                 // Then close the drawer
//                 Navigator.pop(context);
//               },

//             ),
//           ],
//         ),
//       ),
//     );

//   }
// }
