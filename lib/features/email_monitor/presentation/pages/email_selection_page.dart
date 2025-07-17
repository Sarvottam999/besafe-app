// features/email_monitor/presentation/pages/email_selection_page.dart
import 'package:besafe/features/auth/presentation/providers/auth_provider.dart';
import 'package:besafe/features/email_monitor/presentation/pages/pro_screen.dart';
import 'package:besafe/features/email_monitor/presentation/widgets/home_feature_crousal.dart';
import 'package:besafe/features/email_monitor/presentation/widgets/showLimitReachedDialog.dart';
import 'package:besafe/features/email_monitor/services/subscription_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/email_provider.dart';
import '../widgets/email_input_widget.dart';
import 'scan_result_page.dart';

class EmailSelectionPage extends StatefulWidget {
  @override
  State<EmailSelectionPage> createState() => _EmailSelectionPageState();
}

class _EmailSelectionPageState extends State<EmailSelectionPage> with TickerProviderStateMixin {
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
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    return Scaffold(
      backgroundColor: Color(0xFF0A0A0F),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        leading:   Padding(
          padding: EdgeInsets.only(left: 10),
          child: SvgPicture.string(
          AppConstants.svgAppLogo,
          width: 15,
          height: 15,
                ),
        ),

        
      
        actions: [
          // Padding(
          //   padding: EdgeInsets.only(right: 10),
          //   child: IconButton(
          //     icon: Icon(Icons.info_outline, size: 25, color: Colors.white),
          //     onPressed: () {
          //      },
          //   ),
          // ),

          //  login button 
          if (!authProvider.isLoggedIn)
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: TextButton(
              child: Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),  
              onPressed: () {
  Navigator.pushNamed(context, '/login').then((_) {
    // After login, rebuild the widget to reflect auth state
    if (mounted) {
      setState(() {});
    }
  });
              },
            ),
          ),

          IconButton(
            icon: SvgPicture.string(AppConstants.premiumIcon, 
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
        // centerTitle: true,
      ),
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
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(14, 120, 14, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero Section
                      _buildHeroSection(),
                      SizedBox(height: 48),

                      // Email Selection Option
                      // _buildSelectionOption(),
                      // SizedBox(height: 32),

                      // Email Input Section
                      _buildEmailSection(),
                      SizedBox(height: 32),
                      _buildContinueButton(provider),
                      SizedBox(height: 32),

                      CarouselExamplex(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ), 
    // bottomNavigationBar:Consumer<EmailProvider>(
    //       builder: (context, provider, child) { 

    //         // if (provider.selectedEmail.isEmpty) {
    //         //   return SizedBox.shrink();
    //         // }

    //         return Container(
    //           decoration: BoxDecoration(
    //                 color: Colors.transparent,
    //             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    //           ),
    //           child: Padding(
                
    //             padding: const EdgeInsets.all(16.0),
    //             child: ,
    //           ),
    //         );
    //       }
    
    // ),
    );
  }

