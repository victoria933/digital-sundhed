import 'dart:async';
import 'package:flutter/material.dart';
import '../model/sensor_data.dart';

enum RunFeedback { slowDown, keepPace, speedUp }

class PulseZone {
  final int minHr;
  final int maxHr;
  PulseZone(this.minHr, this.maxHr);
}

class FeedbackViewModel extends ChangeNotifier {
  final SensorData sensorData;
  final int selectedZone; // 1–5
  final int age; // bruges til maxHR = 220 - age
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  Duration get elapsed => _stopwatch.elapsed;


  

  int _currentHr = 0;
  int get currentHr => _currentHr;

  RunFeedback _currentFeedback = RunFeedback.keepPace;
  RunFeedback get currentFeedback => _currentFeedback;

  late final List<PulseZone> zones;
  StreamSubscription<int>? _hrSub;

  FeedbackViewModel({
    required this.sensorData,
    required this.selectedZone,
    required this.age,
  }) {
    //  Beregn maxHR
    final maxHr = 220 - age;

    //  Zonegrænser som % af maxHR
zones = List.generate(5, (i) {
  final min = ((50 + i * 10) / 100 * maxHr).round();
  final max = ((50 + (i + 1) * 10) / 100 * maxHr).round();
  return PulseZone(min, max);
});


    //  Lyt til puls
    _hrSub = sensorData.hrStream.listen((hr) {
      _currentHr = hr;
      _updateFeedback(hr);
      notifyListeners();
    });
  }

  void _updateFeedback(int hr) {
    final zone = zones[selectedZone - 1];

    if (hr < zone.minHr) {
      _currentFeedback = RunFeedback.speedUp;
    } else if (hr > zone.maxHr) {
      _currentFeedback = RunFeedback.slowDown;
    } else {
      _currentFeedback = RunFeedback.keepPace;
    }
  }

void startRun(String uuid) {
  _stopwatch
    ..reset()
    ..start();

  _timer?.cancel();
  _timer = Timer.periodic(const Duration(seconds: 1), (_) {
    notifyListeners();
  });

  sensorData.start(uuid);
}

  // 🔹 Tilføjet stopRun
  void stopRun() {
    _stopwatch.stop();
    _timer?.cancel();
    sensorData.stop();
    notifyListeners();
  }


@override
void dispose() {
  _timer?.cancel();
  _stopwatch.stop();
  _hrSub?.cancel();
  sensorData.dispose();
  super.dispose();
}

}


