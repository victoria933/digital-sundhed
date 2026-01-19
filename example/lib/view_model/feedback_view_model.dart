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
  final int selectedZone; // 1-5
  final int age; // For maxpuls formel: 220 - alder
  final int restingHr; // Hvis du vil inkludere heart rate reserve

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
    this.restingHr = 60,
  }) {
    // 🔹 Beregn maxpuls og zonegrænser dynamisk
    final maxHr = 220 - age;
    zones = List.generate(5, (i) {
      final min = restingHr + ((i * 20) / 100 * (maxHr - restingHr)).round();
      final max = restingHr + (((i + 1) * 20) / 100 * (maxHr - restingHr)).round();
      return PulseZone(min, max);
    });

    // 🔹 Lyt til puls
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

  void startRun(String uuid) => sensorData.start(uuid);
  void stopRun() => sensorData.stop();

  @override
  void dispose() {
    _hrSub?.cancel();
    sensorData.dispose();
    super.dispose();
  }
}


