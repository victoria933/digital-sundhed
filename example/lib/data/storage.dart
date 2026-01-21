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
  final StoreRef<int, Map<String, dynamic>> _store =
      intMapStoreFactory.store('runs');

  bool _initialized = false;

  /// Initialiserer databasen (SKAL kaldes én gang)
  Future<void> init() async {
    if (_initialized) return;

    final dir = await getApplicationDocumentsDirectory();
    final dbPath = join(dir.path, 'runs.db');

    _database = await databaseFactoryIo.openDatabase(dbPath);

    _initialized = true;
  }

  /// Gemmer ét run i databasen (JSON på disk)
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

  /// Henter alle runs (sorteret efter tid)
  Future<List<Map<String, dynamic>>> getAllRuns() async {
    final snapshots = await _store.find(
      _database,
      finder: Finder(
        sortOrders: [SortOrder('timestamp')],
      ),
    );

    return snapshots.map((s) => s.value).toList();
  }

  /// Henter seneste run
  Future<Map<String, dynamic>?> getLatestRun() async {
    final snapshots = await _store.find(
      _database,
      finder: Finder(
        sortOrders: [SortOrder('timestamp', false)],
        limit: 1,
      ),
    );

    if (snapshots.isEmpty) return null;
    return snapshots.first.value;
  }

  /// Eksporterer ALLE runs som JSON-string
  Future<String> exportRunsAsJson() async {
    final runs = await getAllRuns();
    return jsonEncode(runs);
  }

  /// Sletter alle runs (til test)
  Future<void> clearAll() async {
    await _store.delete(_database);
  }
}


