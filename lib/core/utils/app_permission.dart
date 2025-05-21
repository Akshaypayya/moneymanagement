import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestCameraPermission(BuildContext context) async {
    var status = await Permission.camera.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      status = await Permission.camera.request();
      if (status.isGranted) {
        return true;
      }
    }

    if (status.isPermanentlyDenied) {
      _showPermissionDialog(
        context,
        'Camera Permission Required',
        'Camera permission is required to take profile pictures. Please enable it in app settings.',
      );
      return false;
    }

    return false;
  }

  static Future<bool> requestGalleryPermission(BuildContext context) async {
    Permission permission;

    if (Platform.isAndroid) {
      if (await _isAndroid13OrHigher()) {
        permission = Permission.photos;
      } else {
        permission = Permission.storage;
      }
    } else {
      permission = Permission.photos;
    }

    var status = await permission.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      status = await permission.request();
      if (status.isGranted) {
        return true;
      }
    }

    if (status.isPermanentlyDenied) {
      _showPermissionDialog(
        context,
        'Gallery Permission Required',
        'Gallery permission is required to select profile pictures. Please enable it in app settings.',
      );
      return false;
    }

    return false;
  }

  static Future<bool> _isAndroid13OrHigher() async {
    if (Platform.isAndroid) {
      return await DeviceInfoPlugin().androidInfo.then(
            (info) => info.version.sdkInt >= 33,
          );
    }
    return false;
  }

  static void _showPermissionDialog(
      BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Open Settings'),
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }
}
