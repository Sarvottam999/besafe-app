import 'package:besafe/features/email_monitor/data/models/email_model.dart';
import 'package:besafe/features/email_monitor/presentation/pages/scan_result_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/email_provider.dart';
import 'pro_screen.dart';

class StoredEmailsPage extends StatefulWidget {
  @override
  State<StoredEmailsPage> createState() => _StoredEmailsPageState();
}

class _StoredEmailsPageState extends State<StoredEmailsPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
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
      extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      //   foregroundColor: Colors.white,
      //   // leading: IconButton(
      //   //   icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
      //   //   onPressed: () => Navigator.pop(context),
      //   // ),
      //   // title: Text(
      //   //   'Stored Emails',
      //   //   style: TextStyle(
      //   //     color: Colors.white,
      //   //     fontSize: 20,
      //   //     fontWeight: FontWeight.w600,
      //   //   ),
      //   // ),
      //   actions: [
      //     IconButton(
      //       icon: SvgPicture.string(
      //         AppConstants.premiumIcon,
      //         width: 25,
      //         height: 25,
      //         color: AppConstants.goldColor,
      //       ),
      //       onPressed: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => PremiumFeaturesPage(),
      //           ),
      //         );
      //       },
      //     ),
      //   ],
      //   centerTitle: true,
      // ),
      
      
      body: Container(
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
        child: Consumer<EmailProvider>(
          builder: (context, provider, child) {
            // return FadeTransition(
            //   opacity: _fadeAnimation,
            //   child: SlideTransition(
            //     position: _slideAnimation,
            //     child: _buildBody(emails),
            //   ),
            // );
            return FutureBuilder<List<EmailModel>>(
              future: provider.getMonitoredEmails(), // Fetch stored emails
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState();
                } else {
                  return _buildBody(snapshot.data!);
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(List<EmailModel> storedEmails) {
    // Replace this with your actual stored emails list
    // late List<EmailModel> storedEmails = provider.getMonitoredEmails() ?? [];

    if (storedEmails.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 50, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(storedEmails.length),
          // SizedBox(height: 24),
          _buildEmailsList(storedEmails),
        ],
      ),
    );
  }

  Widget _buildHeader(int emailCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Row(
          mainAxisSize: MainAxisSize.min,

              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF6C5CE7), Color(0xFF74B9FF)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.email_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Column(
                          mainAxisSize: MainAxisSize.min,
                
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Emails',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'We’re Keeping an Eye on your $emailCount Email${emailCount != 1 ? 's' : ''}',
                      // '$emailCount email${emailCount != 1 ? 's' : ''} monitored',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
       IconButton(
            icon: SvgPicture.string(
              AppConstants.premiumIcon,
              width: 25,
              height: 25,
              color: AppConstants.goldColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PremiumFeaturesPage(),
                ),
              );
            },
          ),
          
          ],
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF1A1A2E).withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: Color(0xFF74B9FF),
                size: 20,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Tap on any email to view breach details and monitoring status',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmailsList(List<EmailModel> emails) {
 
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: emails.length,
      separatorBuilder: (context, index) => SizedBox(height: 16),
      itemBuilder: (context, index) {
        final email = emails[index];
        return _buildEmailCard(email);
      },
    );
  }

  Widget _buildEmailCard(EmailModel email) {
    return InkWell(
      onTap: () {
        final provider = Provider.of<EmailProvider>(context, listen: false);
        
         provider.scanEmail(email.email);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScanResultPage(),
            ),
          );
        } ,
     
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0xFF1A1A2E).withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: email.isBreached 
                ? Colors.red.withOpacity(0.5) 
                : Colors.white.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: email.isBreached ? [
            BoxShadow(
              color: Colors.red.withOpacity(0.2),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ] : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: email.isBreached 
                        ? Colors.red.withOpacity(0.2)
                        : Color(0xFF6C5CE7).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    email.isBreached 
                        ? Icons.warning_rounded 
                        : Icons.shield_rounded,
                    color: email.isBreached 
                        ? Colors.red 
                        : Color(0xFF6C5CE7),
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        email.email,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        email.isBreached 
                        ? "We found your email shared publicly in ${email.breachDetails.length} plac${email.breachDetails.length != 1 ? 'es' : ''}"
                             : 'All Good! You\'re Safe and Everything Looks Fine',
                        style: TextStyle(
                          fontSize: 13,
                          color: email.isBreached 
                              ? Colors.red.withOpacity(0.8)
                              : Colors.green.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: email.isMonitored 
                            ? Color(0xFF6C5CE7).withOpacity(0.2)
                            : Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        email.isMonitored ? 'Monitored' : 'Not Monitored',
                        style: TextStyle(
                          fontSize: 11,
                          color: email.isMonitored 
                              ? Color(0xFF6C5CE7)
                              : Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white.withOpacity(0.5),
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
            if (email.lastScanned != null) ...[
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    color: Colors.white.withOpacity(0.5),
                    size: 16,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Last scanned: ${_formatDate(email.lastScanned!)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ],
            if (email.isBreached && email.breachDetails.isNotEmpty) ...[
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.security_rounded,
                      color: Colors.red,
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Recent breach: ${email.breachDetails.first.title}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          
          
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Color(0xFF1A1A2E).withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Icon(
                Icons.email_outlined,
                size: 64,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'No Stored Emails',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Start monitoring your emails to see them here',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6C5CE7), Color(0xFF74B9FF)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Add Email',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}