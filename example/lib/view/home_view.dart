
import 'package:flutter/material.dart';
import '../view_model/home_view_model.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final HomeViewModel viewModel = HomeViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => viewModel.goToStartRun(context),
          child: const Text('Start Run'),
        ),
      ),
    );
  }
}
