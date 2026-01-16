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
      appBar: AppBar(title: const Text("Sensor")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.bluetooth, size: 48),
            const SizedBox(height: 20),

            TextField(
              controller: idController,
              decoration: const InputDecoration(
                labelText: "Sensor UUID",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Live status med ValueListenableBuilder
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

            ElevatedButton.icon(
              icon: const Icon(Icons.bluetooth_connected),
              label: const Text("Connect"),
              onPressed: () {
                final uuid = idController.text.trim();
                if (uuid.isEmpty) return;

                viewModel.connectById(uuid, (success) {
                  // Callback bruges stadig hvis du vil lave popup eller toast
                });
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/sensor');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/history');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sensors),
            label: 'Sensor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Historik',
          ),
        ],
      ),
    );
  }
}

