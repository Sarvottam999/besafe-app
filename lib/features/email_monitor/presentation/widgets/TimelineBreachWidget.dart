import 'package:besafe/core/utils/functionss.dart';
import 'package:besafe/features/email_monitor/data/models/breach_model.dart';
import 'package:besafe/features/email_monitor/domain/entities/email_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';

class TimelineBreachWidget extends StatefulWidget {
  final EmailEntity result;
  final bool isProUser;

  const TimelineBreachWidget({
    Key? key,
    required this.result,
    required this.isProUser,
  }) : super(key: key);

  @override
  State<TimelineBreachWidget> createState() => _TimelineBreachWidgetState();
}

class _TimelineBreachWidgetState extends State<TimelineBreachWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          // SizedBox(height: 10),
           if (!widget.isProUser && widget.result.breachDetails.length > 2)
            _buildUpgradePrompt(),
          SizedBox(height: 10),

          _buildTimeline(),
         
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A2E).withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.security,
            color: Colors.white,
            size: 20,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Breach Timeline',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '${widget.result.breachDetails.length} incidents found',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
        if (!widget.isProUser)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'PRO',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTimeline() {
      final int itemsToShow = widget.isProUser ? widget.result.breachDetails.length : 2;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          for (int i = 0; i < itemsToShow; i++)
            _buildTimelineItem(
              widget.result.breachDetails[i],
              i,
              i == itemsToShow - 1,
            ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(BreachModel breach, int index, bool isLast) {
    final bool shouldBlur = !widget.isProUser && index >= 1;
    
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline line and dot
              Column(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: _getTimelineColor(breach),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _getTimelineColor(breach).withOpacity(0.5),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            _getTimelineColor(breach).withOpacity(0.7),
                            _getTimelineColor(breach).withOpacity(0.2),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 16),
              // Content
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(bottom: isLast ? 0 : 20),
                  child: _buildBreachContent(breach, shouldBlur),
                ),
              ),
            ],
          ),
          // Blur overlay for non-pro users
          if (shouldBlur)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBreachContent(BreachModel breach, bool shouldBlur) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2A2A3E).withOpacity(0.8),
            Color(0xFF1A1A2E).withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getTimelineColor(breach).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and severity
          Row(
            children: [
              Expanded(
                child: Text(
                  breach.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              _buildSeverityBadge(breach),
            ],
          ),
          SizedBox(height: 8),
          
          // Domain and date
        Row(
  children: [
    Icon(
      Icons.domain,
      size: 14,
      color: Colors.white.withOpacity(0.6),
    ),
    SizedBox(width: 4),
    Flexible(
      child: Text(
        breach.domain,
        style: TextStyle(
          fontSize: 14,
          color: Colors.white.withOpacity(0.8),
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    ),
    SizedBox(width: 16),
    Icon(
      Icons.access_time,
      size: 14,
      color: Colors.white.withOpacity(0.6),
    ),
    SizedBox(width: 4),
    Text(
      formatDateTimeFromString(breach.breachDate),
      style: TextStyle(
        fontSize: 14,
        color: Colors.white.withOpacity(0.6),
      ),
    ),
  ],
),
 SizedBox(height: 12),
          
          // Impact stats
          Row(
            children: [
              _buildStatChip(
                Icons.people,
                '${_formatNumber(breach.pwnCount)} affected',
                Color(0xFFEF4444),
              ),
              SizedBox(width: 8),
              _buildStatChip(
                Icons.verified_user,
                breach.isVerified ? 'Verified' : 'Unverified',
                breach.isVerified ? Color(0xFF10B981) : Color(0xFFF59E0B),
              ),
            ],
          ),
          SizedBox(height: 12),
          
          // Data classes
          if (breach.dataClasses.isNotEmpty)
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: breach.dataClasses.take(4).map((dataClass) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFF6C5CE7).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Color(0xFF6C5CE7).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    dataClass,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6C5CE7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildSeverityBadge(BreachModel breach) {
    Color badgeColor;
    String label;
    
    if (breach.isSensitive) {
      badgeColor = Color(0xFFDC2626);
      label = 'CRITICAL';
    } else if (breach.pwnCount > 1000000) {
      badgeColor = Color(0xFFEF4444);
      label = 'HIGH';
    } else if (breach.pwnCount > 100000) {
      badgeColor = Color(0xFFF59E0B);
      label = 'MEDIUM';
    } else {
      badgeColor = Color(0xFF10B981);
      label = 'LOW';
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: badgeColor.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: badgeColor,
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpgradePrompt() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFFD700).withOpacity(0.1),
            Color(0xFFFFA500).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFFFD700).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lock,
            color: Color(0xFFFFD700),
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unlock Full Timeline',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Upgrade to Pro to see all ${widget.result.breachDetails.length} breach incidents',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Upgrade',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTimelineColor(BreachModel breach) {
    if (breach.isSensitive) return Color(0xFFDC2626);
    if (breach.pwnCount > 1000000) return Color(0xFFEF4444);
    if (breach.pwnCount > 100000) return Color(0xFFF59E0B);
    return Color(0xFF10B981);
  }



  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}