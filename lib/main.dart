// main.dart
import 'package:besafe/core/constants/Ntheme.dart';
import 'package:besafe/features/auth/presentation/pages/login_page.dart';
import 'package:besafe/features/auth/presentation/providers/auth_provider.dart';
import 'package:besafe/features/email_monitor/background/check_and_notify.dart';
import 'package:besafe/features/email_monitor/data/models/breach_model.dart';
import 'package:besafe/features/email_monitor/data/models/email_model.dart';
import 'package:besafe/features/email_monitor/presentation/pages/onboarding_page.dart';
import 'package:besafe/features/email_monitor/presentation/pages/pro_screen.dart';
import 'package:besafe/features/email_monitor/services/permission_handler.dart';
import 'package:besafe/features/email_monitor/services/subscription_service.dart';
import 'package:besafe/features/navigation/config/navigation_config.dart';
import 'package:besafe/features/navigation/widget/bottom_navigation_bar.dart';
import 'package:besafe/features/profile/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'core/constants/app_constants.dart';
import 'features/email_monitor/presentation/pages/email_selection_page.dart';
import 'features/email_monitor/presentation/providers/email_provider.dart';
import 'injection_container.dart' as di;

const String checkEmailTask_table_key = "check_monitored_emails";
const String monitored_emails_table_key = "monitored_emails";

Future<void> initializeApp() async {
  try {
    await Hive.initFlutter();
    Hive.registerAdapter(EmailModelAdapter());
    Hive.registerAdapter(BreachModelAdapter());

    await Hive.openBox<EmailModel>(monitored_emails_table_key);
    await di.init();
  } catch (e) {
    debugPrint('App initialization error: $e');
    rethrow;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<EmailProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<SubscriptionService>()),
        ChangeNotifierProvider(create: (_) => NavigationController()),
        ChangeNotifierProvider(create: (_) => di.sl<AuthProvider>()), // Add this

      ],
      
      child: MaterialApp(
          routes: {
 
    '/login': (context) => LoginPage(),
    '/home': (context) => EmailSelectionPage(), // ✅ <-- define this
    '/onboarding': (context) => OnBoardingPage(),
    // Add more routes as needed
  }, 

        theme: getAppTheme(),
        title: AppConstants.appName,
               home: Consumer2<SubscriptionService, AuthProvider>(
          builder: (context, subscriptionService, authProvider, child) {
            // Show loading while checking auth status
            if (authProvider.isLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
             // Show onboarding if not completed
            if (!subscriptionService.hasCompletedOnboarding) {
              return OnBoardingPage();
            }
            

            // If not logged in, show login/signup page
            if (!authProvider.isLoggedIn) {
              return EmailSelectionPage(); // You'll need to create this page
            }

           
            // After onboarding, show permission handler with navigation
            return PermissionHandler(
              onPermissionsGranted: () {
                debugPrint('###✅ All permissions granted!');
              },
              onPermissionsDenied: () {
                debugPrint('###❌ Permissions denied');
              },
              child: NavigationWrapper(
                navigationItems: NavigationConfig.getNavigationItems(),
              ),
            );
          },
        ), 
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

//----------------------------   old    ----------------------------------

// // Global notification plugin instance
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = 
//     FlutterLocalNotificationsPlugin();

// Future<void> initNotifications() async {
//   try {
//     const android = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const iOS = DarwinInitializationSettings(
//       requestSoundPermission: true,
//       requestBadgePermission: true,
//       requestAlertPermission: true,
//     );
//     const settings = InitializationSettings(
//       android: android,
//       iOS: iOS,
//     );
    
//     await flutterLocalNotificationsPlugin.initialize(settings);
    
//     // Request permissions for Android 13+
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestNotificationsPermission();
//   } catch (e) {
//     debugPrint('Error initializing notifications: $e');
//   }
// }

// void callbackDispatcher() {
//   debugPrint("## Callback Dispatcher started");
  
//   Workmanager().executeTask((task, inputData) async {
//     try {
//       debugPrint("## Background task executed: $task");
      
//       if (task == checkEmailTask) {
//         // Implement your background email checking logic here
//         await checkAndNotifyBreaches();
//       }
      
//       return Future.value(true);
//     } catch (e) {
//       debugPrint("Background task error: $e");
//       return Future.value(false);
//     }
//   });
// }

// Future<void> initializeApp() async {
//   try {
//     // Initialize Hive
//     await Hive.initFlutter();
//     Hive.registerAdapter(EmailModelAdapter());
//     await Hive.openBox<EmailModel>('monitored_emails');
    
//     // Initialize dependency injection
//     await di.init();
    
//     // Initialize notifications
//     await initNotifications();
    
//     // Initialize background tasks
//     await initBackgroundTasks();
    
//   } catch (e) {
//     debugPrint('App initialization error: $e');
//     rethrow;
//   }
// }

// Future<void> initBackgroundTasks() async {
//   try {
//     // Initialize WorkManager
//     Workmanager().initialize(
//       callbackDispatcher,
//       isInDebugMode: true, // Set to false in production
//     );
    
//     // Register periodic task
//     final String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();
//     await Workmanager().registerPeriodicTask(
//       uniqueId,
//       checkEmailTask,
//       frequency: const Duration(hours: 24),
//       constraints: Constraints(
//         networkType: NetworkType.connected,
//         requiresBatteryNotLow: true,
//       ),
//     );
//   } catch (e) {
//     debugPrint('Background task initialization error: $e');
//   }
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
  
//   // Initialize app with error handling
//   await initializeApp();
  
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => di.sl<EmailProvider>()),
//         ChangeNotifierProvider(create: (_) => di.sl<SubscriptionService>()),
//       ],
//       child: MaterialApp(
//         theme: getAppTheme(),
//         title: AppConstants.appName,
//         home: Consumer<SubscriptionService>(
//           builder: (context, subscriptionService, child) {
//             // Show onboarding if not completed
//             if (!subscriptionService.hasCompletedOnboarding) {
//               return   OnBoardingPage();
//             }
//             return   EmailSelectionPage();
//           },
//         ),
//         debugShowCheckedModeBanner: false,
//       ),
//     );
//   }
// }

//--------------------------------------------------------------

// class DebugMonitoredEmailsScreen extends StatefulWidget {
//   @override
//   _DebugMonitoredEmailsScreenState createState() =>
//       _DebugMonitoredEmailsScreenState();
// }

// class _DebugMonitoredEmailsScreenState
//     extends State<DebugMonitoredEmailsScreen> {
//   List<EmailModel> emails = [];

//   void loadEmails() {
//     final box = Hive.box<EmailModel>('monitored_emails');
//     print("## box ==> $box");
//     setState(() {
//       emails = box.values.toList();
//       print("## emails ==> $emails");
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     loadEmails();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Monitored Emails")),
//       body: ListView.builder(
//         itemCount: emails.length,
//         itemBuilder: (context, index) {
//           final email = emails[index];
//           return ListTile(
//             title: Text(email.email,
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold, color: Colors.white)),
//             subtitle: Text("Last Scanned: ${email.lastScanned}"),
//             trailing: Icon(
//               email.isBreached ? Icons.warning : Icons.check,
//               color: email.isBreached ? Colors.red : Colors.green,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
 