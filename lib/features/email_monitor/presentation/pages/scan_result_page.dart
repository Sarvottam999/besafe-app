import 'package:besafe/core/modelcule/NIconButton.dart';
import 'package:besafe/features/auth/presentation/providers/auth_provider.dart';
import 'package:besafe/features/email_monitor/domain/entities/email_entity.dart';
import 'package:besafe/features/email_monitor/presentation/widgets/TimelineBreachWidget.dart';
import 'package:besafe/features/email_monitor/presentation/widgets/build_monitoring_card.dart';
import 'package:besafe/features/email_monitor/services/subscription_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 import '../providers/email_provider.dart';
import 'package:intl/intl.dart';

class ScanResultPage extends StatefulWidget {
  @override
  State<ScanResultPage> createState() => _ScanResultPageState();
}

class _ScanResultPageState extends State<ScanResultPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _pulseAnimation = Tween<double>(begin: 0.98, end: 1.02).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0A0A),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0A0A), Color(0xFF1A1A2E), Color(0xFF16213E)],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: Consumer<EmailProvider>(
          builder: (context, provider, child) {
            if (provider.state == EmailState.loading) return _buildLoadingScreen();
            if (provider.state == EmailState.error) return _buildErrorScreen(provider);
            if (provider.scanResult == null) return _buildNoResultScreen();
            return _buildResultScreen(provider);
          },
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Column(
      children: [
        _buildMinimalAppBar(),
        Expanded(
          child: Center(
            child:  CircularProgressIndicator()),
        ),
      ],
    );
  }

  Widget _buildErrorScreen(EmailProvider provider) {
    return Column(
      children: [
        _buildMinimalAppBar(),
        Expanded(
          child: Center(
            child: AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Color(0xFFEF4444).withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: Border.all(color: Color(0xFFEF4444).withOpacity(0.3)),
                            ),
                            child: Icon(Icons.error_outline, size: 40, color: Color(0xFFEF4444)),
                          ),
                          SizedBox(height: 24),
                          Text(
                            'Analysis Failed',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            provider.errorMessage,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.7),
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 32),
                          _buildActionButton(
                            text: 'Try Again',
                            icon: Icons.refresh,
                            onPressed: () => provider.scanEmail(provider.selectedEmail),
                            isPrimary: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoResultScreen() {
    return Column(
      children: [
        _buildMinimalAppBar(),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 60, color: Colors.white.withOpacity(0.5)),
                SizedBox(height: 16),
                Text(
                  'No Results Available',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultScreen(EmailProvider provider,) {
    final result = provider.scanResult!;
    final subscriptionService = Provider.of<SubscriptionService>(context, listen: false);
    
    return Column(
      children: [
        _buildResultAppBar(result),
        Expanded(
          child: AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _slideAnimation.value),
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: _buildHeroSection(result),
                      ),
                      
                      // Content Cards
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          20, 0, 20, 0
                        ),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            _buildEmailCard(result),
                            SizedBox(height: 16),
                            _buildStatsGrid(result),
                            SizedBox(height: 16),
                            if (result.isBreached && result.breachDetails.isNotEmpty) ...[
                              _buildBreachCard(result, subscriptionService.isProUser),
                              SizedBox(height: 16),
                            ],
                            buildMonitoringCard(result, subscriptionService.isProUser, context),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        
        // Fixed Bottom Actions
        _buildBottomActions(provider, subscriptionService),
      ],
    );
  }

  Widget _buildMinimalAppBar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
      child: Row(
        children: [
          NIconButton(Icons.arrow_back_ios_new, () => Navigator.pop(context)),
          Spacer(),
          Text(
            'Security Analysis',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Spacer(),

         NIconButton(
          Icons.help_outline,
          () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Help'),
              content: Text('This is a security analysis app.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          ) )
          // _buildIconButton(Icons.more_vert, () => _showMoreOptions(context)),
        ],
      ),
    );
  }

  Widget _buildResultAppBar(EmailEntity result) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            result.isBreached ? Color(0xFFEF4444).withOpacity(0.1) : Color(0xFF10B981).withOpacity(0.1),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          NIconButton(Icons.arrow_back_ios_new, () => Navigator.pop(context)),
          Spacer(),
          Column(
            children: [
              Text(
                result.isBreached ? 'Security Alert' : 'All Clear',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: result.isBreached ? Color(0xFFEF4444) : Color(0xFF10B981),
                ),
              ),
              Text(
                result.email,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
          Spacer(),
           NIconButton(
          Icons.help_outline,
          () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Help'),
              content: Text('This is a security analysis app.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          ) )
          // _buildIconButton(Icons.more_vert, () => _showMoreOptions(context)),
        ],
      ),
    );
  }

  Widget _buildHeroSection(EmailEntity result) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: result.isBreached ? [
            Color(0xFFEF4444).withOpacity(0.15),
            Color(0xFFDC2626).withOpacity(0.05),
          ] : [
            Color(0xFF10B981).withOpacity(0.15),
            Color(0xFF059669).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: result.isBreached 
              ? Color(0xFFEF4444).withOpacity(0.3)
              : Color(0xFF10B981).withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: result.isBreached ? Color(0xFFEF4444) : Color(0xFF10B981),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (result.isBreached ? Color(0xFFEF4444) : Color(0xFF10B981)).withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    result.isBreached ? Icons.warning_amber : Icons.check_circle_outline,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 10),
          Text(
            result.isBreached ? 'We Found Your Email data Shared Publicly' : 'Your Email Is Safe',
            textAlign: TextAlign.center,
            style: TextStyle(

              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            result.isBreached
                ? 'Found in ${result.breachDetails.length} plac${result.breachDetails.length > 1 ? 'es' : ''}'
                : 'You’re safe right now, nothing to worry about',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailCard(EmailEntity result) {
    return NbuildCard(
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.email_outlined, color: Colors.white, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.email,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Scanned: ${result.lastScanned != null ? _formatDate(result.lastScanned!) : 'Never'}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(EmailEntity result) {
    return Row(
      children: [
        Expanded(child: _buildStatCard(Icons.security, 'Status', result.isBreached ? 'At Risk' : 'Secure', result.isBreached ? Color(0xFFEF4444) : Color(0xFF10B981))),
        SizedBox(width: 12),
        Expanded(child: _buildStatCard(Icons.dataset, 'Breaches', '${result.breachDetails.length}', Color(0xFF6366F1))),
        SizedBox(width: 12),
        Expanded(child: _buildStatCard(Icons.shield, 'Monitor', result.isMonitored ? 'On' : 'Off', Color(0xFF8B5CF6))),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String title, String value, Color color) {
    return NbuildCard(
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildBreachCard(EmailEntity result) {
  //   return _buildCard(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Icon(Icons.warning_amber, color: Color(0xFFEF4444), size: 20),
  //             SizedBox(width: 8),
  //             Text(
  //               'Breach Details',
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w600,
  //                 color: Colors.white,
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 16),
  //         Container(
  //           constraints: BoxConstraints(maxHeight: 200),
  //           child: ListView.builder(
  //             shrinkWrap: true,
  //             itemCount: result.breachDetails.length,
  //             itemBuilder: (context, index) {
  //               return Container(
  //                 margin: EdgeInsets.only(bottom: 8),
  //                 padding: EdgeInsets.all(12),
  //                 decoration: BoxDecoration(
  //                   color: Colors.white.withOpacity(0.05),
  //                   borderRadius: BorderRadius.circular(8),
  //                 ),
  //                 child: Row(
  //                   children: [
  //                     Container(
  //                       width: 6,
  //                       height: 6,
  //                       decoration: BoxDecoration(
  //                         color: Color(0xFFEF4444),
  //                         shape: BoxShape.circle,
  //                       ),
  //                     ),
  //                     SizedBox(width: 12),
  //                     Expanded(
  //                       child: Text(
  //                         result.breachDetails[index].title,
  //                         style: TextStyle(
  //                           fontSize: 14,
  //                           color: Colors.white.withOpacity(0.9),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
Widget _buildBreachCard(EmailEntity result, bool isProUser) {
  return SizedBox(
    height: 300,
    child: SingleChildScrollView(
      child: TimelineBreachWidget(
        result: result,
        isProUser: isProUser,
      ),
    ),
  );
}

  // Widget _buildMonitoringCard(EmailEntity result, bool isProUser) {
  //   return _buildCard(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Icon(
  //               result.isMonitored ? Icons.shield : Icons.shield_outlined,
  //               color: result.isMonitored ? Color(0xFF10B981) : Colors.white.withOpacity(0.6),
  //               size: 20,
  //             ),
  //             SizedBox(width: 8),
  //             Text(
  //               'Monitoring',
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w600,
  //                 color: Colors.white,
  //               ),
  //             ),
  //             Spacer(),
  //             Container(
  //               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //               decoration: BoxDecoration(
  //                 color: result.isMonitored ? Color(0xFF10B981) : Colors.white.withOpacity(0.1),
  //                 borderRadius: BorderRadius.circular(20),
  //               ),
  //               child: Text(
  //                 result.isMonitored ? 'Active' : 'Inactive',
  //                 style: TextStyle(
  //                   fontSize: 12,
  //                   fontWeight: FontWeight.w600,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 12),
  //         Text(
  //           result.isMonitored
  //               ? 'Real-time monitoring enabled. Instant alerts for new breaches.'
  //               : 'Enable monitoring for future breach alerts.',
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: Colors.white.withOpacity(0.7),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildBottomActions(EmailProvider provider, SubscriptionService subscriptionService) {
    // print("## provider.scanResult!.isMonitored ==>${provider.scanResult!.isMonitored}");
    final authProvider = Provider.of<AuthProvider>(context);

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF0A0A0A).withOpacity(0.9),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
      child: Row(
        children: [
          if (authProvider.isLoggedIn && subscriptionService.isProUser)...[

          if (!provider.scanResult!.isMonitored)
            Expanded(
              child: _buildActionButton(
                text: 'Enable Monitoring',
                icon: Icons.shield_outlined,
                onPressed: () => provider.toggleMonitoring(true),
                isPrimary: true,
              ),
            )
          else
            Expanded(
              child: _buildActionButton(
                text: 'Disable Monitoring',
                icon: Icons.shield_outlined,
                onPressed: () => provider.toggleMonitoring(false),
                isPrimary: false,
              ),
            ),

          SizedBox(width: 12),
          ],
          Expanded(
            child: _buildActionButton(
              text: 'Scan Another',
              icon: Icons.refresh,
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
                provider.reset();
              },
              isPrimary: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: isPrimary ? LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]) : null,
        color: isPrimary ? null : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Color(0xFF1A1A2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 24),
            _buildBottomSheetItem(Icons.share, 'Share Results', () => Navigator.pop(context)),
            _buildBottomSheetItem(Icons.download, 'Export Report', () => Navigator.pop(context)),
            _buildBottomSheetItem(Icons.help_outline, 'Help & Support', () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  String _formatDate(DateTime date) => DateFormat('MMM dd, yyyy').format(date);
}