import '../model/sensor_data.dart';

class ZoneViewModel {
  // Pulsbaserede zoner (kan ændres til tempo/watt)
  final List<ZoneRange> zones = [
    ZoneRange(zone: 1, min: 50, max: 60),
    ZoneRange(zone: 2, min: 60, max: 70),
    ZoneRange(zone: 3, min: 70, max: 80),
    ZoneRange(zone: 4, min: 80, max: 90),
    ZoneRange(zone: 5, min: 90, max: 100),
  ];

  /// Returnerer 1, 2 eller 3 → scenarie
  int evaluateSensor(int selectedZone, int currentValue) {
    final zone = zones.firstWhere((z) => z.zone == selectedZone);

    if (currentValue < zone.min) {
      return 1; // Øg tempo (rød)
    } else if (currentValue > zone.max) {
      return 3; // Sænk tempo (blå)
    } else {
      return 2; // YAY (grøn)
    }
  }
}
