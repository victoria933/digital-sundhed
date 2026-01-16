import '../model/sensor_data.dart';
import 'dart:async';

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

  // 🔴 Puls-stream
  Stream<int> get heartRateStream => sensorData.hrStream;

  // 🔴 Feedback baseret på valgt zone
  final List<PulseZone> zones = [
    PulseZone(60, 80),
    PulseZone(81, 100),
    PulseZone(101, 120),
    PulseZone(121, 140),
    PulseZone(141, 160),
  ];

  late final Stream<RunFeedback> feedbackStream = heartRateStream.map((hr) {
    final zone = zones[selectedZone - 1];
    if (hr < zone.minHr) return RunFeedback.speedUp;
    if (hr > zone.maxHr) return RunFeedback.slowDown;
    return RunFeedback.keepPace;
  });

  // 🔴 Live tid
  final _timeController = StreamController<Duration>.broadcast();
  Stream<Duration> get timeStream => _timeController.stream;
  Timer? _timer;
  Duration _elapsed = Duration.zero;

  // 🔴 Live distance i km (simuleret)
  final _distanceController = StreamController<double>.broadcast();
  Stream<double> get distanceStream => _distanceController.stream;
  double _distance = 0;
  final double speedKmh = 10; // simuleret 10 km/t

  // 🔴 Start run (starter puls, tid og distance)
  void startRun() {
    sensorData.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      // Tid
      _elapsed += const Duration(seconds: 1);
      _timeController.add(_elapsed);

      // Distance
      _distance += speedKmh / 3600; // km per sekund
      _distanceController.add(_distance);
    });
  }

  void stopRun() {
    sensorData.stop();
    _timer?.cancel();
  }

  void dispose() {
    sensorData.dispose();
    _timer?.cancel();
    _timeController.close();
    _distanceController.close();
  }
}


