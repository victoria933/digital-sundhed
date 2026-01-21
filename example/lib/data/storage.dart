import 'dart:convert';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class RunStorage {
  // Singleton
  static final RunStorage _instance = RunStorage._internal();
  factory RunStorage() => _instance;
  RunStorage._internal();

  late final Database _database;

  // Store til runs
  final StoreRef<int, Map<String, dynamic>> _store =
      intMapStoreFactory.store('runs');

  // Puls store: hvert pulsslag gemmes som {runId, timestamp, hr}
  final StoreRef<int, Map<String, dynamic>> _pulseStore =
      intMapStoreFactory.store('pulses');

  bool _initialized = false;

  // Initialiserer databasen (skal kaldes én gang)
  Future<void> init() async {
    if (_initialized) return;
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = join(dir.path, 'runs.db');
    _database = await databaseFactoryIo.openDatabase(dbPath);
    _initialized = true;
  }

  // Gemmer ét run i databasen og returnerer runId
  Future<int> addRun({
    required int elapsedSeconds,
    required int averageHr,
    required double distanceMeters,
    required int zone,
  }) async {
    final data = {
      'elapsed': elapsedSeconds,
      'averageHr': averageHr,
      'distance': distanceMeters,
      'zone': zone,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    return await _store.add(_database, data);
  }

  // Hent et specifikt run ud fra runId
  Future<Map<String, dynamic>?> getRun(int runId) async {
    final record = await _store.record(runId).get(_database);
    return record; // null hvis ikke fundet
  }

  // Opdater run (fx når run stopper)
  Future<void> updateRun(int runId, Map<String, dynamic> newData) async {
    await _store.record(runId).update(_database, newData);
  }

  // Gemmer ét pulsslag som {timestamp, hr} under runId
  Future<int> addPulse(int runId, int hr) async {
    final data = {
      'runId': runId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'hr': hr, // kun timestamp og hr
    };
    return await _pulseStore.add(_database, data);
  }

  // Hent alle pulsslag for et specifikt run
  Future<List<Map<String, dynamic>>> getPulses(int runId) async {
    final snapshots = await _pulseStore.find(
      _database,
      finder: Finder(
        filter: Filter.equals('runId', runId),
        sortOrders: [SortOrder('timestamp')],
      ),
    );
    return snapshots.map((s) => s.value).toList();
  }

  // Hent alle runs (sorteret efter tid)
  Future<List<Map<String, dynamic>>> getAllRuns() async {
    final snapshots = await _store.find(
      _database,
      finder: Finder(sortOrders: [SortOrder('timestamp')]),
    );
    return snapshots.map((s) => s.value).toList();
  }

  // Eksporter pulsslag som JSON (timestamp, hr)
  Future<String> exportPulsesAsJson(int runId) async {
    final pulses = await getPulses(runId);
    return jsonEncode(pulses);
  }
}
