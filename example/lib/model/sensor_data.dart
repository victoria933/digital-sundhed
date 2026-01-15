import 'dart:async';

class SensorData {
  final StreamController<int> _hrController =
      StreamController<int>.broadcast();

  Stream<int> get hrStream => _hrController.stream;

  Timer? _timer;

  void start() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final hr = 60 + (timer.tick % 100); // simuleret HR
      _hrController.add(hr);
    });
  }

  void stop() {
    _timer?.cancel();
  }

  void dispose() {
    _timer?.cancel();
    _hrController.close();
  }
}
