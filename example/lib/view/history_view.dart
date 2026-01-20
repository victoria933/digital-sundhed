import 'package:flutter/material.dart';
import '../view_model/history_view_model.dart';
import 'home_view.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  final HistoryViewModel viewModel = HistoryViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.loadRuns();
    viewModel.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    viewModel.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // 🔹 blokér tilbage-knap
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Historik'),
          automaticallyImplyLeading: false, // 🔹 fjern back-pil
        ),
        body: Column(
          children: [
            Expanded(
              child: viewModel.runs.isEmpty
                  ? const Center(child: Text('Ingen runs endnu'))
                  : ListView.builder(
                      itemCount: viewModel.runs.length,
                      itemBuilder: (context, index) {
                        final run = viewModel.runs[index];
                        final elapsedSec = run['elapsed'] as int;
                        final minutes =
                            (elapsedSec ~/ 60).toString().padLeft(2, '0');
                        final seconds =
                            (elapsedSec % 60).toString().padLeft(2, '0');
                        final distance = run['distance'] as double;
                        final avgHr = run['averageHr'] as int;
                        final zone = run['zone'] as int;

                        final runNumber = viewModel.runs.length - index; 

                        return ListTile(
                          title: Text(
                              '#$runNumber | Distance: ${distance.toStringAsFixed(1)} m | Zone: $zone'),
                          subtitle:
                              Text('Tid: $minutes:$seconds | Puls: $avgHr bpm'),
                        );
                      },
                    ),
            ),

            // 🔹 Home-knap i bunden
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeView()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.home),
                label: const Text('Home'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




