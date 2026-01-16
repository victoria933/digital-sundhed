import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class SensorViewModel {
  final FlutterReactiveBle ble = FlutterReactiveBle();
  DiscoveredDevice? moveSenseDevice;

  // 🔹 Notifier for live connection status
  final ValueNotifier<bool> isConnectedNotifier = ValueNotifier(false);

  // 🔹 Scan efter Movesense-enheder og returner UUID
  void scan(Function(String uuid) onFound) {
    ble.scanForDevices(withServices: []).listen((device) {
      if (device.name.contains("Movesense")) {
        moveSenseDevice = device;
        onFound(device.id); // fylder UUID i UI
      }
    }, onError: (error) {
      // evt. håndter fejl
      debugPrint('Scan error: $error');
    });
  }

  // 🔹 Connect via UUID
  void connectById(String id, Function(bool success) onConnected) {
    ble.connectToDevice(id: id).listen((connectionState) {
      if (connectionState.connectionState == DeviceConnectionState.connected) {
        isConnectedNotifier.value = true;
        onConnected(true);
      } else if (connectionState.connectionState ==
          DeviceConnectionState.disconnected) {
        isConnectedNotifier.value = false;
        onConnected(false);
      }
    }, onError: (_) {
      isConnectedNotifier.value = false;
      onConnected(false);
    });
  }

  void disconnect() {
    isConnectedNotifier.value = false;
  }
}

