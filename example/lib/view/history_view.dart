import 'package:flutter/material.dart';
import 'package:mdsflutter_example/data/storage.dart';
import '../view_model/history_view_model.dart';
import 'home_view.dart';

/// Viser en liste over tidligere løb (tid, puls, distance, zone).
class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  final HistoryViewModel viewModel = HistoryViewModel();
  late final VoidCallback _listener;

  @override
  void initState() {
    super.initState();

// Opdater UI når ViewModel ændrer sig
    _listener = () {
      if (mounted) setState(() {});
    };

    viewModel.addListener(_listener);

    () async {
      await RunStorage().init();

      // Hent alle runs fra databasen
      viewModel.loadRuns();
    }();
  }

  @override
  void dispose() {
    // Fjern lytter og ryd op

    viewModel.removeListener(_listener);
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          automaticallyImplyLeading: false,
          title: const Text(
            'Historik',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : viewModel.runs.isEmpty
                      ? const Center(child: Text('Ingen løb endnu'))
                      : ListView.builder(
                          itemCount: viewModel.runs.length,
                          itemBuilder: (context, index) {
                            final run = viewModel.runs[index];
                            final elapsed = run['elapsed'] as int;
                            final min =
                                (elapsed ~/ 60).toString().padLeft(2, '0');
                            final sec =
                                (elapsed % 60).toString().padLeft(2, '0');

                            // Ældste = #1, nyeste = #N
                            final runNumber = viewModel.runs.length - index;

                            return Card(
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Løbenummer i orange
                                    Text(
                                      'Løb #$runNumber',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        color: Colors.orangeAccent,
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    // Distance og zone
                                    Text(
                                      'Distance: ${run['distance'].toStringAsFixed(1)} meter',
                                      style: const TextStyle(fontSize: 18),
                                    ),

                                    Text(
                                      'Zone: ${run['zone']}',
                                      style: const TextStyle(fontSize: 18),
                                    ),

                                    // Tid og puls
                                    Text(
                                      'Tid: $min:$sec',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      'Gennemsnitspuls: ${run['averageHr']} bpm',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 250, 199, 132), // orange baggrund
                  foregroundColor: Colors.black, // sort tekst + ikon
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ), // større knap
                  textStyle: const TextStyle(
                    fontSize: 22,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeView()),
                    (_) => false,
                  );
                },
                icon: const Icon(Icons.home, size: 28),
                label: const Text('Hjem'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
