import 'dart:async';

import 'package:besafe/core/constants/app_constants.dart';
import 'package:besafe/features/email_monitor/services/subscription_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PremiumFeaturesPage extends StatefulWidget {
  @override
  _PremiumFeaturesPageState createState() => _PremiumFeaturesPageState();
}

class _PremiumFeaturesPageState extends State<PremiumFeaturesPage> {
  bool isYearlySelected = false;

  late PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.40, // 4 items per page (1 / 4 = 0.25)
      initialPage: 3
    );
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0A0F),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/bg.png',
              fit: BoxFit.cover,
            ),
          ),

          // Gradient Overlay with opacity from bottom to top
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),

          // Main Content
          Padding(
            padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Row(
                  children: [
                     Padding(
          padding: EdgeInsets.only(left: 10),
          child: SvgPicture.string(
          AppConstants.svgAppLogo,
          width: 15,
          height: 15,
          color: AppConstants.goldColor,
                ),
        ),
                    SizedBox(width: 8),

                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Color(0xFF6C5CE7), Color(0xFF74B9FF)],
                      ).createShader(bounds),
                      child: Text(
                        AppConstants.appName,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          height: 1.2,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "PRO",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: AppConstants.goldColor,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8),
                Text(
                  'Get advanced security features.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20),

                // Features Grid
                Container(
                  height: 140,
                  child: PageView.builder(
                    controller: _pageController,
                    itemBuilder: (context, index) {
                      final features = [
                        {
                          'icon': Icons.security,
                          'title': 'Real-time Scan',
                          'description': 'Instant breach detection',
                        },
                        {
                          'icon': Icons.block,
                          'title': 'No Ads',
                          'description': 'Remove all ads',
                        },
                        {
                          'icon': Icons.history,
                          'title': 'Full History',
                          'description': 'Access complete scan history',
                        },
                        {
                          'icon': Icons.share,
                          'title': 'Share Reports',
                          'description': 'Export & share breach reports',
                        },
                        {
                          'icon': Icons.notifications_active,
                          'title': 'Smart Alerts',
                          'description': 'Advanced breach notifications',
                        },
                        {
                          'icon': Icons.speed,
                          'title': 'Fast Processing',
                          'description': 'Priority queue processing',
                        },
                        {
                          'icon': Icons.support_agent,
                          'title': 'Priority Support',
                          'description': '24/7 premium customer support',
                        },
                      ];

                      // Create infinite loop
                      final feature = features[index % features.length];

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: _buildFeatureCard(
                          icon: feature['icon'] as IconData,
                          title: feature['title'] as String,
                          description: feature['description'] as String,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),

                // Premium Features List
                Container(
                  padding: EdgeInsets.all(0),
                  child: Column(
                    children: [
                      _buildFeatureRow('Unlimited email scans / batch processing / alerts'),
                      _buildFeatureRow('Unlimited breach monitoring'),
                      _buildFeatureRow('Advanced security recommendations'),
                      _buildFeatureRow('Priority customer support'),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Dynamic Subscription Section
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildSubscriptionSection(),
                        SizedBox(height: 10),
                        _buildFooterSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionSection() {
    final subscriptionService = Provider.of<SubscriptionService>(context);
    final isSubscribed = subscriptionService.isProUser;

    if (isSubscribed) {
      // Show Pro Status for subscribed users
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppConstants.goldColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppConstants.goldColor.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            // Pro Status Badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppConstants.goldColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified, color: Colors.black, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'PRO ACTIVE',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            Text(
              'You have full access to all premium features!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 12),

            // Subscription Details
            Text(
              'Subscription: ${isYearlySelected ? 'Yearly Plan' : 'Monthly Plan'}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),

            SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showManageSubscriptionDialog(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppConstants.goldColor),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Manage Subscription',
                      style: TextStyle(
                        color: AppConstants.goldColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.goldColor,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Start Using Pro',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // Return original subscription UI for non-pro users
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A2E).withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppConstants.goldColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Monthly Plan
          GestureDetector(
            onTap: () {
              setState(() {
                isYearlySelected = false;
              });
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: !isYearlySelected 
                    ? AppConstants.goldColor.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: !isYearlySelected 
                      ? AppConstants.goldColor
                      : Colors.white.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '₹229.00',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '/ Month',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  Radio<bool>(
                    value: false,
                    groupValue: isYearlySelected,
                    onChanged: (value) {
                      setState(() {
                        isYearlySelected = value!;
                      });
                    },
                    activeColor: AppConstants.goldColor,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          // Yearly Plan
          GestureDetector(
            onTap: () {
              setState(() {
                isYearlySelected = true;
              });
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isYearlySelected 
                    ? AppConstants.goldColor.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isYearlySelected 
                      ? AppConstants.goldColor
                      : Colors.white.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '₹1,099.00',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '/ Year (₹91.58/Month)',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  Radio<bool>(
                    value: true,
                    groupValue: isYearlySelected,
                    onChanged: (value) {
                      setState(() {
                        isYearlySelected = value!;
                      });
                    },
                    activeColor: AppConstants.goldColor,
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 20),

          // Subscribe Button
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showSubscriptionDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.goldColor,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                shadowColor: AppConstants.goldColor.withOpacity(0.4),
              ),
              child: Text(
                'Subscribe',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterSection() {
    final subscriptionService = Provider.of<SubscriptionService>(context);
    final isSubscribed = subscriptionService.isProUser;

    if (isSubscribed) {
      // Simplified footer for Pro users
      return Container(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {},
              child: Text(
                'Privacy Policy',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
            ),
            Text(
              '|',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Terms of Use',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Full footer for non-subscribed users
    return Column(
      children: [
        // Terms and Conditions
        Container(
          padding: EdgeInsets.all(16),
          child: Text(
            'With a subscription, you get unlimited access to all premium features of Email Breach Checker. Subscription is billed monthly or annually (as shown above) automatically after the trial (if available) and charged through your app store account. You can manage or cancel your subscriptions through your app store anytime. Subscription is not required to use basic breach checking features.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 10,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: 10),

        // Footer Links
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {},
              child: Text(
                'Privacy Policy',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
            ),
            Text(
              '|',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Terms of Use',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
            ),
            Text(
              '|',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Restore Purchase',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A2E).withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppConstants.goldColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              icon,
              size: 20,
              color: AppConstants.goldColor,
            ),
          ),
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5),
          Text(
            description,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String feature) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: AppConstants.goldColor,
            size: 20,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              feature,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.9),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSubscriptionDialog() {
    final subscriptionService = Provider.of<SubscriptionService>(context, listen: false);
    final isSubscribed = subscriptionService.isProUser;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (isSubscribed) {
          return AlertDialog(
            backgroundColor: Color(0xFF1A1A2E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Already Subscribed',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Text(
              'You are already a Pro user and have access to all premium features!',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.goldColor,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('OK'),
              ),
            ],
          );
        }

        return AlertDialog(
          backgroundColor: Color(0xFF1A1A2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Subscribe to Breach Pro',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'You\'re about to subscribe to ${isYearlySelected ? 'Yearly' : 'Monthly'} plan for ${isYearlySelected ? '₹1,099.00/Year' : '₹229.00/Month'}.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<SubscriptionService>(context, listen: false).subscribe(yearly: isYearlySelected);
                Navigator.of(context).pop();
                
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Subscription activated successfully!'),
                    backgroundColor: AppConstants.goldColor,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.goldColor,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showManageSubscriptionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1A1A2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Manage Subscription',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Subscription Status: Active',
                style: TextStyle(
                  color: AppConstants.goldColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Plan: ${isYearlySelected ? 'Yearly (₹1,099.00/Year)' : 'Monthly (₹229.00/Month)'}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'You can manage your subscription through your app store account.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Add logic to open app store subscription management
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Redirecting to app store...'),
                    backgroundColor: AppConstants.goldColor,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.goldColor,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Open App Store'),
            ),
          ],
        );
      },
    );
  }
}