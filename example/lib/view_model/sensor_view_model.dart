import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class SensorViewModel {
  final FlutterReactiveBle ble = FlutterReactiveBle();
  late DiscoveredDevice moveSenseDevice;
  bool isConnected = false;

  void scanForMoveSense(Function(String id) onFound) {
    ble.scanForDevices(withServices: []).listen((device) {
      if (device.name.contains("MoveSense")) {
        moveSenseDevice = device;
        onFound(device.id); // fx vis ID i UI
      }
    });
  }

  void connectToMoveSense(Function(bool success) onConnected) {
    ble.connectToDevice(id: moveSenseDevice.id).listen((connectionState) {
      if (connectionState.connectionState == DeviceConnectionState.connected) {
        isConnected = true;
        onConnected(true);
      }
    });
  }
}
