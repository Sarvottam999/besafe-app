// features/profile/presentation/pages/profile_page.dart
import 'package:besafe/features/auth/presentation/providers/auth_provider.dart';
import 'package:besafe/features/email_monitor/services/subscription_service.dart';
import 'package:besafe/features/profile/profile_provider.dart';
import 'package:besafe/features/profile/widgets/profile_dialogs.dart';
import 'package:besafe/features/profile/widgets/profile_header.dart';
import 'package:besafe/features/profile/widgets/settings_item.dart';
import 'package:besafe/features/profile/widgets/settings_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
bool _hasSyncedSubscription = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.elasticOut));
    
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0A0F),
      // extendBodyBehindAppBar: true,
      // appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

 Widget _buildBody() {
  return Container(
    height: double.infinity,
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF0A0A0F),
          Color(0xFF1A1A2E),
          Color(0xFF16213E),
        ],
      ),
    ),
    child:  Consumer2<SubscriptionService, AuthProvider>(
builder: (context, subscriptionProvider, authProvider, child) {
  final currentUser = authProvider.currentUser;

  // if (currentUser != null && !_hasSyncedSubscription) {
   
  //   _hasSyncedSubscription = true;
  // }


        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16, 50, 16, 24),
              child: Column(
                children: [
                  ProfileHeader(
                    userName: currentUser?.username ?? 'User',
                    userEmail: currentUser?.email ?? 'user@example.com',
                    isProUser: subscriptionProvider.isProUser,
                  ),
                  SizedBox(height: 32),
                  if (!subscriptionProvider.isProUser) ...[
                    _buildProUpgradeCard(),
                    SizedBox(height: 24),
                  ],
                  ..._buildSettingsSections(subscriptionProvider),
                  SizedBox(height: 32),
                  _buildSignOutButton(authProvider, subscriptionProvider),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

  Widget _buildProUpgradeCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF6C5CE7).withOpacity(0.2),
            Color(0xFF74B9FF).withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppConstants.goldColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.diamond_rounded, color: AppConstants.goldColor, size: 24),
              SizedBox(width: 12),
              Text(
                'Upgrade to Pro',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Unlock premium features and get advanced security monitoring',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _navigateToProUpgrade(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.goldColor,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Upgrade Now',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSettingsSections(SubscriptionService provider) {
    return [
      // _buildAccountSection(provider),
      // SizedBox(height: 16),
      // _buildSecuritySection(provider),
      // SizedBox(height: 16),
      _buildNotificationSection(provider),
      // SizedBox(height: 16),
      // _buildAppSection(provider),
      SizedBox(height: 16),
      _buildSupportSection(),
    ];
  }

  Widget _buildNotificationSection(SubscriptionService provider) {
    List<Widget> items = [
 SettingsItem.toggle(
          icon: Icons.speed_rounded,
          title: 'Real-time Monitoring',
          subtitle: 'Instant breach notifications',
          value: provider.realTimeMonitoringEnabled,
          onChanged: provider.toggleRealTimeMonitoring,
        ),
    ];
 

    return SettingsSection(
      title: 'Notifications',
      icon: Icons.notifications_rounded,
      children: items,
    );
  }

  Widget _buildSupportSection() {
    return SettingsSection(
      title: 'Support',
      icon: Icons.help_rounded,
      children: [
        SettingsItem.action(
          icon: Icons.help_outline_rounded,
          title: 'Help Center',
          subtitle: 'Get help and support',
          onTap: () => _navigateToHelpCenter(),
        ),
        SettingsItem.action(
          icon: Icons.feedback_rounded,
          title: 'Send Feedback',
          subtitle: 'Share your thoughts',
          onTap: () => ProfileDialogs.showFeedback(context),
        ),
        SettingsItem.action(
          icon: Icons.star_rounded,
          title: 'Rate App',
          subtitle: 'Rate us on the app store',
          onTap: () => _rateApp(),
        ),
        SettingsItem.action(
          icon: Icons.info_outline_rounded,
          title: 'About',
          subtitle: 'App version and info',
          onTap: () => ProfileDialogs.showAbout(context),
        ),
      ],
    );
  }

  // Widget _buildSignOutButton() {
  //   return Container(
  //     width: double.infinity,
  //     height: 56,
  //     decoration: BoxDecoration(
  //       color: Colors.red.withOpacity(0.1),
  //       borderRadius: BorderRadius.circular(16),
  //       border: Border.all(color: Colors.red.withOpacity(0.3)),
  //     ),
  //     child: ElevatedButton(
  //       onPressed: () => ProfileDialogs.showSignOut(context),
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: Colors.transparent,
  //         shadowColor: Colors.transparent,
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //       ),
  //       child: Text(
  //         'Sign Out',
  //         style: TextStyle(
  //           fontSize: 16,
  //           fontWeight: FontWeight.w600,
  //           color: Colors.red,
  //         ),
  //       ),
  //     ),
  //   );
  // }
Widget _buildSignOutButton(AuthProvider authProvider, SubscriptionService subscriptionProvider) {
  return Container(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () => _showSignOutDialog(authProvider,   subscriptionProvider),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.withOpacity(0.1),
        foregroundColor: Colors.red,
        side: BorderSide(color: Colors.red.withOpacity(0.3)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(vertical: 16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.logout_rounded, size: 20),
          SizedBox(width: 8),
          Text(
            'Sign Out',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ),
  );
}

void _showSignOutDialog(AuthProvider authProvider, SubscriptionService subscriptionProvider) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color(0xFF1A1A2E),
        title: Text(
          'Sign Out',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to sign out?',
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
            onPressed: () async {
              Navigator.of(context).pop();
              await authProvider.logout();
              subscriptionProvider.resetAllSettings();
              // Navigation will be handled automatically by the Consumer in main.dart
            },
            child: Text(
              'Sign Out',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}

  // Navigation methods
  void _navigateToProUpgrade() {
    // Navigate to pro upgrade page
  }

  void _navigateToChangePassword() {
    // Navigate to change password page
  }

  void _navigateToScanHistory() {
    // Navigate to scan history page
  }

  void _navigateToStorageSettings() {
    // Navigate to storage settings page
  }

  void _navigateToHelpCenter() {
    // Navigate to help center page
  }

  void _rateApp() {
    // Open app store rating
  }
}


  // Widget _buildAccountSection(SubscriptionService provider) {
  //   return SettingsSection(
  //     title: 'Account',
  //     icon: Icons.person_rounded,
  //     children: [
  //       SettingsItem.action(
  //         icon: Icons.edit_rounded,
  //         title: 'Edit Profile',
  //         subtitle: 'Update your personal information',
  //         onTap: () => ProfileDialogs.showEditProfile(context),
  //       ),
  //       SettingsItem.action(
  //         icon: Icons.email_rounded,
  //         title: 'Change Email',
  //         subtitle: provider.userEmail,
  //         onTap: () => ProfileDialogs.showChangeEmail(context),
  //       ),
  //       SettingsItem.action(
  //         icon: Icons.lock_rounded,
  //         title: 'Change Password',
  //         subtitle: 'Update your password',
  //         onTap: () => _navigateToChangePassword(),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildSecuritySection(SubscriptionService provider) {
  //   return SettingsSection(
  //     title: 'Security & Privacy',
  //     icon: Icons.security_rounded,
  //     children: [
  //       SettingsItem.toggle(
  //         icon: Icons.fingerprint_rounded,
  //         title: 'Biometric Authentication',
  //         subtitle: 'Use fingerprint or face ID',
  //         value: provider.biometricEnabled,
  //         onChanged: provider.toggleBiometric,
  //       ),
  //       SettingsItem.toggle(
  //         icon: Icons.visibility_off_rounded,
  //         title: 'Auto-lock App',
  //         subtitle: 'Lock app when inactive',
  //         value: provider.autoLockEnabled,
  //         onChanged: provider.toggleAutoLock,
  //       ),
  //       SettingsItem.action(
  //         icon: Icons.history_rounded,
  //         title: 'Scan History',
  //         subtitle: 'View your email scan history',
  //         onTap: () => _navigateToScanHistory(),
  //       ),
  //       SettingsItem.action(
  //         icon: Icons.delete_outline_rounded,
  //         title: 'Clear Data',
  //         subtitle: 'Remove all stored scan data',
  //         onTap: () => ProfileDialogs.showClearData(context),
  //         isDestructive: true,
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildAppSection(SubscriptionService provider) {
  //   return SettingsSection(
  //     title: 'App Settings',
  //     icon: Icons.settings_rounded,
  //     children: [
  //       SettingsItem.toggle(
  //         icon: Icons.dark_mode_rounded,
  //         title: 'Dark Mode',
  //         subtitle: 'Always enabled for better security',
  //         value: true,
  //         onChanged: null,
  //       ),
  //       SettingsItem.action(
  //         icon: Icons.language_rounded,
  //         title: 'Language',
  //         subtitle: 'English',
  //         onTap: () => ProfileDialogs.showLanguageSelector(context),
  //       ),
  //       SettingsItem.action(
  //         icon: Icons.storage_rounded,
  //         title: 'Storage',
  //         subtitle: 'Manage app storage',
  //         onTap: () => _navigateToStorageSettings(),
  //       ),
  //     ],
  //   );
  // }
