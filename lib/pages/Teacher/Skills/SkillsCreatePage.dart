import 'package:assessments_app/pages/Teacher/Skills/SkillsIndicatorsStage.dart';
import 'package:flutter/material.dart';

class SkillsCreatePage extends StatefulWidget {
  const SkillsCreatePage({Key? key}) : super(key: key);

  @override
  _SkillsCreatePageState createState() => _SkillsCreatePageState();
}

class _SkillsCreatePageState extends State<SkillsCreatePage> {
  double _sliderDiscreteValue = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Competence'),
        centerTitle: true,
        backgroundColor: Color(0xFF29D09E),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF29D09E),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SkillsIndicatorsStage()),
          );
          // Respond to button press
        },
        icon: Icon(Icons.skip_next),
        label: Text('Next'),
      ),
      body: Column(children: [
        const SizedBox(height: 16),
        TextFormField(
          initialValue: 'Name',
          maxLength: 20,
          decoration: InputDecoration(
            icon: Icon(Icons.comment),
            labelText: 'Competence name',
            labelStyle: TextStyle(
              color: Color(0xFF29D09E),
            ),
            helperText: 'What is the name of the competence?',
            suffixIcon: Icon(
              Icons.check_circle,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF29D09E)),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ListTile(
          leading: Icon(Icons.format_list_numbered),
          title: Text("How many indicators?"),
        ),
        Slider(
          value: _sliderDiscreteValue,
          min: 1,
          max: 5,
          divisions: 5,
          label: _sliderDiscreteValue.round().toString(),
          onChanged: (value) {
            setState(() {
              _sliderDiscreteValue = value;
            });
          },
        )
      ]),
    );
  }
}
        
//     return MaterialApp(
//       home: DefaultTabController(
//         length: 3,
//         child: Scaffold(
//         appBar: AppBar(
//           title: Text('Create a Competence'),
//           centerTitle: true,
//           backgroundColor: Color(0xFF29D09E),
//           bottom: TabBar(
//             tabs: [
//               Tab(text: "1"),
//               Tab(text: "2"),
//               Tab(text: "3"),
//             ],
//           ),
//        ) ,
//         body: TabBarView(
//             children: [
//                 Center(child: Text('1')),
//                 Center(child: Text('2')),
//                 Center(child: Text('BIRDS')),
//             ],
//       ),
//         ),
//       ),
//     );
//   }
// }
//       body: Form(
//         key: _formKey,
//         child: ListView(
//           // crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             TextFormField(
//               decoration: const InputDecoration(
//                 hintText: 'Enter the Assessment Title',
//               ),
//               validator: (String? value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter some text';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               decoration: const InputDecoration(
//                 hintText: 'Enter the Assessment #1',
//               ),
//               validator: (String? value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter some text';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               decoration: const InputDecoration(
//                 hintText: 'Score #1',
//               ),
//               validator: (String? value) {
//                 if (value == null ||
//                     value.isEmpty ||
//                     double.tryParse(value) == null) {
//                   return 'Please enter some number';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//           Divider(
//             thickness: 1,
//             height: 1,
//           ),
//           const SizedBox(height: 16),
//             TextFormField(
//               decoration: const InputDecoration(
//                 hintText: 'Enter the Assessment 2',
//               ),
//               validator: (String? value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter some text';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               decoration: const InputDecoration(
//                 hintText: 'Score #2',
//               ),
//               validator: (String? value) {
//                 if (value == null ||
//                     value.isEmpty ||
//                     double.tryParse(value) == null) {
//                   return 'Please enter some number';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//           Divider(
//             thickness: 1,
//             height: 1,
//           ),
//           const SizedBox(height: 16),
//             TextFormField(
//               decoration: const InputDecoration(
//                 hintText: 'Enter the Assessment 3',
//               ),
//               validator: (String? value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter some text';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               decoration: const InputDecoration(
//                 hintText: 'Score #3',
//               ),
//               validator: (String? value) {
//                 if (value == null ||
//                     value.isEmpty ||
//                     double.tryParse(value) == null) {
//                   return 'Please enter some number';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//           Divider(
//             thickness: 1,
//             height: 1,
//           ),
//           const SizedBox(height: 16),
//             TextFormField(
//               decoration: const InputDecoration(
//                 hintText: 'Enter the Assessment 4',
//               ),
//               validator: (String? value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter some text';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               decoration: const InputDecoration(
//                 hintText: 'Score #4',
//               ),
//               validator: (String? value) {
//                 if (value == null ||
//                     value.isEmpty ||
//                     double.tryParse(value) == null) {
//                   return 'Please enter some number';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//           Divider(
//             thickness: 1,
//             height: 1,
//           ),
//           const SizedBox(height: 16),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 16.0),
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Validate will return true if the form is valid, or false if
//                   // the form is invalid.
//                   if (_formKey.currentState!.validate()) {
//                     Navigator.pop(context);
//                   }
//                 },
//                 child: const Text('Create'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }