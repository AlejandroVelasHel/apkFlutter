import 'package:flutter/material.dart';
import 'package:flutter_application_1/Theme/theme.dart';
import 'package:flutter_application_1/home_screen/login.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const Login()
    );
  }
}