  Widget _buildHeroSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ShaderMask(
        //   shaderCallback: (bounds) => LinearGradient(
        //     colors: [Color(0xFF6C5CE7), Color(0xFF74B9FF), Color(0xFF00CEC9)],
        //   ).createShader(bounds),
        //   // child: Text(
        //   //   AppConstants.welcomeTitle,
        //   //   style: TextStyle(
        //   //     fontSize: 32,
        //   //     fontWeight: FontWeight.w900,
        //   //     color: Colors.white,
        //   //     height: 1.2,
        //   //   ),
        //   // ),    
        // child: Text.rich(  TextSpan(
        //       text: AppConstants.welcomeTitle,
        //       style: TextStyle(
        //       fontSize: 32,
        //       fontWeight: FontWeight.w900,
        //       color: Colors.white,
        //       height: 1.2,
        //     ),
        //       children: <TextSpan>[
        //         TextSpan(
        //             text:   ' ${AppConstants.appName}',
        //             style: TextStyle(
        //               fontFamily: 'Dmitry',
        //                 // color: Colors.blue,
        //                 // decoration: TextDecoration.underline,
        //                 // decorationColor: Colors.blue
                        
        //                 ),
        //             // recognizer: TapGestureRecognizer()
        //               // ..onTap = () {
        //               //   context.push(
        //               //       '${Routes.termsScreenRoute}?type=${DocumentType.privacy.name}');
        //               // }
        //               )
        //       ]))),

        Row(
          children: [
           
            Text(
              AppConstants.welcomeTitle,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.2,
              ),
            ),
            SizedBox(width: 8),
            ShaderMask (
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
            
          ],
        ),
       
       
        SizedBox(height: 12),
        Text(
          AppConstants.selectionSubtitle,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.7),
            height: 1.5,
          ),
        ),
      ],
    );

  }

  

  Widget _buildSelectionOption() {
    return _buildOptionCard(
      icon: Icons.edit_rounded,
      title: AppConstants.enterManualEmail,
      subtitle: 'Type any email address manually',
      isSelected: true,
      onTap: () {
        // No action needed since there's only one option
      },
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected 
                ? Color(0xFF6C5CE7).withOpacity(0.1) 
                : Color(0xFF1A1A2E).withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected 
                  ? Color(0xFF6C5CE7) 
                  : Colors.white.withOpacity(0.1),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: Color(0xFF6C5CE7).withOpacity(0.3),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ] : [],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: isSelected 
                      ? LinearGradient(
                          colors: [Color(0xFF6C5CE7), Color(0xFF74B9FF)],
                        )
                      : null,
                  color: isSelected ? null : Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
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
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
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
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFF6C5CE7) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? Color(0xFF6C5CE7) : Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.check,
                  color: isSelected ? Colors.white : Colors.transparent,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailSection() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A2E).withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: EmailInputWidget(),
    );
  }
