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

      // BottomNavigationBar med to knapper
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          // index 0 = Sensor, index 1 = Historik
          if (index == 0) {
            Navigator.pushNamed(context, '/sensor');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/history');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sensors),
            label: 'Sensor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Historik',
          ),
        ],
      ),
    );
  }
}

