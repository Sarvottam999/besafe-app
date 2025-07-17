import 'package:besafe/core/constants/app_constants.dart';
import 'package:besafe/features/email_monitor/domain/entities/email_entity.dart';
import 'package:flutter/material.dart';

Widget buildMonitoringCard(EmailEntity result, bool isProUser, 
BuildContext context) {
  // Determine if monitoring should be enabled based on pro status
  bool canUseMonitoring = isProUser || result.isMonitored;
  bool showUpgradePrompt = !isProUser && !result.isMonitored;
  
  return NbuildCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              result.isMonitored ? Icons.shield : Icons.shield_outlined,
              color: result.isMonitored 
                  ? Color(0xFF10B981) 
                  : (isProUser ? Colors.white.withOpacity(0.6) : Colors.white.withOpacity(0.4)),
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'Monitoring',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Spacer(),
            // Status badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: result.isMonitored 
                    ? Color(0xFF10B981) 
                    : (isProUser ? Colors.white.withOpacity(0.1) : AppConstants.goldColor.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(20),
                border: !isProUser && !result.isMonitored 
                    ? Border.all(color: AppConstants.goldColor.withOpacity(0.3))
                    : null,
              ),
              child: Text(
                result.isMonitored 
                    ? 'Active' 
                    : (isProUser ? 'Inactive' : 'Pro Only'),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: result.isMonitored 
                      ? Colors.white 
                      : (isProUser ? Colors.white : AppConstants.goldColor),
                ),
              ),
            ),
          ],
        ),
         
        SizedBox(height: 12),
        Text(
          result.isMonitored
              ? 'Real-time monitoring enabled. Instant alerts for new breaches.'
              : (isProUser 
                  ? 'Enable monitoring for future breach alerts.'
                  : 'Upgrade to Pro to enable real-time monitoring and instant breach alerts.'),
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        // Show upgrade prompt for non-pro users
        if (showUpgradePrompt) ...[
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _navigateToProUpgrade(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.goldColor,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.diamond_rounded, size: 16, color: Colors.black,),
                  SizedBox(width: 8),
                  Text(
                    'Upgrade to Pro',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        // Show toggle for pro users when monitoring is not active
        if (isProUser && !result.isMonitored) ...[
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _enableMonitoring(result, context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF10B981).withOpacity(0.1),
                foregroundColor: Color(0xFF10B981),
                side: BorderSide(color: Color(0xFF10B981).withOpacity(0.3)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shield_rounded, size: 16, color: Color(0xFF10B981),),
                  SizedBox(width: 8),
                  Text(
                    'Enable Monitoring',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        // Show disable option for active monitoring
        if (result.isMonitored) ...[
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            child: TextButton(
              onPressed: () => _disableMonitoring(result, context),
              style: TextButton.styleFrom(
                foregroundColor:  Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shield_outlined, size: 16, color: Colors.white,),
                  SizedBox(width: 8),
                  Text(
                    'Disable Monitoring',
                    style: TextStyle(

                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    ),
  );
}


  Widget NbuildCard({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: child,
    );
  }


// Helper methods to handle monitoring actions
void _enableMonitoring(EmailEntity result, 
BuildContext context
) {
  // Show confirmation dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color(0xFF1A1A2E),
        title: Text(
          'Enable Monitoring',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Enable real-time monitoring for ${result.email}? You\'ll receive instant alerts for new breaches.',
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white.withOpacity(0.6)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Add your monitoring enable logic here
          //  emailProvider.enableMonitoring(result.email);

            },
            child: Text(
              'Enable',
              style: TextStyle(color: Color(0xFF10B981)),
            ),
          ),
        ],
      );
    },
  );
}

void _disableMonitoring(EmailEntity result, 
BuildContext context) {
  // Show confirmation dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color(0xFF1A1A2E),
        title: Text(
          'Disable Monitoring',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Disable real-time monitoring for ${result.email}? You won\'t receive alerts for new breaches.',
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white.withOpacity(0.6)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Add your monitoring disable logic here
              // Example: emailProvider.disableMonitoring(result.email);
            },
            child: Text(
              'Disable',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}

void _navigateToProUpgrade() {
  // Navigate to pro upgrade page
  // You can implement the navigation logic here
}