import 'package:flutter/material.dart';
import '../view_model/sensor_view_model.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final SensorViewModel sensorViewModel = SensorViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Column(
        children: [
          // 🔹 Bluetooth-ikon under AppBar, ude til højre
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: sensorViewModel.isConnectedNotifier,
                  builder: (context, isConnected, _) {
                    return Icon(
                      isConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                      color: isConnected ? Colors.green : Colors.red,
                      size: 60,
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 100),

          // 🔹 Sensor-knap
          Center(
  child: ElevatedButton.icon(
    icon: const Icon(Icons.sensors, size: 28), // 🔹 ikonet
    label: const Text(
      'Forbind sensor',
      style: TextStyle(fontSize: 20), // 🔹 større tekst
    ),
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20), // 🔹 gør knappen større
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // 🔹 rundede hjørner
      ),
      backgroundColor: const Color.fromARGB(255, 255, 204, 137),
      foregroundColor: Colors.black, // 🔹 knapfarve
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
                style: TextStyle(fontSize: 20),),
                style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 204, 137),
      foregroundColor: Colors.black,
    ),
    onPressed: () {
      Navigator.pushNamed(context, '/start-run');
    },
  ),
),

const Spacer(),

// History-knap i bunden
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
    );
  }
}

