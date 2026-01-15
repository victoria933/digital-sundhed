import 'package:flutter/material.dart';
import '../view_model/sensor_view_model.dart';

class SensorView extends StatefulWidget {
  const SensorView({super.key});

  @override
  State<SensorView> createState() => _SensorViewState();
}

class _SensorViewState extends State<SensorView> {
  final SensorViewModel viewModel = SensorViewModel();
  final TextEditingController idController = TextEditingController();

  String status = "ikke forbundet";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sensor")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.bluetooth, size: 48),
            const SizedBox(height: 20),
            TextField(
              controller: idController,
              decoration: const InputDecoration(labelText: "ID:"),
            ),
            const SizedBox(height: 20),
            Text("Status: $status", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                viewModel.connect((success) {
                  setState(() => status = "forbundet");
                });
              },
              child: const Text("Connect"),
            ),
            ElevatedButton(
              onPressed: () {
                viewModel.scan((id) {
                  idController.text = id;
                  setState(() {});
                });
              },
              child: const Text("Scan"),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(Icons.signal_cellular_alt, size: 28),
                Icon(Icons.menu, size: 28),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
