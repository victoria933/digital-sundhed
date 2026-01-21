import 'package:flutter/material.dart';
import '../data/storage.dart';


class HistoryViewModel extends ChangeNotifier {
  final RunStorage _storage = RunStorage();

  List<Map<String, dynamic>> runs = [];
  bool isLoading = false;

  Future<void> loadRuns() async {
    isLoading = true;
    notifyListeners();

    // Henter allerede sorteret fra storage
    runs = await _storage.getAllRuns();

    // Nyeste først (valgfrit – fjern hvis du vil have ældste først)
    runs = runs.reversed.toList();

    isLoading = false;
    notifyListeners();
  }
}


