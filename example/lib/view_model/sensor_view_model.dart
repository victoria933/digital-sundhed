import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'dart:async'; 

enum SensorState {
  idle,
  scanning,
  connecting,
  connected,
  disconnected,
  error,
}


class SensorViewModel {
  // 🔹 Singleton
  static final SensorViewModel _instance = SensorViewModel._internal();
  factory SensorViewModel() => _instance;
  SensorViewModel._internal();

  final FlutterReactiveBle ble = FlutterReactiveBle();
  DiscoveredDevice? moveSenseDevice;

  // 🔹 STATE
  final ValueNotifier<SensorState> stateNotifier =
      ValueNotifier(SensorState.idle);

  // 🔹 Scan efter Movesense
void scan(Function(String uuid) onFound) {
  stateNotifier.value = SensorState.scanning;

  // Gem subscription, så vi kan stoppe scanningen
  late StreamSubscription subscription;
  subscription = ble.scanForDevices(withServices: []).listen((device) {
    if (device.name.contains("Movesense")) {
      moveSenseDevice = device;
      onFound(device.id);          // fylder UUID i UI
      stateNotifier.value = SensorState.idle;
      
      // Stop scanningen efter første Movesense
      subscription.cancel();
    }
  }, onError: (_) {
    stateNotifier.value = SensorState.error;
  });
}


  // 🔹 Connect via UUID
  void connectById(String id) {
    stateNotifier.value = SensorState.connecting;

    ble.connectToDevice(id: id).listen((connectionState) {
      if (connectionState.connectionState ==
          DeviceConnectionState.connected) {
        stateNotifier.value = SensorState.connected;
      } else if (connectionState.connectionState ==
          DeviceConnectionState.disconnected) {
        stateNotifier.value = SensorState.disconnected;
      }
    }, onError: (_) {
      stateNotifier.value = SensorState.error;
    });
  }

  void disconnect() {
    stateNotifier.value = SensorState.disconnected;
  }

  String? get uuid => moveSenseDevice?.id;
}

