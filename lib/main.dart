import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.bluetoothConnect.request();
  await Permission.bluetoothScan.request();
  await Permission.location.request(); // Sometimes needed for device discovery
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
