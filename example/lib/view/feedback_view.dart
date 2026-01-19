import 'package:flutter/material.dart';
import '../view_model/feedback_view_model.dart';
import '../model/sensor_data.dart';

class FeedbackView extends StatefulWidget {
  final int selectedZone;
  final String sensorUuid; // UUID på Movesense
  final int age; // Tilføj alder

  const FeedbackView({
    super.key,
    required this.selectedZone,
    required this.sensorUuid,
    required this.age, // obligatorisk parameter
  });

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  late final FeedbackViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = FeedbackViewModel(
      sensorData: SensorData(),
      selectedZone: widget.selectedZone,
      age: 30, // fx din alder
      restingHr: 60,
    );
    viewModel.startRun(widget.sensorUuid); // start HR-stream
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) {
        final feedback = viewModel.currentFeedback;
        final hr = viewModel.currentHr;

        String text;
        Color color;
        IconData icon;

        switch (feedback) {
          case RunFeedback.speedUp:
            text = 'Speed up';
            color = Colors.orange;
            icon = Icons.trending_up;
            break;
          case RunFeedback.slowDown:
            text = 'Løb langsommere';
            color = Colors.red;
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
                Text(
                  'Pulse: $hr bpm',
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
                  onPressed: () {
                    viewModel.stopRun();
                    Navigator.pushNamed(context, '/history');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    backgroundColor: Colors.black.withOpacity(0.7),
                  ),
                  child: const Text(
                    'Stop Run',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}





