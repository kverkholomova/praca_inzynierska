
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wol_pro_1/service/local_push_notifications.dart';
import 'app.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  if (kDebugMode) {
    print('Handling a background message ${message.messageId}');
  }
}

// void foregroundMessage(){
//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//
//     print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALLLLLLLLLLLLLLLLLLLLL");
//     print(message.sentTime);
//   });
//   // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//   //   print('Got a message whilst in the foreground!');
//   //   print('Message data: ${message.data}');
//   //
//   //   if (message.notification != null) {
//   //     print('Message also contained a notification: ${message.notification}');
//   //   }
//   // });
//
// }

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

      // options: FirebaseOptions(
      //   apiKey: "",
      //   appId: "",
      //   messagingSenderId: "",
      //   projectId: "",
      // )
        // options: DefaultFirebaseOptions.currentPlatform,
  );
  LocalNotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });

  runApp( const MyApp());
}


