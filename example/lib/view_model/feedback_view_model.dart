import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../model/sensor_data.dart';
import '../data/storage.dart';

enum RunFeedback { slowDown, keepPace, speedUp }

class PulseZone {
  final int minHr;
  final int maxHr;
  PulseZone(this.minHr, this.maxHr);
}

class FeedbackViewModel extends ChangeNotifier {
  final SensorData sensorData;
  final int selectedZone;
  final int age;
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  final List<int> _hrSamples = [];
  DateTime? _runStartTime;
  bool _gpsReady = false; // ⭐⭐⭐ DEN MANGLEDE


  Duration get elapsed => _stopwatch.elapsed;
  int _currentHr = 0;
  int get currentHr => _currentHr;

  RunFeedback _currentFeedback = RunFeedback.keepPace;
  RunFeedback get currentFeedback => _currentFeedback;

  late final List<PulseZone> zones;
  StreamSubscription<int>? _hrSub;

  // GPS / Distance
  Position? _lastPosition;
  double totalDistance = 0.0;
  StreamSubscription<Position>? _positionStream;

  FeedbackViewModel({
    required this.sensorData,
    required this.selectedZone,
    required this.age,
  }) {
    final maxHr = 220 - age;

    zones = List.generate(5, (i) {
      final min = ((50 + i * 10) / 100 * maxHr).round();
      final max = ((50 + (i + 1) * 10) / 100 * maxHr).round();
      return PulseZone(min, max);
    });

    // Lyt til puls
_hrSub = sensorData.hrStream.listen((hr) {
  _currentHr = hr;

  _hrSamples.add(hr); //  GEM SAMPLE

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

Future<void> _startGPSTracking() async {
  final ok = await _handleLocationPermission();
  if (!ok) return;

  _lastPosition = null; 

  _positionStream = Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 5,
    ),
  ).listen(_updateDistance);
}


  void _stopGPSTracking() {
    _positionStream?.cancel();
    _positionStream = null;
    _lastPosition = null;
  }

static const double minNoiseDistance = 10.0; // meter
static const int noiseIgnoreSeconds = 5;

static const int warmupSeconds = 10;
static const double minMoveDistance = 8.0;

void _updateDistance(Position position) {
  if (_runStartTime == null) return;

  final secondsSinceStart =
      DateTime.now().difference(_runStartTime!).inSeconds;

  // ⭐ Sæt startpunkt én gang
  if (_lastPosition == null) {
    _lastPosition = position;
    debugPrint('Start GPS point sat');
    return;
  }

  final d = Geolocator.distanceBetween(
    _lastPosition!.latitude,
    _lastPosition!.longitude,
    position.latitude,
    position.longitude,
  );

  // 🛑 WARMUP-PERIODE
  if (!_gpsReady) {
    if (secondsSinceStart < warmupSeconds || d < minMoveDistance) {
      debugPrint('GPS warmup – ignoring: $d m');
      return; // ❗ VIGTIGT: vi flytter IKKE lastPosition
    }

    // ✅ GPS er nu stabil
    _gpsReady = true;
    debugPrint('GPS ready – start tracking');
    _lastPosition = position;
    return;
  }

  // ✅ NORMAL TRACKING
  totalDistance += d;
  debugPrint('Δ distance: $d m | Total: $totalDistance m');

  _lastPosition = position;
  notifyListeners();
}






  int _calculateAverageHr() {
  if (_hrSamples.isEmpty) return 0;

  final sum = _hrSamples.reduce((a, b) => a + b);
  return (sum / _hrSamples.length).round();
}

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }

    if (permission == LocationPermission.deniedForever) return false;
    return true;
  }

void startRun(String uuid) {
  _runStartTime = DateTime.now(); // ⭐⭐ DEN MANGLEDE

  _hrSamples.clear();
  totalDistance = 0.0;
  _lastPosition = null;

  _stopwatch
    ..reset()
    ..start();

  _timer?.cancel();
  _timer = Timer.periodic(const Duration(seconds: 1), (_) {
    notifyListeners();
  });

  sensorData.start(uuid);
  _startGPSTracking();
}


Future<void> stopRun() async {
  _stopwatch.stop();
  _timer?.cancel();
  sensorData.stop();
  _stopGPSTracking();

  final avgHr = _calculateAverageHr(); // ⭐

  final storage = RunStorage();
  await storage.init();

  await storage.addRun(
    elapsedSeconds: _stopwatch.elapsed.inSeconds,
    averageHr: avgHr,              
    distanceMeters: totalDistance,
    zone: selectedZone,
  );

  notifyListeners();
}

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    _hrSub?.cancel();
    sensorData.dispose();
    _stopGPSTracking();
    super.dispose();
  }
}

