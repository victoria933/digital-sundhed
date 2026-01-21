import 'package:flutter/material.dart';
import '../view_model/feedback_view_model.dart';
import '../model/sensor_data.dart';

class FeedbackView extends StatefulWidget {
  final int selectedZone;   // Valgt pulszone
  final String sensorUuid; // Movesense sensor-ID
  final int age;          // Brugerens alder

  const FeedbackView({
    super.key,
    required this.selectedZone,
    required this.sensorUuid,
    required this.age, 
  });

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  late final FeedbackViewModel viewModel;

  @override
  void initState() {
    super.initState();

    // Opret ViewModel 
    viewModel = FeedbackViewModel(
      sensorData: SensorData(),
      selectedZone: widget.selectedZone,
      age: widget.age,
    );
    viewModel.startRun(widget.sensorUuid); // start HR-stream + GPS
  }

  @override
  void dispose() {
    // Stop alt når view lukkes
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel, // UI opdateres når ViewModel ændrer sig
      builder: (context, _) {
        final feedback = viewModel.currentFeedback;
        final hr = viewModel.currentHr;
        final elapsed = viewModel.elapsed;
        final distance = viewModel.totalDistance; 

// Bestem tekst, farve og ikon ud fra feedback
        String text;
        Color color;
        IconData icon;

        switch (feedback) {
          case RunFeedback.speedUp:
            text = 'Speed up';
            color = const Color.fromARGB(255, 238, 96, 200);
            icon = Icons.trending_up;
            break;
          case RunFeedback.slowDown:
            text = 'Løb langsommere';
            color = const Color.fromARGB(255, 23, 110, 241);
            icon = Icons.trending_down;
            break;
          case RunFeedback.keepPace:
          default:
            text = 'Hold tempo';
            color = Colors.green;
            icon = Icons.check_circle;
        }

        return Scaffold(
          backgroundColor: color,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Tid
                Text(
                  formatDuration(elapsed),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // Puls
                Text(
                  'Pulse: $hr bpm',
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),

                const SizedBox(height: 10),

                // Distance
                Text(
                  'Distance: ${distance.toStringAsFixed(1)} m',
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),

                const SizedBox(height: 30),

                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, size: 100, color: Colors.white),
                        const SizedBox(height: 16),
                        Text(
                          text,
                          style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
  onPressed: () async {
    // 🔹 Vent på at run er stoppet og gemt
    await viewModel.stopRun();

    // 🔹 Naviger først efter gemning
    Navigator.pushReplacementNamed(context, '/history');
  },
  style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
    backgroundColor: Colors.black.withOpacity(0.7),
  ),
  child: const Text(
    'Stop Run',
    style: TextStyle(fontSize: 20, color: Colors.white),
  ),
)

              ],
            ),
          ),
        );
      },
    );
  }

  // Formatterer tid til mm:ss
  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
