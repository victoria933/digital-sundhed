import 'package:flutter/material.dart';
import '../data/storage.dart';

class HistoryViewModel extends ChangeNotifier {
  List<Map<String, dynamic>> runs = [];

Future<void> loadRuns() async {
  final allRuns = await RunStorage().getRuns();

  // Sortér efter timestamp faldende til  nyeste først
  runs = allRuns..sort((a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int));

  notifyListeners();
}
}


