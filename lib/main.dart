
import 'dart:async';
import 'dart:io';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:news_snack/view/home.dart';
// import 'package:news_snack/view/spalsh.dart';
// import 'firebase_options.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     name: 'news_snack',
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/ic_launcher');
//   final InitializationSettings initializationSettings =
//       InitializationSettings(android: initializationSettingsAndroid);
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;
//     if (notification != null && android != null) {
//       flutterLocalNotificationsPlugin.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             'your_channel_id',
//             'your_channel_name',
//             channelDescription: 'your_channel_description',
//             importance: Importance.max,
//             priority: Priority.high,
//             icon: '@mipmap/ic_launcher',
//           ),
//         ),
//       );
//     }
//   });
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   bool showingSplash = true;
//
//   void loadHome() {
//     Future.delayed(const Duration(seconds: 3), () {
//       setState(() {
//         showingSplash = false;
//       });
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     loadHome();
//     firebaseToken;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'News Snack',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: showingSplash ? const SplashScreen() : const HomeScreen(),
//     );
//   }
// }
//
// Future<String?> get firebaseToken async {
//   try {
//     String? token = await FirebaseMessaging.instance.getToken();
//     debugPrint('Firebase Token Flutter: $token');
//     return token;
//   } catch (error) {
//     debugPrint('Error fetching Firebase Token: ${error.toString()}');
//     return '';
//   }
// }
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   print("Handling a background message: ${message.messageId}");
// }


import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    name: 'news_snack',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;



  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notification channel for basic tests',
        importance: NotificationImportance.High,
        channelShowBadge: true,
      )
    ],
  );


  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    if (notification != null) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: createUniqueId(),
          channelKey: 'basic_channel',
          title: notification.title,
          body: notification.body,
          notificationLayout: NotificationLayout.Default,
        ),
      );
    }
  });

  runApp(const MyApp());



  runZonedGuarded(() {
    runApp(MyApp());
  }, FirebaseCrashlytics.instance.recordError);
}



int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Handling a background message: ${message.messageId}");
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool showingSplash = true;

  void loadHome() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        showingSplash = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadHome();
    firebaseToken;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News Snack',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: showingSplash ? const SplashScreen() : const HomeScreen(),
    );
  }
}

Future<String?> get firebaseToken async {
  try {
    String? token = await FirebaseMessaging.instance.getToken();
    debugPrint('Firebase Token Flutter: $token');
    return token;
  } catch (error) {
    debugPrint('Error fetching Firebase Token: ${error.toString()}');
    return '';
  }
}


class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Splash Screen")),
    );
  }
}


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Screen")),
      body: Center(child: Text("Welcome Home")),
    );
  }
}







// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:news_snack/view/spalsh.dart';
// import 'firebase_options.dart';
// import 'view/home.dart';
//
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     name: 'news_snack',
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//
//   // Initialize Awesome Notifications
//   AwesomeNotifications().initialize(
//     'resource://drawable/res_app_icon', // Replace with your app icon resource
//     [
//       NotificationChannel(
//         channelKey: 'basic_channel',
//         channelName: 'Basic Notifications',
//         channelDescription: 'Notification channel for basic tests',
//         defaultColor: Color(0xFF9D50DD),
//         ledColor: Colors.white,
//         importance: NotificationImportance.High,
//       ),
//     ],
//   );
//
//   // Handle background messages
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   bool showingSplash = true;
//
//   @override
//   void initState() {
//     super.initState();
//     loadHome();
//     requestNotificationPermissions();
//     configureFirebaseListeners();
//   }
//
//   void loadHome() {
//     Future.delayed(const Duration(seconds: 3), () {
//       setState(() {
//         showingSplash = false;
//       });
//     });
//   }
//
//   void requestNotificationPermissions() {
//     AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
//       if (!isAllowed) {
//         AwesomeNotifications().requestPermissionToSendNotifications();
//       }
//     });
//   }
//
//   void configureFirebaseListeners() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//       if (notification != null && android != null) {
//         AwesomeNotifications().createNotification(
//           content: NotificationContent(
//             id: createUniqueId(),
//             channelKey: 'basic_channel',
//             title: notification.title,
//             body: notification.body,
//             notificationLayout: NotificationLayout.Default,
//           ),
//         );
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'News Snack',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: showingSplash ? const SplashScreen() : const HomeScreen(),
//     );
//   }
// }
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   AwesomeNotifications().createNotification(
//     content: NotificationContent(
//       id: createUniqueId(),
//       channelKey: 'basic_channel',
//       title: message.notification?.title,
//       body: message.notification?.body,
//       notificationLayout: NotificationLayout.Default,
//     ),
//   );
// }
//
// int createUniqueId() {
//   return DateTime.now().millisecondsSinceEpoch.remainder(100000);
// }
