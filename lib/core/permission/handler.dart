import 'package:permission_handler/permission_handler.dart';

class PermissionRequester {
  Future<bool> requestPermissions() async {
    bool bluetoothPermissionGranted = await _requestBluetoothPermissions();
    bool cameraPermissionGranted = await _requestCameraPermission();

    return bluetoothPermissionGranted && cameraPermissionGranted;
  }

  /// Request Bluetooth permissions
  Future<bool> _requestBluetoothPermissions() async {
    if (await Permission.bluetooth.isGranted) {
      return true;
    }

    // Request Bluetooth permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.bluetoothAdvertise,
    ].request();

    Permission.bluetooth.request();

    return statuses[Permission.bluetooth]!.isGranted;
  }

  /// Request Camera permission
  Future<bool> _requestCameraPermission() async {
    if (await Permission.camera.isGranted) {
      return true;
    }

    PermissionStatus status = await Permission.camera.request();

    return status.isGranted;
  }
}
