class AppLogger {
  static const bool _isDevelopment = true;

  static void log(String message, {String tag = 'APP'}) {
    if (_isDevelopment) {
      print('[$tag] $message');
    }
  }

  static void error(String message, {String tag = 'ERROR', Object? error}) {
    if (_isDevelopment) {
      print('[$tag] $message');
      if (error != null) {
        print('Error details: $error');
      }
    }
  }

  static void apiLog(String method, String endpoint, {dynamic data}) {
    if (_isDevelopment) {
      print('=== API $method ===');
      print('Endpoint: $endpoint');
      if (data != null) {
        print('Data: $data');
      }
      print('==================');
    }
  }

  static void blocLog(String blocName, String event, dynamic state) {
    if (_isDevelopment) {
      print('=== $blocName ===');
      print('Event: $event');
      print('State: $state');
      print('=================');
    }
  }
}
