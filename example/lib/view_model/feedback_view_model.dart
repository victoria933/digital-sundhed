import '../model/sensor_data.dart';

class FeedbackViewModel {
  final SensorData sensorData;

  FeedbackViewModel(this.sensorData);

  Stream<int> get heartRateStream => sensorData.hrStream;

  void startRun() {
    sensorData.start();
  }

  void stopRun() {
    sensorData.stop();
  }

  void dispose() {
    sensorData.dispose();
  }
}
