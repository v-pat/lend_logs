import 'package:flutter/material.dart';
import 'package:lend_logs/homePage.dart';
import 'package:lend_logs/utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pay Logs',
      theme: ThemeData(
        primarySwatch: Utils.colortheme
      ),
      home:HomePage()
    );
  }
}

