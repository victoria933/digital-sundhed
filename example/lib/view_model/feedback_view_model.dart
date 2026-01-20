import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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

  // 🔹 GPS / Distance
  Position? _lastPosition;
  double totalDistance = 0.0; // i meter
  StreamSubscription<Position>? _positionStream;

  FeedbackViewModel({
    required this.sensorData,
    required this.selectedZone,
    required this.age,
  }) {
    final maxHr = 220 - age;

    // Zonegrænser som % af maxHR
    zones = List.generate(5, (i) {
      final min = ((50 + i * 10) / 100 * maxHr).round();
      final max = ((50 + (i + 1) * 10) / 100 * maxHr).round();
      return PulseZone(min, max);
    });

    // Lyt til puls
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

  // 🔹 Start GPS tracking
  Future<void> _startGPSTracking() async {
    bool permissionGranted = await _handleLocationPermission();
    if (!permissionGranted) return;

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 1,
      ),
    ).listen((position) {
      _updateDistance(position);
    });
  }

  // 🔹 Stop GPS tracking
  void _stopGPSTracking() {
    _positionStream?.cancel();
    _positionStream = null;
    _lastPosition = null;
    totalDistance = 0.0;
  }

  // 🔹 Beregn distance
  void _updateDistance(Position position) {
    if (_lastPosition != null) {
      totalDistance += Geolocator.distanceBetween(
        _lastPosition!.latitude,
        _lastPosition!.longitude,
        position.latitude,
        position.longitude,
      );
    }
    _lastPosition = position;
    notifyListeners();
  }

  // 🔹 Location permissions
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

  // Start run + GPS
  void startRun(String uuid) {
    _stopwatch
      ..reset()
      ..start();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      notifyListeners();
    });

    sensorData.start(uuid);

    // 🔹 start GPS
    _startGPSTracking();
  }

  void stopRun() {
    _stopwatch.stop();
    _timer?.cancel();
    sensorData.stop();

    // 🔹 stop GPS
    _stopGPSTracking();

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

