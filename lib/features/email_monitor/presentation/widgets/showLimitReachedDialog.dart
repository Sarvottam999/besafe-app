import 'package:besafe/core/constants/app_constants.dart';
import 'package:besafe/features/email_monitor/presentation/pages/pro_screen.dart';
import 'package:flutter/material.dart';

void showLimitReachedDialog(BuildContext context, bool isLoggedIn) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          // cancel button
         
          Container(
            width: double.infinity,
            constraints: BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A1A2E),
                  Color(0xFF16213E),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isLoggedIn 
                  ? Color(0xFF6C5CE7).withOpacity(0.3)
                  : Color(0xFFFF6B6B).withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with icon and gradient
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isLoggedIn 
                        ? [
                            Color(0xFF6C5CE7).withOpacity(0.2),
                            Color(0xFF74B9FF).withOpacity(0.2),
                          ]
                        : [
                            Color(0xFFFF6B6B).withOpacity(0.2),
                            Color(0xFFFF8E8E).withOpacity(0.2),
                          ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isLoggedIn 
                            ? Color(0xFF6C5CE7).withOpacity(0.3)
                            : Color(0xFFFF6B6B).withOpacity(0.3),
                          border: Border.all(
                            color: isLoggedIn 
                              ? Color(0xFF6C5CE7)
                              : Color(0xFFFF6B6B),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          isLoggedIn ? Icons.diamond_rounded : Icons.lock_rounded,
                          color: isLoggedIn 
                            ? Color(0xFF6C5CE7)
                            : Color(0xFFFF6B6B),
                          size: 28,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        isLoggedIn ? 'Scan Limit Reached' : 'Guest Limit Reached',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                // Content
                Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        isLoggedIn 
                          ? 'You\'ve used all 5 free scans. Upgrade to Pro for unlimited scans and real-time monitoring.'
                          : 'Guest users can only scan once. Login for 5 free scans or upgrade to Pro for unlimited access.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      SizedBox(height: 24),
                      
                      // Pro features preview
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFF6C5CE7).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFF6C5CE7).withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Pro Features',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6C5CE7),
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.check_circle_rounded, 
                                     color: Color(0xFF6C5CE7), size: 18),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Unlimited email scans',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.check_circle_rounded, 
                                     color: Color(0xFF6C5CE7), size: 18),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Real-time monitoring',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.check_circle_rounded, 
                                     color: Color(0xFF6C5CE7), size: 18),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Real-time notification',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 24),
                      
                      // Action buttons
                      Row(
                        children: [
                          // Expanded(
                          //   child: TextButton(
                          //     onPressed: () => Navigator.pop(context),
                          //     style: TextButton.styleFrom(
                          //       padding: EdgeInsets.symmetric(vertical: 16),
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(12),
                          //       ),
                          //     ),
                          //     child: Text(
                          //       'Cancel',
                          //       style: TextStyle(
                          //         color: Colors.white.withOpacity(0.6),
                          //         fontSize: 16,
                          //         fontWeight: FontWeight.w600,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          
                          if (!isLoggedIn) ...[
                            SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, '/login');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF16213E),
                                  foregroundColor: Color(0xFF6C5CE7),
                                  side: BorderSide(color: Color(0xFF6C5CE7)),
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.login_rounded, size: 18),
                                    SizedBox(width: 8),
                                    Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          
                          SizedBox(width: 12),
                          Expanded(
                            flex: isLoggedIn ? 2 : 1,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PremiumFeaturesPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConstants.goldColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                                
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.diamond_rounded, size: 18, color: Colors.black,),
                                  SizedBox(width: 8),
                                  Text(
                                    'Upgrade',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
       
        Positioned(
          top: 16,
          right: 16,

            child:  IconButton(
              icon: Icon(Icons.close_rounded, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),
       
        ],
      ),
    ),
  );
}