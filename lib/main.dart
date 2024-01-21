import 'package:assessments_app/firebase_options.dart';
import 'package:assessments_app/pages/Auth/LoginScreen.dart';
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
        home: const LoginScreen(),
      ),
    );
  }
}