Widget _buildContinueButton(EmailProvider provider) {
  return Consumer<SubscriptionService>(
    builder: (context, subscriptionService, child) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Check if user can scan
      bool canScan = true;
      String limitMessage = '';
      
      if (!authProvider.isLoggedIn) {
        // Guest user
        canScan = !subscriptionService.isGuestLimitExhausted;
        limitMessage = 'Guest users can only scan once. Login for more scans.';
      } else if (!subscriptionService.isProUser) {
        // Logged in but not pro user
        canScan = !subscriptionService.isNotProLimitExhausted;
        limitMessage = 'Free users: ${subscriptionService.searchAttempts}/5 scans used';
      }
      
      bool isEmailValid = !provider.selectedEmail.isEmpty;
      bool shouldEnable = isEmailValid && canScan;
      
      return Column(
        children: [
          // Show limit warning if near limit
          if (authProvider.isLoggedIn && !subscriptionService.isProUser && subscriptionService.searchAttempts >= 3) ...[
            Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Color(0xFFF59E0B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0xFFF59E0B).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: Color(0xFFF59E0B), size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Warning: ${5 - subscriptionService.searchAttempts} scans remaining',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFF59E0B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          // Show limit reached message
          if (!canScan) ...[
            Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Color(0xFFEF4444).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0xFFEF4444).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.block, color: Color(0xFFEF4444), size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      limitMessage,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: shouldEnable ? 
                  [Color(0xFF6C5CE7), Color(0xFF74B9FF)]
                  : [
                    Color(0xFF6C5CE7).withOpacity(0.3), 
                    Color(0xFF74B9FF).withOpacity(0.3)
                  ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ElevatedButton(
              onPressed: shouldEnable ? () async {
                // Increment search attempts before scanning
                subscriptionService.incrementSearchAttempts();
                
                provider.scanEmail(provider.selectedEmail);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScanResultPage(),
                  ),
                );
                // clear 
                // provider.clearSelectedEmail();
              } : () {
                if (!isEmailValid) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter an email to continue.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else if (!canScan) {
                  showLimitReachedDialog(context, authProvider.isLoggedIn);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    shouldEnable ? 'Check My Email Now' : 
                    (!canScan ? 'Upgrade to Continue' : 'Check My Email Now'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    shouldEnable ? Icons.arrow_forward_rounded : Icons.star,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}

  // Widget _buildContinueButton(EmailProvider provider) {
    
  //   return Consumer<SubscriptionService>(
  //   builder: (context, subscriptionService, child) {
  //     final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
  //     // Check if user can scan
  //     bool canScan = true;
  //     String limitMessage = '';
      
  //     if (!authProvider.isLoggedIn) {
  //       // Guest user
  //       canScan = !subscriptionService.isGuestLimitExhausted;
  //       limitMessage = 'Guest users can only scan once. Login for more scans.';
  //     } else if (!subscriptionService.isProUser) {
  //       // Logged in but not pro user
  //       canScan = !subscriptionService.isNotProLimitExhausted;
  //       limitMessage = 'Free users: ${subscriptionService.searchAttempts}/5 scans used';
  //     }
      
  //     bool isEmailValid = !provider.selectedEmail.isEmpty;
  //     bool shouldEnable = isEmailValid && canScan;
  //       return Container(
  //         width: double.infinity,
  //         height: 56,
  //         decoration: BoxDecoration(
  //           gradient: LinearGradient(
  //             colors:!provider.selectedEmail.isEmpty ? 
        
  //              [Color(0xFF6C5CE7), Color(0xFF74B9FF)]
  //               : [
  //                 Color(0xFF6C5CE7).withOpacity(0.3), 
  //                 Color(0xFF74B9FF).withOpacity(0.3)
  //               ],
  //           ),
  //           borderRadius: BorderRadius.circular(16),
           
  //         ),
  //         child: ElevatedButton(
  //           onPressed:!provider.selectedEmail.isEmpty ? () {
  //             provider.scanEmail(provider.selectedEmail);
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => ScanResultPage(),
  //               ),
  //             );
  //           } :  
  //           // show notification or toast
  //           () {
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               SnackBar(
  //                 content: Text('Please enter an email to continue.'),
  //                 duration: Duration(seconds: 2),
  //               ),
  //             );
  //           }
  //           ,
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Colors.transparent,
  //             shadowColor: Colors.transparent,
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(16),
  //             ),
  //           ),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text(
  //                 'Check My Email Now',
  //                 style: TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w600,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //               SizedBox(width: 8),
  //               Icon(
  //                 Icons.arrow_forward_rounded,
  //                 color: Colors.white,
  //                 size: 20,
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     }
  //   );
  // }




}
 
class CarouselExamplex extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<CarouselItem> carouselItems = [
  CarouselItem(
    title: 'email\nbreach check',
    category: 'PRIVACY / SECURITY    INDUSTRY CYBERSECURITY',
    imageUrl: 'https://cdn.pixabay.com/photo/2024/06/21/10/50/ai-generated-8844135_960_720.png',
  ),
  CarouselItem(
    title: 'real-time\nalerts',
    category: 'THREAT MONITORING / NOTIFICATIONS    INDUSTRY PERSONAL SAFETY',
    imageUrl: 'https://media.istockphoto.com/id/1923898010/photo/woman-hand-using-mobile-smartphone-receive-new-message-and-99-new-email-alert-sign-icon-pop-up.jpg?s=612x612&w=0&k=20&c=z7rdOUoiYcQTSa8kpSIeTAHGoaAwoLuh-3FDRS94e9s=',
  ),
  CarouselItem(
    title: 'track\nyour exposure',
    category: 'DATA LEAKS / DARK WEB    INDUSTRY DIGITAL IDENTITY',
    imageUrl: 'https://images.squarespace-cdn.com/content/v1/57f96248d482e9a19e507a7e/1602986856429-NXO6O0FJDJJM2L4OC255/_DSC3413.jpg',
  ),
  CarouselItem(
    title: 'privacy\nmade simple',
    category: 'TRUST / USER-FIRST DESIGN    INDUSTRY MOBILE APP',
    imageUrl: 'https://www.ipvanish.com/wp-content/uploads/2022/06/social-media-privacy-issues_IPV-blog.png',
  ),
];


    // return
    
    return ModernCarousel(
            items: carouselItems,
            height: 200,
            autoPlay: true,
            autoPlayDuration: const Duration(seconds: 4),
          );
  }
}