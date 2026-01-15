import 'package:flutter/material.dart';
import '../view_model/feedback_view_model.dart';
import '../model/sensor_data.dart';

class FeedbackView extends StatefulWidget {
  const FeedbackView({super.key});

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  late final FeedbackViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = FeedbackViewModel(SensorData());
    viewModel.startRun();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Feedback')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Heart Rate', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 16),

          StreamBuilder<int>(
            stream: viewModel.heartRateStream,
            builder: (context, snapshot) {
              final hr = snapshot.data ?? 0;
              return Text(
                '$hr bpm',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),

          const SizedBox(height: 40),

          ElevatedButton(
            onPressed: () {
              viewModel.stopRun(); // 🔴 stop sensor
              Navigator.pop(context);
            },
            child: const Text('Stop Run'),
          ),
        ],
      ),
    );
  }
}
