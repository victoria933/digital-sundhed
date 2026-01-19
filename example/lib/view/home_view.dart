import 'package:flutter/material.dart';
import '../view_model/sensor_view_model.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final SensorViewModel sensorViewModel = SensorViewModel();
  final TextEditingController ageController = TextEditingController();

  @override
  void dispose() {
    ageController.dispose();
    super.dispose();
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: true, // ⚡ Flytter body når keyboard vises
    appBar: AppBar(
      backgroundColor: Colors.orangeAccent,
      centerTitle: true,
      toolbarHeight: 120,
      title: const Text(
        'ZoneLøb',
        style: TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    body: GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // ⚡ skjul keyboard når man tapper udenfor
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            // 🔹 Bluetooth status
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ValueListenableBuilder<SensorState>(
                    valueListenable: sensorViewModel.stateNotifier,
                    builder: (context, state, _) {
                      final isConnected = state == SensorState.connected;
                      return Icon(
                        isConnected
                            ? Icons.bluetooth_connected
                            : Icons.bluetooth_disabled,
                        color: isConnected ? Colors.green : Colors.red,
                        size: 60,
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),

            // 🔹 Alders-input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Indtast din alder',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Sensor-knap
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.sensors, size: 28),
                label: const Text(
                  'Forbind sensor',
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: const Color.fromARGB(255, 255, 204, 137),
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/sensor');
                },
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 Start Run-knap
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.directions_run, size: 28),
                label: const Text(
                  'Start Run',
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: const Color.fromARGB(255, 255, 204, 137),
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  final age = int.tryParse(ageController.text) ?? 30;
                  Navigator.pushNamed(
                    context,
                    '/start-run',
                    arguments: {'age': age},
                  );
                },
              ),
            ),

            const SizedBox(height: 40),

            // 🔹 History-knap
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Center(
                child: ElevatedButton.icon(
                  label: const Text(
                    'Historik',
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: const Color.fromARGB(255, 255, 204, 137),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/history');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}