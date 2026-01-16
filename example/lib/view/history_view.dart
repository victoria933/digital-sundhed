import 'package:flutter/material.dart';
import '../view_model/history_view_model.dart';

class HistoryView extends StatelessWidget {
  final HistoryViewModel viewModel = HistoryViewModel();

  @override
  Widget build(BuildContext context) {
    final history = viewModel.getHistory();

    return Scaffold(
      appBar: AppBar(title: Text('Historik')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: const [
                Expanded(child: Text('Dato', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('Tid', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('Distance', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('Zone', style: TextStyle(fontWeight: FontWeight.bold))),

                
              ],
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final run = history[index];
                  return Row(
                    children: [
                      Expanded(child: Text('${run.date.day}/${run.date.month}')),
                      Expanded(child: Text('${run.duration.inMinutes} min')),
                      Expanded(child: Text('${run.distance.toStringAsFixed(2)} km')),
                      Expanded(child: Text('${run.zone} zone')),


                      SizedBox(
                          width: 80,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/details',
                                arguments: run, // sender run til DetailsView
                              );
                            },
                            child: const Text('Details', textAlign: TextAlign.center),
                          ),
                        ),

                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

