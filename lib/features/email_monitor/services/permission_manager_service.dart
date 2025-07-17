// lib/core/services/permission_service.dart
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = 
      FlutterLocalNotificationsPlugin();

  /// Request all required permissions
  Future<bool> requestAllPermissions() async {
    try {
      // Request notification permission
      bool notificationGranted = await _requestNotificationPermission();
      
      
      // Request other permissions
      // bool storageGranted = await _requestStoragePermission();
      
      // Add more permissions as needed
      // bool cameraGranted = await _requestCameraPermission();
      
      return notificationGranted ;
      // && storageGranted;
    } catch (e) {
      debugPrint('Permission request error: $e');
      return false;
    }
  }



  /// Request notification permission
  Future<bool> _requestNotificationPermission() async {
    try {
      // For Android 13+
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

      var status = await Permission.notification.request();
      print("### ===> $status  -- ${status.isGranted}");
      return status.isGranted;
    } catch (e) {
      debugPrint('Notification permission error: $e');
      return false;
    }
  }

  /// Request storage permission
  Future<bool> _requestStoragePermission() async {
    try {
      var status = await Permission.storage.request();
      return status.isGranted;
    } catch (e) {
      debugPrint('Storage permission error: $e');
      return false;
    }
  }

  /// Check if all permissions are granted
  Future<bool> arePermissionsGranted() async {
    bool notification = await Permission.notification.isGranted;
    // bool storage = await Permission.storage.isGranted;
    
    return notification;
    //  && storage;
  }

  /// Show permission dialog
  static Future<bool> showPermissionDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Permissions Required'),
        content: const Text(
          'This app needs permissions to:\n'
          '• Send notifications about email breaches\n'
          // '• Access device storage\n\n'
          'Please grant permissions to continue.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Skip'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Grant Permissions'),
          ),
        ],
      ),
    ) ?? false;
  }
}
