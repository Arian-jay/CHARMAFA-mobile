import 'package:flutter/material.dart';
import 'screens/login_page.dart';

void main() {
  runApp(const CharmAfaApp());
}

class CharmAfaApp extends StatelessWidget {
  const CharmAfaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CHARMAFA Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
