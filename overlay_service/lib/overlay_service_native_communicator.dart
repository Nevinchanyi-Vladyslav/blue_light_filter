import 'dart:async';

import 'package:flutter/services.dart';

class OverlayServiceNativeCommunicator {
  OverlayServiceNativeCommunicator._();

  static const MethodChannel _isServiceRunningChannel =
      MethodChannel('is_service_running');

  static void init(){
    _isServiceRunningChannel.setMethodCallHandler(_handleMethodCall);
  }

  static final StreamController<bool> _isServiceRunningController =
      StreamController<bool>.broadcast();
  static Stream<bool> get isServiceRunningStream =>
      _isServiceRunningController.stream;

  static Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'notifyServiceRunning':
        notifyServiceRunning(call.arguments as bool);
        break;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'The method ${call.method} is not implemented',
        );
    }
  }

  static void notifyServiceRunning(bool isRunning) {
    _isServiceRunningController.add(isRunning);
  }
}
