import 'package:flutter/material.dart';
import 'package:lend_logs/homePage.dart';
import 'package:lend_logs/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Pay Logs',
        theme: ThemeData(primarySwatch: Utils.colortheme),
        home: HomePage());
  }
}
