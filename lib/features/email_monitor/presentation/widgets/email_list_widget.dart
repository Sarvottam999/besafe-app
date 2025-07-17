// // features/email_monitor/presentation/widgets/email_list_widget.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/email_provider.dart';

// class EmailListWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<EmailProvider>(
//       builder: (context, provider, child) {
//         if (provider.state == EmailState.loading) {
//           return _buildLoadingState();
//         }

//         if (provider.state == EmailState.error) {
//           return _buildErrorState(provider);
//         }

//         if (provider.deviceEmails.isEmpty) {
//           return _buildEmptyState();
//         }

//         return _buildEmailList(provider);
//       },
//     );
//   }

//   Widget _buildLoadingState() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           padding: EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF6C5CE7), Color(0xFF74B9FF)],
//             ),
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: SizedBox(
//             width: 24,
//             height: 24,
//             child: CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               strokeWidth: 2,
//             ),
//           ),
//         ),
//         SizedBox(height: 20),
//         Text(
//           'Scanning device for emails...',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//             color: Colors.white,
//           ),
//         ),
//         SizedBox(height: 8),
//         Text(
//           'This may take a moment',
//           style: TextStyle(
//             fontSize: 14,
//             color: Colors.white.withOpacity(0.6),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildErrorState(EmailProvider provider) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           padding: EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Colors.red.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: Colors.red.withOpacity(0.3)),
//           ),
//           child: Icon(
//             Icons.error_outline,
//             color: Colors.red.withOpacity(0.8),
//             size: 32,
//           ),
//         ),
//         SizedBox(height: 20),
//         Text(
//           'Unable to fetch emails',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//           ),
//         ),
//         SizedBox(height: 8),
//         Text(
//           provider.errorMessage,
//           style: TextStyle(
//             fontSize: 14,
//             color: Colors.white.withOpacity(0.6),
//           ),
//           textAlign: TextAlign.center,
//         ),
//         SizedBox(height: 24),
//         Container(
//           width: double.infinity,
//           height: 48,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF6C5CE7), Color(0xFF74B9FF)],
//             ),
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: Color(0xFF6C5CE7).withOpacity(0.3),
//                 blurRadius: 15,
//                 offset: Offset(0, 8),
//               ),
//             ],
//           ),
//           child: ElevatedButton(
//             onPressed: () => provider.fetchDeviceEmails(),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.transparent,
//               shadowColor: Colors.transparent,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.refresh_rounded,
//                   color: Colors.white,
//                   size: 18,
//                 ),
//                 SizedBox(width: 8),
//                 Text(
//                   'Try Again',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildEmptyState() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           padding: EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.05),
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: Colors.white.withOpacity(0.1)),
//           ),
//           child: Icon(
//             Icons.inbox_outlined,
//             color: Colors.white.withOpacity(0.6),
//             size: 32,
//           ),
//         ),
//         SizedBox(height: 20),
//         Text(
//           'No emails found',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//           ),
//         ),
//         SizedBox(height: 8),
//         Text(
//           'No email accounts detected on this device',
//           style: TextStyle(
//             fontSize: 14,
//             color: Colors.white.withOpacity(0.6),
//           ),
//           textAlign: TextAlign.center,
//         ),
//         SizedBox(height: 24),
//         Container(
//           padding: EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.05),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: Colors.white.withOpacity(0.1)),
//           ),
//           child: Row(
//             children: [
//               Icon(
//                 Icons.lightbulb_outline,
//                 color: Color(0xFF74B9FF),
//                 size: 20,
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   'Try using manual input to enter an email address',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.white.withOpacity(0.7),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildEmailList(EmailProvider provider) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Header
//         Row(
//           children: [
//             Container(
//               padding: EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Color(0xFF6C5CE7), Color(0xFF74B9FF)],
//                 ),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(
//                 Icons.phone_android_rounded,
//                 color: Colors.white,
//                 size: 16,
//               ),
//             ),
//             SizedBox(width: 12),
//             Text(
//               'Device Emails',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white,
//               ),
//             ),
//             Spacer(),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: Color(0xFF6C5CE7).withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Color(0xFF6C5CE7).withOpacity(0.3)),
//               ),
//               child: Text(
//                 '${provider.deviceEmails.length} found',
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                   color: Color(0xFF6C5CE7),
//                 ),
//               ),
//             ),
//           ],
//         ),

//         // SizedBox(height: 20),

//         // Email List
//         ListView.separated(
//           shrinkWrap: true,
//           physics: NeverScrollableScrollPhysics(),
//           itemCount: provider.deviceEmails.length,
//           separatorBuilder: (context, index) => SizedBox(height: 12),
//           itemBuilder: (context, index) {
//             final email = provider.deviceEmails[index];
//             final isSelected = provider.selectedEmail == email;

//             return AnimatedContainer(
//               duration: Duration(milliseconds: 300),
//               curve: Curves.easeInOut,
//               decoration: BoxDecoration(
//                 color: isSelected 
//                     ? Color(0xFF6C5CE7).withOpacity(0.1)
//                     : Color(0xFF1A1A2E).withOpacity(0.3),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(
//                   color: isSelected 
//                       ? Color(0xFF6C5CE7)
//                       : Colors.white.withOpacity(0.1),
//                   width: isSelected ? 2 : 1,
//                 ),
//                 boxShadow: isSelected ? [
//                   BoxShadow(
//                     color: Color(0xFF6C5CE7).withOpacity(0.3),
//                     blurRadius: 20,
//                     offset: Offset(0, 10),
//                   ),
//                 ] : [],
//               ),
//               child: Material(
//                 color: Colors.transparent,
//                 child: InkWell(
//                   onTap: () {
//                     provider.setSelectedEmail(email);
//                   },
//                   borderRadius: BorderRadius.circular(16),
//                   child: Container(
//                     padding: EdgeInsets.all(16),
//                     child: Row(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             gradient: isSelected 
//                                 ? LinearGradient(
//                                     colors: [Color(0xFF6C5CE7), Color(0xFF74B9FF)],
//                                   )
//                                 : null,
//                             color: isSelected ? null : Colors.white.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Icon(
//                             Icons.email_outlined,
//                             color: Colors.white,
//                             size: 20,
//                           ),
//                         ),
//                         SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 email,
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               SizedBox(height: 4),
//                               Text(
//                                 'Tap to select this email',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.white.withOpacity(0.6),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         AnimatedContainer(
//                           duration: Duration(milliseconds: 300),
//                           padding: EdgeInsets.all(2),
//                           decoration: BoxDecoration(
//                             color: isSelected ? Color(0xFF6C5CE7) : Colors.transparent,
//                             borderRadius: BorderRadius.circular(10),
//                             border: Border.all(
//                               color: isSelected ? Color(0xFF6C5CE7) : Colors.white.withOpacity(0.3),
//                               width: 2,
//                             ),
//                           ),
//                           child: Icon(
//                             Icons.check,
//                             color: isSelected ? Colors.white : Colors.transparent,
//                             size: 16,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),

//         SizedBox(height: 20),

//         // Info Footer
//         Container(
//           padding: EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.05),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: Colors.white.withOpacity(0.1)),
//           ),
//           child: Row(
//             children: [
//               Icon(
//                 Icons.info_outline,
//                 color: Color(0xFF74B9FF),
//                 size: 20,
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   'Select an email account to monitor for security breaches',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.white.withOpacity(0.7),
//                     height: 1.4,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }