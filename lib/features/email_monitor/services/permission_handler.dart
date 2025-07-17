
// lib/core/services/permission_handler.dart
import 'package:besafe/features/email_monitor/services/permission_manager_service.dart';
import 'package:flutter/material.dart';

class PermissionHandler extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPermissionsGranted;
  final VoidCallback? onPermissionsDenied;

  const PermissionHandler({
    super.key,
    required this.child,
    this.onPermissionsGranted,
    this.onPermissionsDenied,
  });

  @override
  State<PermissionHandler> createState() => _PermissionHandlerState();
}

class _PermissionHandlerState extends State<PermissionHandler> {
  final PermissionService _permissionService = PermissionService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermissions();
  }

  Future<void> _checkAndRequestPermissions() async {
    setState(() => _isLoading = true);
    
    try {
      // Check if permissions are already granted
      bool alreadyGranted = await _permissionService.arePermissionsGranted();
      
      if (alreadyGranted) {
        widget.onPermissionsGranted?.call();
        setState(() => _isLoading = false);
        return;
      }

      // Show permission dialog
      bool userAccepted = await PermissionService.showPermissionDialog(context);
      
      if (userAccepted) {
        bool granted = await _permissionService.requestAllPermissions();
        
        if (granted) {
          widget.onPermissionsGranted?.call();
        } else {
          widget.onPermissionsDenied?.call();
        }
      } else {
        widget.onPermissionsDenied?.call();
      }
      
    } catch (e) {
      debugPrint('Permission handler error: $e');
      widget.onPermissionsDenied?.call();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              // SizedBox(height: 16),
              // Text('Setting up permissions...'),
            ],
          ),
        ),
      );
    }

    return widget.child;
  }
}