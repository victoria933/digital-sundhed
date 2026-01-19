
class StartRunViewModel {
  // Liste over zoner
  final List<String> zones = [
    'Zone 1 ',
    'Zone 2 ',
    'Zone 3 ',
    'Zone 4 ',
    'Zone 5 ',
  ];

  // Holder styr på hvilken zone der er valgt
  int? selectedZoneIndex;

  // Sæt valgt zone
  void selectZone(int index) {
    selectedZoneIndex = index;
  }

  // Returner navnet på valgt zone
  String? get selectedZone =>
      selectedZoneIndex != null ? zones[selectedZoneIndex!] : null;

  // Start run 
  void startRun() {
    if (selectedZone != null) {
      print('Starter løb i: $selectedZone');
      // Her kan du fx starte GPS-tracking eller timer
    }
  }
}
