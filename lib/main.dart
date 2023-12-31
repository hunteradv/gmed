import 'package:firebase_auth/firebase_auth.dart';
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
import 'notification_manager.dart';
import 'package:timezone/data/latest.dart' as tz;

const firebaseConfig = FirebaseOptions(
    apiKey: "AIzaSyCt3xUljE6HDfF6KDuhsI32N8rRBdo4OdU",
    authDomain: "gmed-6e006.firebaseapp.com",
    projectId: "gmed-6e006",
    storageBucket: "gmed-6e006.appspot.com",
    messagingSenderId: "561345286170",
    appId: "1:561345286170:web:b46ac4290edf8468f7c1a3");

var auth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseConfig);

  NotificationManager().initNotification();
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var user = auth.currentUser;

    return MaterialApp(
      theme: ThemeData(fontFamily: 'montserratLight'),
      debugShowCheckedModeBanner: false,
      initialRoute: user != null ? "/drugList" : '/homepage',
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
