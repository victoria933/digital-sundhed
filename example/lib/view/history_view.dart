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
  late final VoidCallback _listener;

  @override
  void initState() {
    super.initState();

    _listener = () {
      if (mounted) setState(() {});
    };

    viewModel.addListener(_listener);
    viewModel.loadRuns();
  }

  @override
  void dispose() {
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
          title: const Text('Historik'),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Expanded(
              child: viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : viewModel.runs.isEmpty
                      ? const Center(child: Text('Ingen runs endnu'))
                      : ListView.builder(
                          itemCount: viewModel.runs.length,
                          itemBuilder: (context, index) {
                            final run = viewModel.runs[index];
                            final elapsed = run['elapsed'] as int;
                            final min =
                                (elapsed ~/ 60).toString().padLeft(2, '0');
                            final sec =
                                (elapsed % 60).toString().padLeft(2, '0');

                            return ListTile(
                              title: Text(
                                'Distance: ${run['distance'].toStringAsFixed(1)} m | Zone ${run['zone']}',
                              ),
                              subtitle: Text(
                                'Tid: $min:$sec | Puls: ${run['averageHr']} bpm',
                              ),
                            );
                          },
                        ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeView()),
                    (_) => false,
                  );
                },
                icon: const Icon(Icons.home),
                label: const Text('Home'),
              ),
            )
          ],
        ),
      ),
    );
  }
}



