import 'package:flutter/material.dart';
import 'view/home_view.dart';
import 'view/start_run_view.dart';
import 'view/history_view.dart';

void main() {
  runApp(const ZoneLoebApp());
}

class ZoneLoebApp extends StatelessWidget {
  const ZoneLoebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ZoneLøb',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeView(),
        '/start-run': (context) => const StartRunView(),
        '/history': (context) =>  HistoryView(),
        // Flere routes kan nemt tilføjes her
      },
    );
  }
}
