import 'package:flutter/services.dart';

class ShizukuService {
  static const MethodChannel _channel = MethodChannel('com.omni.search/shizuku');

  /// শিজুকু পারমিশন আছে কিনা বা অ্যাক্টিভ আছে কিনা তা চেক করে
  static Future<bool> checkPermission() async {
    try {
      final bool isGranted = await _channel.invokeMethod('checkShizukuPermission');
      return isGranted;
    } on PlatformException catch (e) {
      print("Shizuku Permission Check Error: ${e.message}");
      return false;
    }
  }

  /// শিজুকুর মাধ্যমে কাস্টম এডিবি শেল কম্যান্ড এক্সিকিউট করে
  static Future<String> executeCommand(String command) async {
    try {
      final String result = await _channel.invokeMethod('executeCommand', {
        'command': command,
      });
      return result;
    } on PlatformException catch (e) {
      return "Execution Failed: ${e.message}";
    }
  }
}