import 'package:flutter/material.dart';
import '../view_model/sensor_view_model.dart';
import 'feedback_view.dart';

class SensorView extends StatefulWidget {
  const SensorView({super.key, required this.selectedZone});

  final int selectedZone;

  @override
  State<SensorView> createState() => _SensorViewState();
}

class _SensorViewState extends State<SensorView> {
  final zoneVM = ZoneViewModel();

  // Simuleret sensorværdi (du erstatter med rigtig sensor)
  int sensorValue = 0;

  void onSensorValue(int value) {
    int scenario = zoneVM.evaluateSensor(widget.selectedZone, value);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FeedbackView(scenario: scenario),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sensor")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Sensorværdi: $sensorValue"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                sensorValue = 75; // testværdi
                onSensorValue(sensorValue);
              },
              child: const Text("Test sensor"),
            ),
          ],
        ),
      ),
    );
  }
}
