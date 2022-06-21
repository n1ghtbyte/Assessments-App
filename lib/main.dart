import 'package:assessments_app/pages/LoginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return LoginScreen();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
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
// }// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:assessments_app/InovWidgets/NavBar.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         primaryColor: Color(0xFF29D09E),
//       ),
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key}) : super(key: key);
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         drawer: NavBar(),
//         appBar: AppBar(
//           title: Text('Main Page'),
//           centerTitle: true,
//           backgroundColor: Color(0xFF29D09E),
//         ),
//         body: ListView(
//         scrollDirection: Axis.vertical,
//         children: const <Widget>[
//           const SizedBox(
//             height: 16
//           ),
//           ListTile(
//             leading: Icon(Icons.functions),
//             title: Text("Math"),
//             subtitle: Text("Deliver date: XX/YY/ZZ"),
//           ),
//           const SizedBox(
//             height: 16
//           ),
//           Divider(
//             thickness: 1,
//             height: 1,
//           ),
//           const SizedBox(
//             height: 16
//           ),
//           ListTile(
//             leading: Icon(Icons.group),
//             title: Text("Peer Assessment"),
//             subtitle: Text("Deliver Date: XX/YY/ZZ"),
//           ),
//           const SizedBox(
//             height: 16
//           ),
//           Divider(
//             thickness: 1,
//             height: 1,
//           ),
//           const SizedBox(
//             height: 16
//           ),
//           ListTile(
//             leading: Icon(Icons.science),
//             title: Text("Science"),
//             subtitle: Text("Deliver date: XX/YY/ZZ"),
//           ),
//           const SizedBox(
//             height: 16
//           ),
//           Divider(
//             thickness: 1,
//             height: 1,
//           ),
//           const SizedBox(
//             height: 16
//           ),
//           ListTile(
//             leading: Icon(Icons.group),
//             title: Text("Peer Assessment"),
//             subtitle: Text("Deliver Date: XX/YY/ZZ"),
//           ),
//           const SizedBox(
//             height: 16
//           ),
//           Divider(
//             thickness: 1,
//             height: 1,
//           ),
//           const SizedBox(
//             height: 16
//           ),
//           ListTile(
//             leading: Icon(Icons.language),
//             title: Text("Languages"),
//             subtitle: Text("Deliver date: XX/YY/ZZ"),
//           ),
//           const SizedBox(
//             height: 16
//           ),
//           Divider(
//             thickness: 1,
//             height: 1,
//           ),
//           const SizedBox(
//             height: 16
//           ),
//           ListTile(
//             leading: Icon(Icons.self_improvement),
//             title: Text("Self Assessment"),
//             subtitle: Text("Deliver date: XX/YY/ZZ"),
//           ),
//           const SizedBox(
//             height: 16
//           ),
//           Divider(
//             thickness: 1,
//             height: 1,
//           ),
//           const SizedBox(
//             height: 16
//           ),
//           ListTile(
//             leading: Icon(Icons.school),
//             title: Text("Teacher Assessment"),
//             subtitle: Text("Deliver date: XX/YY/ZZ"),
//           ),
//           const SizedBox(
//             height: 16
//           ),
//           Divider(
//             thickness: 1,
//             height: 1,
//           ),
//           const SizedBox(
//             height: 16
//           ),
//           ListTile(
//             leading: Icon(Icons.group),
//             title: Text("Peer Assessment"),
//             subtitle: Text("Deliver date: XX/YY/ZZ"),
//           ),
//           const SizedBox(
//             height: 16
//           ),
//           Divider(
//             thickness: 1,
//             height: 1,
//           ),
//           const SizedBox(
//             height: 16
//           ),
//           ListTile(
//             leading: Icon(Icons.self_improvement),
//             title: Text("Self Assessment"),
//             subtitle: Text("Deliver date: XX/YY/ZZ"),
//           ),
//           const SizedBox(
//             height: 16
//           ),
//           Divider(
//             thickness: 1,
//             height: 1,
//           ),
//           const SizedBox(
//             height: 16
//           ),
//           ListTile(
//             leading: Icon(Icons.functions),
//             title: Text("Math"),
//             subtitle: Text("Deliver date: XX/YY/ZZ"),
//           ),
//           const SizedBox(
//             height: 16
//           ),
//           Divider(
//             thickness: 1,
//             height: 1,
//           ),
//           const SizedBox(
//             height: 16
//           ),
//           ListTile(
//             leading: Icon(Icons.group),
//             title: Text("Peer Assessment"),
//             subtitle: Text("Deliver Date: XX/YY/ZZ"),
//           ),
//           const SizedBox(
//             height: 16
//           ),
//           Divider(
//             thickness: 1,
//             height: 1,
//           ),
//           const SizedBox(
//             height: 16
//           ),
//           ListTile(
//             leading: Icon(Icons.science),
//             title: Text("Science"),
//             subtitle: Text("Deliver date: XX/YY/ZZ"),
//           ),
//           const SizedBox(
//             height: 16
//           ),
//           Divider(
//             thickness: 1,
//             height: 1,
//           ),
//           const SizedBox(
//             height: 16
//           ),
//           ListTile(
//             leading: Icon(Icons.group),
//             title: Text("Peer Assessment"),
//             subtitle: Text("Deliver Date: XX/YY/ZZ"),
//           ),
//           const SizedBox(
//             height: 16
//           ),
//           Divider(
//             thickness: 1,
//             height: 1,
//           ),
//           const SizedBox(
//             height: 16
//           ),
//           ListTile(
//             leading: Icon(Icons.language),
//             title: Text("Languages"),
//             subtitle: Text("Deliver date: XX/YY/ZZ"),
//           ),
//           const SizedBox(
//             height: 16
//           ),
//           Divider(
//             thickness: 1,
//             height: 1,
//           ),
//           const SizedBox(
//             height: 16
//           ),
//           ListTile(
//             leading: Icon(Icons.self_improvement),
//             title: Text("Self Assessment"),
//             subtitle: Text("Deliver date: XX/YY/ZZ"),
//           ),
//           const SizedBox(
//             height: 16
//           ),
//         ],
//       )
//       )
//     );
//   }
// }
// // class _MyHomePageState extends State<MyHomePage> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       drawer: NavBar(),
// //       appBar: AppBar(
// //         title: Text('Main Page'),
// //         centerTitle: true,
// //       ),
// //       body: Center(),
// //     );
// //   }
// // }

