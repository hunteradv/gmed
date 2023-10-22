import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gmed/drugSchedulerConfig.dart';
import 'package:gmed/login.dart';
import 'package:gmed/drugList.dart';
import 'package:gmed/recoveryPassword.dart';
import 'package:gmed/register.dart';
import 'drugDetail.dart';
import 'drugPeriodConfig.dart';
import 'homePage.dart';

const firebaseConfig = FirebaseOptions(
    apiKey: "AIzaSyCt3xUljE6HDfF6KDuhsI32N8rRBdo4OdU",
    authDomain: "gmed-6e006.firebaseapp.com",
    projectId: "gmed-6e006",
    storageBucket: "gmed-6e006.appspot.com",
    messagingSenderId: "561345286170",
    appId: "1:561345286170:web:b46ac4290edf8468f7c1a3");

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseConfig);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'montserratLight'),
      debugShowCheckedModeBanner: false,
      initialRoute: '/homepage',
      routes: {
        '/homepage': (context) => const HomePage(),
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
        '/recoveryPassword': (context) => RecoveryPasswordPage(),
        '/drugList': (context) => DrugListPage(),
        '/drugDetail': (context) => const DrugDetailPage(),
        '/drugPeriodConfig': (context) => const DrugPeriodConfigPage(),
        "/drugSchedulerConfig": (context) => const DrugSchedulerConfigPage()
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [Locale('pt', 'BR')],
    );
  }
}
