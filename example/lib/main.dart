import 'package:flutter/material.dart';
import 'view/home_view.dart';
import 'view/start_run_view.dart';
import 'view/history_view.dart';
import 'view/sensor_view.dart'; 
import 'view/details_view.dart';
import 'view/feedback_view.dart';

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

      // 🏠 Starter altid her
      initialRoute: '/',

      routes: {
        '/': (context) =>  HomeView(),
        '/start-run': (context) => const StartRunView(),
        '/history': (context) =>  HistoryView(),
        '/sensor': (context) => const SensorView(), 
        '/details': (context) => const DetailsView(),
        '/feedback': (context) {
  // Hent zone fra arguments
  final selectedZone = ModalRoute.of(context)!.settings.arguments as int;
  return FeedbackView(selectedZone: selectedZone);
},

      },
    );
  }
}
