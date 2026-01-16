import '../model/run_session.dart';

class DetailsViewModel {
  RunSession getLatestRun() {
    // Her kan du hente fra sensor, database eller mock
    return RunSession(
      zoneOverview: "Zone 3",
      pulse: 142,
      distance: 6.4,
      time: const Duration(minutes: 31),
    );
  }
}
