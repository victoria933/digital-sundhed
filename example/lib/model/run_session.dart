/// Afsluttet løb med opsummerede data.
class RunSession {
  final String zoneOverview;

  // Gennemsnitlig puls for løbet.
  final int pulse;

  // Distance løbet i meter.
  final double distance;

  // Den samlede tid for løbet.
  final Duration time;

  RunSession({
    required this.zoneOverview,
    required this.pulse,
    required this.distance,
    required this.time,
  });
}
