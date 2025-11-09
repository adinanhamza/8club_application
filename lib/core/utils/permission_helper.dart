import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  static Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  static Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  static Future<Map<Permission, bool>> requestMediaPermissions() async {
    final statuses = await [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
    ].request();

    return {
      Permission.camera: statuses[Permission.camera]?.isGranted ?? false,
      Permission.microphone: statuses[Permission.microphone]?.isGranted ?? false,
      Permission.storage: statuses[Permission.storage]?.isGranted ?? false,
    };
  }

  static Future<bool> checkCameraPermission() async {
    return await Permission.camera.isGranted;
  }

  static Future<bool> checkMicrophonePermission() async {
    return await Permission.microphone.isGranted;
  }

  static Future<void> openAppSettings() async {
    await openAppSettings();
  }
}
