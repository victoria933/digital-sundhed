import 'dart:convert';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class RunStorage {
  static final RunStorage _instance = RunStorage._internal();
  factory RunStorage() => _instance;
  RunStorage._internal();

  late final Database _database;

  // Store til runs
  final StoreRef<int, Map<String, dynamic>> _store = intMapStoreFactory.store('runs');

  // Puls store: hvert pulsslag gemmes som {runId, timestamp, hr}
  final StoreRef<int, Map<String, dynamic>> _pulseStore = intMapStoreFactory.store('pulses');

  bool _initialized = false;

  /// Initialiserer databasen (skal kaldes én gang)
  Future<void> init() async {
    if (_initialized) return;
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = join(dir.path, 'runs.db');
    _database = await databaseFactoryIo.openDatabase(dbPath);
    _initialized = true;
  }

  /// Gemmer ét run i databasen og returnerer runId
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

  /// Gemmer ét pulsslag som {timestamp, hr} under runId
  Future<int> addPulse(int runId, int hr) async {
    final data = {
      'runId': runId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'hr': hr, // ❤️ kun timestamp og hr
    };
    return await _pulseStore.add(_database, data);
  }

  /// Henter alle pulsslag for et run, sorteret efter tid
  Future<List<Map<String, dynamic>>> getPulsesForRun(int runId) async {
    final snapshots = await _pulseStore.find(
      _database,
      finder: Finder(
        filter: Filter.equals('runId', runId),
        sortOrders: [SortOrder('timestamp')],
      ),
    );
    return snapshots.map((s) => s.value).toList();
  }

  /// Henter alle runs (sorteret efter tid)
  Future<List<Map<String, dynamic>>> getAllRuns() async {
    final snapshots = await _store.find(
      _database,
      finder: Finder(sortOrders: [SortOrder('timestamp')]),
    );
    return snapshots.map((s) => s.value).toList();
  }

  /// Opdater run (fx når run stopper)
  Future<void> updateRun(int runId, Map<String, dynamic> newData) async {
    await _store.record(runId).update(_database, newData);
  }

  /// Eksporter pulsslag som JSON (timestamp, hr)
  Future<String> exportPulsesAsJson(int runId) async {
    final pulses = await getPulsesForRun(runId);
    return jsonEncode(pulses);
  }

  /// Sletter alt
  Future<void> clearAll() async {
    await _store.delete(_database);
    await _pulseStore.delete(_database);
  }
}


