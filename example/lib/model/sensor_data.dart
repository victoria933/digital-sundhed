import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

/// Henter pulsdata fra Movesense-sensoren og sender dem videre som en stream.
class SensorData {
  // BLE, til at forbinde til sensoren.
  final FlutterReactiveBle ble = FlutterReactiveBle();

  // Sender pulsdata ud til resten af appen.
  final StreamController<int> _hrController = StreamController<int>.broadcast();

  // Stream med puls
  Stream<int> get hrStream => _hrController.stream;

  StreamSubscription<List<int>>? _hrSub;
  QualifiedCharacteristic? _hrChar;

  // Start puls streaming fra Movesense
  void start(String uuid) {
    _hrChar = QualifiedCharacteristic(
      deviceId: uuid, // Sensorens ID
      serviceId: Uuid.parse("180D"),
      characteristicId: Uuid.parse("2A37"),
    );

// Lyt efter pulsdata
    _hrSub = ble.subscribeToCharacteristic(_hrChar!).listen((data) {
      if (data.isNotEmpty) {
        int hrValue = data[1]; // simplificeret parsing af HR
        _hrController.add(hrValue);
      }
    }, onError: (err) {
      print("HR stream error: $err");
    });
  }

// Stopper puls-streaming.
  void stop() {
    _hrSub?.cancel();
    _hrSub = null;
  }

  // Rydder ressourcer.
  void dispose() {
    _hrSub?.cancel();
    _hrController.close();
  }
}
