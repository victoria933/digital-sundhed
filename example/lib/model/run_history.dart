///  Et løb med dato, varighed, distance og valgt zone.
class RunHistory {
  // Dato og tidspunkt for løbet.
  final DateTime date;

// Varighed af løbet.
  final Duration duration;

  // Distance løbet i meter.
  final double distance;

  // Valgt pulszone (1–5).
  final int zone;

  RunHistory({
    required this.date,
    required this.duration,
    required this.distance,
    required this.zone,
  });
}
