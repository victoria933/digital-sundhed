import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../data/storage.dart';

/// Dumper pulsslag for ét run som en enkelt JSON-fil
class DumpManager {
  final RunStorage storage;

  DumpManager(this.storage);

  /// Dump pulsslag for runId til JSON-fil med kun timestamp og hr
  Future<void> dumpPulses(int runId) async {
    await storage.init();

    final pulses = await storage.getPulses(runId);

    if (pulses.isEmpty) {
      print('Ingen pulsslag at dumpe for run $runId');
      return;
    }

    // Behold kun timestamp og hr
    final simplePulses = pulses
        .map((p) => {
              'timestamp': p['timestamp'],
              'hr': p['hr'],
            })
        .toList();

    // Hent documents directory
    final dir = await getApplicationDocumentsDirectory();

    // Lav filnavn med runId og tidspunkt
    final fileName = 'run_${runId}_.json';
    final filePath = join(dir.path, fileName);

    final file = File(filePath);
    await file.writeAsString(jsonEncode(simplePulses));

    print('Pulses dumpet som JSON til: $filePath');
  }
}

