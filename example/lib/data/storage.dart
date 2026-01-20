import 'dart:convert';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_memory.dart';

class RunStorage {
  static final RunStorage _instance = RunStorage._internal();
  factory RunStorage() => _instance;
  RunStorage._internal();

  late final Database _database;
  final StoreRef<int, Map<String, dynamic>> _store = intMapStoreFactory.store('runs');
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _database = await databaseFactoryMemory.openDatabase('runs_memory.db');
    _initialized = true;
  }

  Future<void> addRun({
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
    await _store.add(_database, data);
  }

  Future<List<Map<String, dynamic>>> getRuns() async {
    final snapshots = await _store.find(
      _database,
      finder: Finder(sortOrders: [SortOrder(Field.key)]),
    );
    return snapshots.map((s) => s.value).toList();
  }

  Future<String> exportRunsAsJson() async {
    final runs = await getRuns();
    return json.encode(runs);
  }
}


