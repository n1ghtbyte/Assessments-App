import 'package:flutter/material.dart';

class AssessmentsCreateStudent extends StatefulWidget {
  const AssessmentsCreateStudent({Key? key}) : super(key: key);

  @override
  _AssessmentsCreateStudentState createState() =>
      _AssessmentsCreateStudentState();
}

class _AssessmentsCreateStudentState extends State<AssessmentsCreateStudent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Assessment'),
        centerTitle: true,
        backgroundColor: Color(0xFF29D09E),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            TextFormField(
              initialValue: 'Input Text',
              decoration: InputDecoration(
                icon: Icon(Icons.self_improvement),
                labelStyle: TextStyle(
                  color: Color(0xFF29D09E),
                ),
                helperText: 'helper text.',
                suffixIcon: Icon(
                  Icons.check_circle,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF29D09E)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class DropdownMenuDemo extends StatelessWidget {
// @override

//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dropdown Menu Button'),
//         actions: [
//           PopupMenuButton(
//             icon: Icon(Icons.more_vert),
//             itemBuilder: (BuildContext context) => <PopupMenuEntry>[
//               const PopupMenuItem(
//                 child: ListTile(
//                   leading: Icon(Icons.add),
//                   title: Text('Item 1'),
//                 ),
//               ),
//               const PopupMenuItem(
//                 child: ListTile(
//                   leading: Icon(Icons.anchor),
//                   title: Text('Item 2'),
//                 ),
//               ),
//               const PopupMenuItem(
//                 child: ListTile(
//                   leading: Icon(Icons.article),
//                   title: Text('Item 3'),
//                 ),
//               ),
//               const PopupMenuDivider(),
//               const PopupMenuItem(child: Text('Item A')),
//               const PopupMenuItem(child: Text('Item B')),
//             ],
//           ),
//         ],
//       ),
//       body: Center(),
//     );
//   }
// }

//   class CreateAssessmentPage extends StatefulWidget {
//     const CreateAssessmentPage({ Key? key }) : super(key: key);

//     @override
//     _CreateAssessmentPageState createState() => _CreateAssessmentPageState();
//   }

//   class _CreateAssessmentPageState extends State<CreateAssessmentPage> {
//     final items = ['Self', 'Peer'];
//     String? value;
//     @override
//     Widget build(BuildContext context) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('Create Assessment'),
//           centerTitle: true,
//           backgroundColor: Color(0xFF29D09E),
//         ),
//         body: SafeArea(
//           child: ListView(
//             children: [
//               TextFormField(
//                 initialValue: 'Input Text',
//                 decoration: InputDecoration(
//                   icon: Icon(Icons.self_improvement),
//                   labelText: 'This is a motherfucking label',
//                   labelStyle: TextStyle(
//                     color: Color(0xFF29D09E),
//                   ),
//                   helperText: 'And this guess what is a helper text.',
//                   suffixIcon: Icon(
//                     Icons.check_circle,
//                   ),
//                   enabledBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: Color(0xFF29D09E)),
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.all(16),
//                 padding: EdgeInsets.symmetric(horizontal:12, vertical: 4),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.black, width: 2),
//                 ),
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton<String>(
//                     value: value,
//                     iconSize: 36,
//                     icon: Icon(Icons.arrow_drop_down, color: Colors.black),
//                     items: items.map(buildMenuItem).toList(),
//                     onChanged: (value) => setState(() =>this.value = value),
//                   ),
//                 ),
//               )

//           ],
//         ),
//       ),
//     );
//   }

//   DropdownMenuItem<String> buildMenuItem(String item) =>
//         DropdownMenuItem(
//           value: item,
//           child:
//             Text(
//               item,
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//             )
//         );
// }
