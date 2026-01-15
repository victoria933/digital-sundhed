import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ZoneLøb')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/start-run');
          },
          child: const Text('Start Run'),
        ),
      ),

      // BottomAppBar som fod
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: Container(height: 60), // bar uden knapper
      ),

      // FloatingActionButton i nederste højre hjørne
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/history');
        },
        child: const Icon(Icons.menu), // ☰
        tooltip: 'Historik',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
