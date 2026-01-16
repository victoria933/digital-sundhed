import 'dart:async';
import '../model/sensor_data.dart';

enum RunFeedback { slowDown, keepPace, speedUp }

class PulseZone {
  final int minHr;
  final int maxHr;
  PulseZone(this.minHr, this.maxHr);
}

class FeedbackViewModel {
  final SensorData sensorData;
  final int selectedZone; // 1-5

  FeedbackViewModel(this.sensorData, this.selectedZone);

  // Puls-stream
  Stream<int> get heartRateStream => sensorData.hrStream;

  // Feedback baseret på valgt zone
  late final Stream<RunFeedback> feedbackStream =
      heartRateStream.map((hr) {
    final zones = [
      PulseZone(60, 80),
      PulseZone(81, 100),
      PulseZone(101, 120),
      PulseZone(121, 140),
      PulseZone(141, 160),
    ];
    final zone = zones[selectedZone - 1];

    if (hr < zone.minHr) return RunFeedback.speedUp;
    if (hr > zone.maxHr) return RunFeedback.slowDown;
    return RunFeedback.keepPace;
  });

  // Start/stop
  void startRun(String uuid) => sensorData.start(uuid);
  void stopRun() => sensorData.stop();
  void dispose() => sensorData.dispose();
}



