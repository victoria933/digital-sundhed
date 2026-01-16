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

           


            const SizedBox(height: 20),
          ],
        ),
        
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          // index 0 = Sensor, index 1 = Historik
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
