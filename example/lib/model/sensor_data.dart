import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class SensorData {
  final FlutterReactiveBle ble = FlutterReactiveBle();

  final StreamController<int> _hrController = StreamController<int>.broadcast();
  Stream<int> get hrStream => _hrController.stream;

  StreamSubscription<List<int>>? _hrSub;
  QualifiedCharacteristic? _hrChar;

  // Start puls streaming fra Movesense
  void start(String uuid) {
    _hrChar = QualifiedCharacteristic(
      deviceId: uuid,                // UUID fra SensorView
      serviceId: Uuid.parse("180D"), // Heart Rate Service
      characteristicId: Uuid.parse("2A37"), // Heart Rate Measurement
    );

    _hrSub = ble.subscribeToCharacteristic(_hrChar!).listen((data) {
      if (data.isNotEmpty) {
        int hrValue = data[1]; // simplificeret parsing af HR
        _hrController.add(hrValue);
      }
    }, onError: (err) {
      print("HR stream error: $err");
    });
  }

  void stop() {
    _hrSub?.cancel();
    _hrSub = null;
  }

  void dispose() {
    _hrSub?.cancel();
    _hrController.close();
  }
}



