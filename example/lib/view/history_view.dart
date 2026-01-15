import 'package:flutter/material.dart';
import '../viewmodels/history_viewmodel.dart';

class HistoryView extends StatelessWidget {
  final HistoryViewModel viewModel = HistoryViewModel();

  @override
  Widget build(BuildContext context) {
    final history = viewModel.getHistory();

    return Scaffold(
      appBar: AppBar(title: Text('Historik')),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final run = history[index];
          return ListTile(
            title: Text('${run.date.day}/${run.date.month}'),
            subtitle: Text(
              'Tid: ${run.duration.inMinutes} min – Distance: ${run.distance} km – Zone: ${run.zone}',
            ),
          );
        },
      ),
    );
  }
}

