
// features/profile/presentation/widgets/profile_header.dart
import 'package:besafe/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String userName;
  final String userEmail;
  final bool isProUser;

  const ProfileHeader({
    Key? key,
    required this.userName,
    required this.userEmail,
    required this.isProUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isProUser
              ? [Color(0xFF6C5CE7).withOpacity(0.2), Color(0xFF74B9FF).withOpacity(0.2)]
              : [Color(0xFF1A1A2E).withOpacity(0.3), Color(0xFF16213E).withOpacity(0.3)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isProUser
              ? AppConstants.goldColor.withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFF6C5CE7).withOpacity(0.3),
                child: Icon(
                  Icons.person_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              if (isProUser)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppConstants.goldColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.diamond_rounded,
                      size: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                userName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              if (isProUser) ...[
                SizedBox(width: 8),
                Icon(
                  Icons.verified_rounded,
                  color: AppConstants.goldColor,
                  size: 20,
                ),
              ],
            ],
          ),
          SizedBox(height: 4),
          Text(
            userEmail,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          if (isProUser) ...[
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppConstants.goldColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppConstants.goldColor.withOpacity(0.5)),
              ),
              child: Text(
                'PRO MEMBER',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppConstants.goldColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
