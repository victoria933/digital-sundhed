import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class SensorViewModel {
  final FlutterReactiveBle ble = FlutterReactiveBle();

  // 🔹 Notifier for live connection status
  final ValueNotifier<bool> isConnectedNotifier = ValueNotifier(false);

  void connectById(String id, Function(bool success) onConnected) {
    ble.connectToDevice(id: id).listen((connectionState) {
      if (connectionState.connectionState == DeviceConnectionState.connected) {
        isConnectedNotifier.value = true;
        onConnected(true);
      } else if (connectionState.connectionState ==
          DeviceConnectionState.disconnected) {
        isConnectedNotifier.value = false;
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

