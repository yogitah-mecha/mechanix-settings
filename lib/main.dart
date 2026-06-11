import 'package:flutter/material.dart';

void main() {
  runApp(const MechanixMessageApp());
}

class MechanixMessageApp extends StatelessWidget {
  const MechanixMessageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mechanix Settings App',
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const Scaffold(body: Text('Mechanix Settings App')),
    );
  }
}
