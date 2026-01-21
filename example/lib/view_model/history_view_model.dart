import 'package:flutter/material.dart';
import '../data/storage.dart';

class HistoryViewModel extends ChangeNotifier {
  final RunStorage _storage = RunStorage();

  List<Map<String, dynamic>> runs = [];
  bool isLoading = false;

  Future<void> loadRuns() async {
    isLoading = true;
    notifyListeners();

    // Henter alle runs, ældste først
    runs = await _storage.getAllRuns();

    // Vend rækkefølgen, så nyeste vises øverst i appen
    runs = runs.reversed.toList();

    isLoading = false;
    notifyListeners();
  }
}