// // class MyHomePage extends StatelessWidget {
// //   const MyHomePage({Key? key, required this.title}) : super(key: key);

// //   final String title;

// //   @override
// //   Widget build(BuildContext context) {
// //     final theme = Theme.of(context);
// //     final textTheme = theme.textTheme;

// //     return Scaffold(
// //       appBar: AppBar(title: Text(title)),
// //       body: const Center(
// //         child: Text('Home Page Feed'),
// //       ),
// //       drawer: Drawer(
// //         child: ListView(
// //           padding: EdgeInsets.all(20.0),
// //           children: <Widget>[
// //             Padding(
// //               padding: const EdgeInsets.all(16.0),
// //               child: Text(
// //                 'Dashboard',
// //                 style: textTheme.headline6
// //               ),
// //             ),
// //             Divider(
// //               height: 1,
// //               thickness: 1,
// //             ),
// //             ListTile(
// //               leading: Icon(Icons.assessment),
// //               title: const Text('Assessments'),
// //               onTap: () {
// //                 // Update the state of the app
// //                 // ...
// //                 // Then close the drawer
// //                 Navigator.pop(context);
// //               },
// //             ),

// //             ListTile(
// //               leading: Icon(Icons.text_snippet),
// //               title: const Text('Evaluations'),
// //               onTap: () {
// //                 // Update the state of the app
// //                 // ...
// //                 // Then close the drawer
// //                 Navigator.pop(context);
// //               },
// //             ),

// //              ListTile(
// //               leading: Icon(Icons.account_box),
// //               title: const Text('Account'),
// //               onTap: () {
// //                 // Update the state of the app
// //                 // ...
// //                 // Then close the drawer
// //                 Navigator.pop(context);
// //               },

// //             ),
// //             ListTile(
// //               leading: Icon(Icons.settings),
// //               title: const Text('Settings'),
// //               onTap: () {
// //                 // Update the state of the app
// //                 // ...
// //                 // Then close the drawer
// //                 Navigator.pop(context);
// //               },

// //             ),
// //             ListTile(
// //               leading: Icon(Icons.logout),
// //               title: const Text('Log out'),
// //               onTap: () {
// //                 // Update the state of the app
// //                 // ...
// //                 // Then close the drawer
// //                 Navigator.pop(context);
// //               },

// //             ),
// //           ],
// //         ),
// //       ),
// //     );

// //   }
// // }
