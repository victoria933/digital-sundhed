import 'package:flutter/material.dart';
import '../view_model/start_run_view_model.dart';

class StartRunView extends StatefulWidget {
  const StartRunView({super.key});

  @override
  State<StartRunView> createState() => _StartRunViewState();
}

class _StartRunViewState extends State<StartRunView> {
  final StartRunViewModel viewModel = StartRunViewModel();

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
                      viewModel.startRun();
                      // Naviger evt. til løbetracking side
                    }
                  : null, // deaktiveret hvis ingen zone valgt
              child: const Text('Start Run'),
            ),
          ],
        ),
      ),
    );
  }
}


