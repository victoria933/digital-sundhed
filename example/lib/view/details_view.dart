import 'package:flutter/material.dart';
import '../model/run_history.dart';

class DetailsView extends StatelessWidget {
  const DetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Hent den valgte run fra arguments
    final run = ModalRoute.of(context)!.settings.arguments as RunHistory;

    return Scaffold(
      appBar: AppBar(title: const Text("Løbsoversigt")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Dato
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 28),
                const SizedBox(width: 12),
                Text("Dato: ${run.date.day}/${run.date.month}/${run.date.year}", style: const TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 16),

            // Zone
            Row(
              children: [
                const Icon(Icons.show_chart, size: 28),
                const SizedBox(width: 12),
                Text("Zone: ${run.zone}", style: const TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 16),

            // Distance
            Row(
              children: [
                const Icon(Icons.location_on, size: 28),
                const SizedBox(width: 12),
                Text("Distance: ${run.distance.toStringAsFixed(2)} km", style: const TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 16),

            // Tid
            Row(
              children: [
                const Icon(Icons.timer, size: 28),
                const SizedBox(width: 12),
                Text("Tid: ${run.duration.inMinutes} min", style: const TextStyle(fontSize: 18)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
