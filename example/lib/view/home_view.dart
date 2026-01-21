import 'package:flutter/material.dart';
import '../view_model/sensor_view_model.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final SensorViewModel sensorViewModel = SensorViewModel();
  final TextEditingController ageController = TextEditingController();

// Tjekker om alderen er gyldig
  bool get isAgeValid {
    final text = ageController.text;
    final age = int.tryParse(text);
    return age != null && age > 0 && age <= 120;
  }

// Fejlbesked til alder-feltet
  String? get ageError {
    final text = ageController.text;
    if (text.isEmpty) return 'Indtast din alder';
    final age = int.tryParse(text);
    if (age == null || age <= 0 || age > 120) return 'Alder skal være mellem 1 og 120';
    return null;
  }

  @override
  void dispose() {
    ageController.dispose();
    super.dispose();
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: true, //  Flyt UI når keyboard åbner
    appBar: AppBar(
      backgroundColor: Colors.orangeAccent,
      centerTitle: true,
      toolbarHeight: 120,
      title: const Text(
        'ZoneLøb',
        style: TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    body: GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), //  Skjul keyboard ved tap
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            
            // Bluetooth status
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ValueListenableBuilder<SensorState>(
                    valueListenable: sensorViewModel.stateNotifier,
                    builder: (context, state, _) {
                      final isConnected = state == SensorState.connected;
                      return Icon(
                        isConnected
                            ? Icons.bluetooth_connected
                            : Icons.bluetooth_disabled,
                        color: isConnected ? Colors.green : Colors.red,
                        size: 60,
                      );
                    },
                  ),
                ],
              ),
            ),

            

            const SizedBox(height: 45),
// Info-tekst om alder
      const Text(
        'Alder kræves for at beregne dine pulszoner',
        style: TextStyle(
          fontSize: 14,
          color: Color.fromARGB(255, 7, 0, 0),
        ),
      ),


                  const SizedBox(height: 20),

              // Alders-input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Indtast din alder',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) {
                        setState(() {}); // Opdater knap-status
                      },
                    ),
                    // Fejlbesked hvis alder er ugyldig
                    if (ageError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          ageError!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),

            const SizedBox(height: 70),

            // Knap til at forbinde sensor
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.sensors, size: 28),
                label: const Text(
                  'Forbind sensor',
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: const Color.fromARGB(255, 255, 204, 137),
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/sensor');
                },
              ),
            ),

            const SizedBox(height: 20),

              // Start løb-knap
              ElevatedButton.icon(
                icon: const Icon(Icons.directions_run, size: 28),
                label: const Text(
                  'Start Run',
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: isAgeValid
                      ? const Color.fromARGB(255, 255, 204, 137)
                      : Colors.grey,
                  foregroundColor: Colors.black,
                ),
                onPressed: isAgeValid
                    ? () {
                        final age = int.parse(ageController.text);
                        Navigator.pushNamed(
                          context,
                          '/start-run',
                          arguments: {'age': age},
                        );
                      }
                    : null, // Deaktiveret hvis alder er ugyldig
              ),

            const SizedBox(height: 90),

            // Historik-knap
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Center(
                child: ElevatedButton.icon(
                  label: const Text(
                    'Historik',
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: const Color.fromARGB(255, 255, 204, 137),
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/history');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}