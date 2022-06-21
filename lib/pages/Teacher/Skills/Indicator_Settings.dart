import 'package:flutter/material.dart';

class IndicatorSettings extends StatefulWidget {
  const IndicatorSettings({Key? key}) : super(key: key);

  @override
  _SkillsCreatePageState createState() => _SkillsCreatePageState();
}

class _SkillsCreatePageState extends State<IndicatorSettings> {

  @override
  Widget build(BuildContext context) {
 return Scaffold(
         
      appBar: AppBar(
        title: Text('Create a Competence'),
        centerTitle: true,
        backgroundColor: Color(0xFF29D09E),
        
      ),floatingActionButton:
         FloatingActionButton.extended(
          backgroundColor: const Color(0xFF29D09E),
          onPressed: () {
            Navigator.pop(context);
          },
          
          label: Text('Save'),
          icon: Icon(Icons.save),
    ),
      body:
      SafeArea(
        child: ListView(
          
          children: [
            
            TextFormField(
         initialValue: '',
         maxLength: 80,
         decoration: InputDecoration(
           icon: Icon(Icons.comment),
           labelText: 'Indicators Name',
           labelStyle: TextStyle(
         color: Color(0xFF29D09E),
           ),
         ),
            ),
           TextFormField(
         initialValue: '',
         maxLength: 80,
         decoration: InputDecoration(
           icon: Icon(Icons.comment),
           labelText: 'Descriptor 1',
           labelStyle: TextStyle(
         color: Color(0xFF29D09E),
           ),
         ),
           ),
           TextFormField(
         initialValue: '',
         maxLength: 80,
         decoration: InputDecoration(
           icon: Icon(Icons.comment),
           labelText: 'Descriptor 2',
           labelStyle: TextStyle(
         color: Color(0xFF29D09E),
           ),
         ),
           ),
           
           TextFormField(
         initialValue: '',
         maxLength: 80,
         decoration: InputDecoration(
           icon: Icon(Icons.comment),
           labelText: 'Descriptor 3',
           labelStyle: TextStyle(
         color: Color(0xFF29D09E),
           ),
         ),
           ),
           
           TextFormField(
         initialValue: '',
         maxLength: 80,
         decoration: InputDecoration(
           icon: Icon(Icons.comment),
           labelText: 'Descriptor 4',
           labelStyle: TextStyle(
         color: Color(0xFF29D09E),
           ),
         ),
           ),
           
           TextFormField(
         initialValue: '',
         maxLength: 80,
         decoration: InputDecoration(
           icon: Icon(Icons.comment),
           labelText: 'Descriptor 5',
           labelStyle: TextStyle(
         color: Color(0xFF29D09E),
           ),
         ),
           ),
           
                  
        
          
          ]
       ),
      ),
     
 );
  }
}