import 'package:assessments_app/firebase_options.dart';
import 'package:assessments_app/pages/LoginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF29D09E),
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        pageTransitionsTheme: PageTransitionsTheme(
          builders: Map<TargetPlatform, PageTransitionsBuilder>.fromIterable(
            TargetPlatform.values,
            value: (dynamic _) => const ZoomPageTransitionsBuilder(),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
    );
  }
}
