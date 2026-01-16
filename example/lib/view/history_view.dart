import 'package:flutter/material.dart';
import '../view_model/history_view_model.dart';

class HistoryView extends StatelessWidget {
  final HistoryViewModel viewModel = HistoryViewModel();

  @override
  Widget build(BuildContext context) {
    final history = viewModel.getHistory();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historik'),
        automaticallyImplyLeading: false, // fjern tilbage-pil
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            // ===== HEADER =====
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),   // Dato
                1: FlexColumnWidth(2),   // Tid
                2: FlexColumnWidth(2),   // Distance
                3: FlexColumnWidth(1.5), // Zone
                4: FixedColumnWidth(48), // menu
              },
              children: const [
                TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Dato', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Tid', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Distance', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Zone', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(),
                  ],
                ),
              ],
            ),

            const Divider(),

            // ===== DATA =====
            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final run = history[index];

                  return Table(
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(2),
                      3: FlexColumnWidth(1.5),
                      4: FixedColumnWidth(48),
                    },
                    children: [
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text('${run.date.day}/${run.date.month}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text('${run.duration.inMinutes} min'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text('${run.distance.toStringAsFixed(2)} km'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text('${run.zone}'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_horiz),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/details',
                                arguments: run,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),

            // ===== HOME KNAP =====
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false, // fjerner alle tidligere routes
                  );
                },
                icon: const Icon(Icons.home),
                label: const Text('Home'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


