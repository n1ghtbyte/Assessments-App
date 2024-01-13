import 'package:assessments_app/firebase_options.dart';
import 'package:assessments_app/pages/Auth/LoginScreen.dart';
import 'package:assessments_app/pages/Parent/ParentMain.dart';
import 'package:assessments_app/pages/Student/Classes/StudentClasses.dart';
import 'package:assessments_app/pages/Teacher/Classes/ClassesPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overlay_kit/overlay_kit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

Future<FirebaseApp> _initializeFirebase() async {
  FirebaseApp firebaseApp = await Firebase.initializeApp();
  return firebaseApp;
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return OverlayKit(
      child: MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate, // Locale
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,

        // supportedLocales: [
        //   Locale('en'), // English
        //   Locale('pt'), // Portuguese
        //   Locale('el'), // Modern Greek
        //   Locale('es'), // Spanish
        // ],
        theme: ThemeData(
          primaryColor: Color(0xFF29D09E),
          scaffoldBackgroundColor: Colors.white,
          pageTransitionsTheme: PageTransitionsTheme(
            builders: Map<TargetPlatform, PageTransitionsBuilder>.fromIterable(
              TargetPlatform.values,
              value: (dynamic _) => const ZoomPageTransitionsBuilder(),
            ),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
              .copyWith(background: Colors.white),
        ),
        home: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              FirebaseAuth.instance.authStateChanges().listen(
                (User? user) {
                  if (user != null) {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.email)
                        .get()
                        .then((DocumentSnapshot documentSnapshot) {
                      if (documentSnapshot.exists) {
                        print('Document data: ${documentSnapshot['Status']}');
                        if (documentSnapshot['Status'] == "Teacher") {
                          Future.microtask(() {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => ClassesPage()),
                            );
                          });
                        } else if (documentSnapshot['Status'] == 'Student') {
                          Future.microtask(() {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => StudClassesMain()),
                            );
                          });
                        } else if (documentSnapshot['Status'] == 'Parent') {
                          Future.microtask(() {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => ParentMainScreen()),
                            );
                          });
                        }
                      }
                    });
                  }
                },
              );
              return LoginScreen();
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
