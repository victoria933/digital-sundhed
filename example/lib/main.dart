import 'package:flutter/material.dart';
import 'view/home_view.dart';
import 'view/history_view.dart';
// Tilføj flere views her efter behov

void main() {
  runApp(ZoneLoebApp());
}

class ZoneLoebApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZoneLøb',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeView(),
        '/history': (context) => HistoryView(),
        // Tilføj flere routes: '/start', '/sensor', '/details', '/scenario'
      },
    );
  }
}
