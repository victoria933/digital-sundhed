
import 'package:flutter/material.dart';

class StartRunView extends StatelessWidget {
  const StartRunView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Start Run')),
      body: const Center(
        child: Text('Her starter dit run 🏃‍♂️'),
      ),
    );
  }
}
