import 'dart:async';

class OtpResendTimerController {
  Timer? _timer;
  int _remainingTime;
  final int initialTime;

  // Stream to notify listeners about remaining time changes
  final StreamController<int> _timeController =
      StreamController<int>.broadcast();

  OtpResendTimerController({required this.initialTime})
      : _remainingTime = initialTime;

  // Getter for remaining time
  int get remainingTime => _remainingTime;

  // Stream to listen to remaining time updates
  Stream<int> get timeStream => _timeController.stream;

  // Helper method to format remaining time as MM:SS
  String get formattedTime {
    int minutes = _remainingTime ~/ 60; // Get minutes
    int seconds = _remainingTime % 60; // Get seconds
    // Format minutes and seconds as two digits
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  void start() {
    if (_timer != null && _timer!.isActive) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
        _timeController.add(_remainingTime); // Notify listeners
      } else {
        stop();
      }
    });
  }

  void reset() {
    _timer?.cancel();
    _remainingTime = initialTime;
    _timeController.add(_remainingTime); // Notify listeners
  }

  void stop() {
    _timer?.cancel();
    _remainingTime = initialTime;
    _timeController.add(_remainingTime); // Notify listeners
  }

  void dispose() {
    _timer?.cancel();
    _timeController.close();
  }
}
