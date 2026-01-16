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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sensor"),
        centerTitle: true,
        toolbarHeight: 100, // 🔹 højere AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.bluetooth, size: 48),
            const SizedBox(height: 20),

            // 🔹 Input til UUID
            TextField(
              controller: idController,
              decoration: const InputDecoration(
                labelText: "Sensor UUID",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Live status
            ValueListenableBuilder<bool>(
              valueListenable: viewModel.isConnectedNotifier,
              builder: (context, isConnected, _) {
                String status = isConnected ? "forbundet" : "ikke forbundet";
                return Text(
                  "Status: $status",
                  style: const TextStyle(fontSize: 18),
                );
              },
            ),
            const SizedBox(height: 30),

            // 🔹 Scan og Connect knapper
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.search, size: 28),
                  label: const Text(
                    "Scan",
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    viewModel.scan((uuid) {
                      setState(() {
                        idController.text = uuid;
                      });
                    });
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.bluetooth_connected, size: 28),
                  label: const Text(
                    "Connect",
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    final uuid = idController.text.trim();
                    if (uuid.isEmpty) return;

                    viewModel.connectById(uuid, (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(success
                              ? "Forbundet!"
                              : "Fejl ved forbindelse"),
                        ),
                      );
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


