import 'package:flutter/services.dart';

class OverlayService {
  OverlayService._();

  static const MethodChannel _mainChannel =
      MethodChannel('com.example.blue_light_filter_main');

  static const MethodChannel _serviceChannel = MethodChannel('overlay_service');

  static Future<bool> checkOverlayPermission() async {
    return await _mainChannel.invokeMethod('checkOverlayPermission');
  }

  static Future<void> requestPermission() async {
    await _mainChannel.invokeMethod('requestPermission');
  }

  static Future<void> startOverlay(Color color, {double alpha = 0.8}) async {
    final colorValue = color.value;
    await _mainChannel.invokeMethod(
      'startOverlay',
      {
        'colorValue': colorValue,
        'alpha': alpha,
      },
    );
  }

  static Future<void> stopOverlay() async {
    await _mainChannel.invokeMethod('stopOverlay');
  }

  static Future<void> updateColor(Color color) async {
    final colorValue = color.value;
    await _serviceChannel.invokeMethod(
      'updateColor',
      {
        'colorValue': colorValue,
      },
    );
  }

  static Future<bool> isActive() async {
    return await _mainChannel.invokeMethod('isActive');
  }
}
