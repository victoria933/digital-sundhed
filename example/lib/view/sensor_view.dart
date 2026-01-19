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
        toolbarHeight: 100,
      ),
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

            //Status baseret på SensorState
            ValueListenableBuilder<SensorState>(
              valueListenable: viewModel.stateNotifier,
              builder: (context, state, _) {
                String text;
                Color color;

                switch (state) {
                  case SensorState.scanning:
                    text = "Scanner...";
                    color = Colors.blue;
                    break;
                  case SensorState.connecting:
                    text = "Forbinder...";
                    color = Colors.orange;
                    break;
                  case SensorState.connected:
                    text = "Forbundet";
                    color = Colors.green;
                    break;
                  case SensorState.disconnected:
                    text = "Afbrudt";
                    color = Colors.grey;
                    break;
                  case SensorState.error:
                    text = "Fejl";
                    color = Colors.red;
                    break;
                  default:
                    text = "Idle";
                    color = Colors.black;
                }

                return Text(
                  "Status: $text",
                  style: TextStyle(fontSize: 18, color: color),
                );
              },
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Scan-knap
                ElevatedButton.icon(
                  icon: const Icon(Icons.search),
                  label: const Text("Scan"),
                  onPressed: () {
                    viewModel.scan((uuid) {
                      setState(() {
                        idController.text = uuid;
                      });
                    });
                  },
                ),

                //Connect / Disconnect-knap
                ValueListenableBuilder<SensorState>(
                  valueListenable: viewModel.stateNotifier,
                  builder: (context, state, _) {
                    final isConnected = state == SensorState.connected;

                    return ElevatedButton.icon(
                      icon: Icon(
                        isConnected
                            ? Icons.bluetooth_disabled
                            : Icons.bluetooth_connected,
                      ),
                      label: Text(isConnected ? "Disconnect" : "Connect"),
                      onPressed: () {
                        final uuid = idController.text.trim();
                        if (isConnected) {
                          viewModel.disconnect();
                        } else if (uuid.isNotEmpty) {
                          viewModel.connectById(uuid);
                        }
                      },
                    );
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



