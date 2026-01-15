import 'package:flutter/material.dart';

class FeedbackView extends StatelessWidget {
  final int scenario;

  const FeedbackView({super.key, required this.scenario});

  @override
  Widget build(BuildContext context) {
    late String message;
    late Color color;

    switch (scenario) {
      case 1:
        message = "Øg tempo!";
        color = Colors.red;
        break;
      case 2:
        message = "YAY!";
        color = Colors.green;
        break;
      case 3:
        message = "Sænk tempo!";
        color = Colors.blue;
        break;
      default:
        message = "Ukendt";
        color = Colors.grey;
    }

    return Scaffold(
      backgroundColor: color,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message, style: const TextStyle(fontSize: 32, color: Colors.white)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: const Text("Stop løb"),
            )
          ],
        ),
      ),
    );
  }
}
