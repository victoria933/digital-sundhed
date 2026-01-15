import 'package:flutter/material.dart';
import '../view_model/details_view_model.dart';

class DetailsView extends StatelessWidget {
  final viewModel = DetailsViewModel();

  DetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final run = viewModel.getLatestRun();

    return Scaffold(
      appBar: AppBar(title: const Text("Løbsoversigt")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.show_chart, size: 28),
                const SizedBox(width: 12),
                Text("Zone oversigt: ${run.zoneOverview}", style: const TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.favorite, size: 28),
                const SizedBox(width: 12),
                Text("Puls: ${run.pulse} bpm", style: const TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.location_on, size: 28),
                const SizedBox(width: 12),
                Text("Distance: ${run.distance} km", style: const TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.timer, size: 28),
                const SizedBox(width: 12),
                Text("Tid: ${run.time.inMinutes} min", style: const TextStyle(fontSize: 18)),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(Icons.signal_cellular_alt, size: 28),
                Icon(Icons.menu, size: 28),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
