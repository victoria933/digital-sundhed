import '../model/run_session.dart';

class DetailsViewModel {
  RunSummary getLatestRun() {
    // Her kan du hente fra sensor, database eller mock
    return RunSummary(
      zoneOverview: "Zone 3",
      pulse: 142,
      distance: 6.4,
      time: const Duration(minutes: 31),
    );
  }
}
