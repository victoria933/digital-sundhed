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
              decoration: const InputDecoration(
                labelText: "Sensor ID",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Status: $status",
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 30),

            //  CONNECT + SCAN knapper
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.bluetooth_connected),
                  label: const Text("Connect"),
                  onPressed: () {
                    viewModel.connect((success) {
                      setState(() {
                        status = success ? "forbundet" : "fejl";
                      });
                    });
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.search),
                  label: const Text("Scan"),
                  onPressed: () {
                    viewModel.scan((id) {
                      setState(() {
                        idController.text = id;
                      });
                    });
                  },
                ),
              ],
            ),

            const Spacer(),

            // Bund-ikoner (matcher din navigation)
            Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    IconButton(
      icon: const Icon(Icons.signal_cellular_alt, size: 28),
      tooltip: 'Start Run',
      onPressed: () {
        Navigator.pushNamed(context, '/start-run');
      },
    ),
    IconButton(
      icon: const Icon(Icons.menu, size: 28),
      tooltip: 'Historik',
      onPressed: () {
        Navigator.pushNamed(context, '/history');
      },
    ),
  ],
),


            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
