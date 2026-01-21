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
  final SensorViewModel sensorViewModel = SensorViewModel(); // Singleton
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
        backgroundColor: Colors.orangeAccent,
        title: const Text(
          'Start løb',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
        child: Column(
          children: [
            const Text(
              'Vælg din løbezone:',
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 40),

            // Liste med radio-knapper for zoner
            Expanded(
              child: ListView.builder(
                itemCount: viewModel.zones.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: Row(
                      mainAxisSize:
                          MainAxisSize.min, // gør rækken så lille som muligt
                      children: [
                        Radio<int>(
                          value: index,
                          groupValue: viewModel.selectedZoneIndex,
                          onChanged: (value) {
                            setState(() {
                              viewModel.selectZone(value!);
                            });
                          },
                        ),
                        Text(
                          viewModel.zones[index],
                          style: const TextStyle(
                            fontSize: 22, // større tekst
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Start Run-knap
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ), // gør knappen større
                backgroundColor:
                    const Color.fromARGB(255, 249, 198, 132), // knapfarve
                foregroundColor: Colors.black, // tekstfarve (sort)
                textStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: viewModel.selectedZoneIndex != null
                  ? () {
                      final uuid = sensorViewModel.uuid;
                      if (uuid == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Scan og connect til Movesense først'),
                          ),
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
                          'age': age,
                        },
                      );
                    }
                  : null,
              child: const Text('Start løb'),
            )
          ],
        ),
      ),
    );
  }
}
