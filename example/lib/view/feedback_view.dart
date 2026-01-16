import 'package:flutter/material.dart';
import '../view_model/feedback_view_model.dart';
import '../model/sensor_data.dart';

class FeedbackView extends StatefulWidget {
  final int selectedZone; // 1-5

  const FeedbackView({super.key, required this.selectedZone});

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  late final FeedbackViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = FeedbackViewModel(SensorData(), widget.selectedZone);
    viewModel.startRun();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RunFeedback>(
      stream: viewModel.feedbackStream,
      builder: (context, snapshot) {
        final feedback = snapshot.data ?? RunFeedback.keepPace;

        // 🔴 Sæt farve, ikon og tekst baseret på feedback
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
            color = Colors.blue;
            icon = Icons.trending_down;
            break;
          case RunFeedback.keepPace:
          default:
            text = 'Hold tempo';
            color = Colors.green;
            icon = Icons.check_circle;
        }

        return Scaffold(
          // Farvet baggrund
          backgroundColor: color,
       
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 170),
                // 🔴 Live puls, tid og distance
                StreamBuilder<int>(
                  stream: viewModel.heartRateStream,
                  builder: (context, hrSnapshot) {
                    final hr = hrSnapshot.data ?? 0;
                    return Text('Pulse: $hr bpm',
                        style: const TextStyle(fontSize: 20, color: Colors.white));
                  },
                ),
                StreamBuilder<Duration>(
                  stream: viewModel.timeStream,
                  builder: (context, timeSnapshot) {
                    final duration = timeSnapshot.data ?? Duration.zero;
                    String twoDigits(int n) => n.toString().padLeft(2, '0');
                    final formatted =
                        "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds % 60)}";
                    return Text('Time: $formatted',
                        style: const TextStyle(fontSize: 20, color: Colors.white));
                  },
                ),
                StreamBuilder<double>(
                  stream: viewModel.distanceStream,
                  builder: (context, distanceSnapshot) {
                    final distance = distanceSnapshot.data ?? 0.0;
                    return Text('Distance: ${distance.toStringAsFixed(2)} km',
                        style: const TextStyle(fontSize: 20, color: Colors.white));
                  },
                ),
              

                // 🔴 Feedback ikon og tekst
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

                // 🔴 Stop-knap
                ElevatedButton(
                  onPressed: () {
                    viewModel.stopRun();
                    Navigator.pushNamed(context, '/history');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
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




