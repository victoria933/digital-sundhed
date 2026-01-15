
import 'package:flutter/material.dart';
import 'view/home_view.dart';
import 'view/start_run_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeView(), // Starter på Home
      routes: {
        '/start-run': (context) => const StartRunView(),
      },
    );
  }
}
