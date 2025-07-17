
// features/profile/presentation/widgets/settings_item.dart
import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool? value;
  final Function(bool)? onChanged;
  final bool isDestructive;

  const SettingsItem._({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.value,
    this.onChanged,
    this.isDestructive = false,
  }) : super(key: key);

  factory SettingsItem.action({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return SettingsItem._(
      icon: icon,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
      isDestructive: isDestructive,
    );
  }

  factory SettingsItem.toggle({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool)? onChanged,
  }) {
    return SettingsItem._(
      icon: icon,
      title: title,
      subtitle: subtitle,
      value: value,
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Color(0xFF1A1A2E).withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? Colors.red : Colors.white,
              size: 22,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDestructive ? Colors.red : Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            _buildTrailingWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildTrailingWidget() {
    if (value != null) {
      return Switch(
        value: value!,
        onChanged: onChanged,
        activeColor: Color(0xFF6C5CE7),
        activeTrackColor: Color(0xFF6C5CE7).withOpacity(0.3),
        inactiveThumbColor: Colors.white.withOpacity(0.7),
        inactiveTrackColor: Colors.white.withOpacity(0.2),
      );
    }
    return Icon(
      Icons.chevron_right_rounded,
      color: Colors.white.withOpacity(0.5),
      size: 20,
    );
  }
}
