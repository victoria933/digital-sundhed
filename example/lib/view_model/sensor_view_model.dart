import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class SensorViewModel {
  final FlutterReactiveBle ble = FlutterReactiveBle();
  DiscoveredDevice? moveSenseDevice;
  bool isConnected = false;

  void scan(Function(String id) onFound) {
    ble.scanForDevices(withServices: []).listen((device) {
      if (device.name.contains("Movesense")) {
        moveSenseDevice = device;
        onFound(device.id);
      }
    });
  }

  void connect(Function(bool success) onConnected) {
    if (moveSenseDevice == null) return;

    ble.connectToDevice(id: moveSenseDevice!.id).listen((connectionState) {
      if (connectionState.connectionState == DeviceConnectionState.connected) {
        isConnected = true;
        onConnected(true);
      }
    });
  }
}

