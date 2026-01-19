import 'package:flutter/material.dart';
import '../view_model/start_run_view_model.dart';
import '../view_model/sensor_view_model.dart';


class StartRunView extends StatefulWidget {
  const StartRunView({super.key});

  @override
  State<StartRunView> createState() => _StartRunViewState();
}

class _StartRunViewState extends State<StartRunView> {
  final StartRunViewModel viewModel = StartRunViewModel();
  final SensorViewModel sensorViewModel = SensorViewModel(); // 🔹 Singleton
  int age = 30; // default

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args != null && args['age'] != null) {
      age = args['age'];
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Run'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Vælg din løbezone:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Liste med radio-knapper for zoner
            Expanded(
              child: ListView.builder(
                itemCount: viewModel.zones.length,
                itemBuilder: (context, index) {
                  return RadioListTile<int>(
                    title: Text(viewModel.zones[index]),
                    value: index,
                    groupValue: viewModel.selectedZoneIndex,
                    onChanged: (value) {
                      setState(() {
                        viewModel.selectZone(value!);
                      });
                    },
                  );
                },
              ),
            ),

            // Start Run-knap
ElevatedButton(
  onPressed: viewModel.selectedZoneIndex != null
      ? () {
          final uuid = sensorViewModel.uuid; 
          if (uuid == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Scan og connect til Movesense først')),
            );
            return;
          }

          viewModel.startRun();
          Navigator.pushNamed(
            context,
            '/feedback',
            arguments: {
              'selectedZone': viewModel.selectedZoneIndex! + 1,
              'sensorUuid': uuid,
              'age': age, // 🔹 nu med alder
            },
          );
        }
      : null,
  child: const Text('Start Run'),
),



          ],
        ),
      ),
    );
  }
}


