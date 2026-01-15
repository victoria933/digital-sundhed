import '../model/run_history.dart';

class HistoryViewModel {
  List<RunHistory> getHistory() {
    return [
      RunHistory(date: DateTime(2024, 1, 31), duration: Duration(minutes: 75), distance: 14.7, zone: 3),
      RunHistory(date: DateTime(2024, 2, 3), duration: Duration(minutes: 51), distance: 9.78, zone: 2),
      RunHistory(date: DateTime(2024, 2, 7), duration: Duration(minutes: 53), distance: 5.2, zone: 1),
      RunHistory(date: DateTime(2024, 2, 10), duration: Duration(minutes: 58), distance: 10.0, zone: 3),
    ];
  }
}

